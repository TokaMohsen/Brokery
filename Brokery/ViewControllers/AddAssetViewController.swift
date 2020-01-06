//
//  AddAssetViewController.swift
//  Brokery
//
//  Created by ToqaMohsen on 11/14/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit
import iOSDropDown
import Alamofire
import CoreLocation

class AddAssetViewController: BaseViewController, UIPickerViewDelegate ,UINavigationControllerDelegate , UICollectionViewDelegate , UICollectionViewDataSource , UIImagePickerControllerDelegate  , MapDelegateProtocol {
    
    
    @IBOutlet var assetAddressTextField: UITextField!
    @IBOutlet var assetNameTextField: UITextField!
    @IBOutlet var assetDescriptionTextField: UITextField!
    @IBOutlet var hashtagTextField: UITextField!
    @IBOutlet var assetTypeDropdownTextField: DropDown!
    
    @IBOutlet var hashtagUIView: UIView!
    @IBOutlet var hashtagCollectionView: UICollectionView!
    
    @IBOutlet var imageCollectionView: UICollectionView!
    var imageController : UIImagePickerController?
    
    
    var assetlocationCoord : CLLocationCoordinate2D?
    var assetAddress : String?
    var assetTypesList = [String]()
    var hashtags = [String]()
    var assetImages = [UIImage]()
    var assetModel : AssetModel?
    let hashtagCollectionViewIdentifier = "hashtagCell"
    let assetImagesCollectionViewIdentifier = "imageCell"
    
    var assetId : String?
    var assetType : String?
    
    let assetMapVC = AssetMapViewController()
    
    static let sharedWebClient = WebClient.init(baseUrl: BaseAPIURL)
    private lazy var assetTypesListService = AssetTypesListGetService()
    private lazy var createAssetPostService = CreateAssetPostService()
    private lazy var addAssetAggregatedService = AddAssetAggregatedService()
    
    var getAssetTypesListTask: URLSessionDataTask!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //image picker
        imageController = UIImagePickerController()
        imageController?.delegate = self
        imageController?.allowsEditing = true
        imageController?.mediaTypes = ["public.image", "public.movie"]
        
        //get data , collection views
        fetchAssetTypesList()
        hashtagCollectionView.register(UINib(nibName: "AssetHashtagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: hashtagCollectionViewIdentifier)
        imageCollectionView.register(UINib(nibName: "AssetImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: assetImagesCollectionViewIdentifier)
        
        //delegates
        hashtagCollectionView.dataSource = self
        hashtagCollectionView.delegate = self
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(title: "Add Asset")
    }
    
    @IBAction func hashtagBtnAction(_ sender: UIButton) {
        if let hashtag = hashtagTextField.text
        {
            if !hashtag.isEmpty {
                hashtags.append(hashtag)
            }
            hashtagTextField.text = ""
        }
        hashtagCollectionView.reloadData()
    }
    @IBAction func setLocationBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Assets", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "AssetMapViewController") as? AssetMapViewController {
            viewController.mapDelegate = self
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func addPhotoBtnAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose", message: "Gallery or take photo", preferredStyle: .actionSheet)
        let gallery = UIAlertAction(title: "Choose from gallery", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        
        let phototake = UIAlertAction(title: "Take your photo", style: .default) { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        alert.addAction(gallery)
        alert.addAction(phototake)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveBtnAction(_ sender: UIButton) {
        // activityIndicator.startAnimating()

        createAsset()
    }
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        showAlert(with: "Are you sure u want to discard changes? ", title: "Alert")
        
    }
    
    func fetchAssetTypesList()
    {
        getAssetTypesListTask?.cancel()
        
        
        let userinfo = Resource<AssetObject , CustomError>(jsonDecoder: JSONDecoder(), path: GetAssetTypeListURL, method: .get)
        
        
        self.assetTypesListService.fetch(params: userinfo.params, method: .get, url: GetAssetTypeListURL) { (response, error) in
            if let mappedResponse = response
            {
                // self.assetTypesList = mappedResponse.compactMap({String($0)})
                self.assetTypesList = mappedResponse.compactMap({$0.name})
                self.assetTypeDropdownTextField.optionArray = self.assetTypesList
                self.assetTypeDropdownTextField.selectedRowColor = .lightGray
                self.assetTypeDropdownTextField.didSelect { (selectedItem, index, id) in
                    self.assetTypeDropdownTextField.text = selectedItem
                    self.assetId = String( mappedResponse[index].id )
                }
            } else if error != nil {
                self.assetTypeDropdownTextField.optionArray = [ "Types are unavailable"]
                self.assetTypeDropdownTextField.selectedRowColor = .lightGray
                
                self.showErrorAlert(with: "server error while getting asset types" , title: "Error")
            }
        }
    }
    
    func createAsset()
    {
        getAssetTypesListTask?.cancel()
        
        // activityIndicator.startAnimating()
        
        var userinfo = Resource<AssetObject , CustomError>(jsonDecoder: JSONDecoder(), path: createAssetURL, method: .post)
        
        if let assetId = self.assetId
        {
            userinfo.params["assetId"] = assetId
        }
        if let assetType = self.assetType
        {
            userinfo.params["AssetTypeId"] = assetType
        }
        if let name = assetNameTextField.text
        {
            userinfo.params["Title"] = name
        }
        if let description = assetDescriptionTextField.text
        {
            userinfo.params["Description"] = description
        }
        if let coordinates = self.assetlocationCoord
        {
            userinfo.params["Latitude"] = coordinates.latitude
            userinfo.params["Longitude"] = coordinates.longitude
        }
        if let address = self.assetAddress
        {
            userinfo.params["Address"] = address
        }
        
        userinfo.params["Tages"] = self.hashtags
        
        self.addAssetAggregatedService.fetchRequest(assetImages: self.assetImages, assetId: self.assetId, createAssetParams: userinfo.params) { (statusResult, error) in
            if statusResult?.data == true
            {
                let storyboard = UIStoryboard(name: "Assets", bundle: nil)
                if let viewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
            else
            {
                self.showErrorAlert(with: "Server error, Please try again later" , title: "Error")
            }
        }
    }
    
    private func setupAssetTypeMenu( assetTypes : [String])
    {
        assetTypeDropdownTextField.showList()
    }
    
    private func showAlert(with message: String , title : String) {
        let alert = UIAlertController(title: title , message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default,  handler: { (action) in
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
        })
        let cancleAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancleAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    private func showErrorAlert(with message: String , title : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension AddAssetViewController {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // imageViewPic.contentMode = .scaleToFill
        
        //imageViewPic.image = pickedImage
        //tempPickedImg = selectedImage
        
        picker.dismiss(animated: true, completion: nil)
        assetImages.append(selectedImage)
        imageCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.hashtagCollectionView {
            return hashtags.count == 0 ? 1 : hashtags.count
        }
        else{
            return self.assetImages.count == 0 ? 1 : self.assetImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.hashtagCollectionView {
            
            guard let cellHashtag = collectionView.dequeueReusableCell(withReuseIdentifier: hashtagCollectionViewIdentifier, for: indexPath) as? AssetHashtagCollectionViewCell
                else {
                    return UICollectionViewCell()}
            // Set up cell
            if self.hashtags.count > 0 {
                cellHashtag.setup(hashtag: hashtags[indexPath.row])
            }
            else
            {
                cellHashtag.setup(hashtag: "#REBS")
            }
            return cellHashtag
        }
        else
        {
            guard let cellAssetImage = collectionView.dequeueReusableCell(withReuseIdentifier: assetImagesCollectionViewIdentifier, for: indexPath) as? AssetImageCollectionViewCell else {
                return UICollectionViewCell()
            }
            // ...Set up cell
            if self.assetImages.count > 0 {
                cellAssetImage.setup(image: self.assetImages[indexPath.row])
            }
            else {
                cellAssetImage.setup(image: "testImage")
            }
            
            return cellAssetImage
        }
    }
    
    
    func updateAddAssetLocation(assetLocation: String) {
        assetAddressTextField.text = assetLocation
        self.assetAddress = assetLocation
    }
    
    func updateAssetDetailsLocation(assetLocation: CLLocationCoordinate2D) {
        assetlocationCoord = CLLocationCoordinate2D(latitude: assetLocation.latitude , longitude: assetLocation.longitude)
       
    }
    
}
