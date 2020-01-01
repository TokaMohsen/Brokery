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

class AddAssetViewController: BaseViewController, UIPickerViewDelegate ,UINavigationControllerDelegate , UICollectionViewDelegate , UICollectionViewDataSource {

    
    @IBOutlet var assetAddressTextField: UITextField!
    @IBOutlet var assetNameTextField: UITextField!
    @IBOutlet var assetDescriptionTextField: UITextField!
    @IBOutlet var hashtagTextField: UITextField!
    @IBOutlet var assetTypeDropdownTextField: DropDown!
    
    @IBOutlet var hashtagUIView: UIView!
    @IBOutlet var hashtagCollectionView: UICollectionView!
    
    var imageController : UIImagePickerController?
    var tempPickedImg : UIImage?
    var assetTypesList = [String]()
    var hashtags = [String]()
    var assetModel : AssetModel?
    static let sharedWebClient = WebClient.init(baseUrl: BaseAPIURL)
    private lazy var assetTypesListService = AssetTypesListGetService()
    var getAssetTypesListTask: URLSessionDataTask!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageController = UIImagePickerController()
        imageController?.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate;
        
        fetchAssetTpesList()
        hashtagCollectionView.register(UINib(nibName: "AssetHashtagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "hashtagCell")
        hashtagCollectionView.dataSource = self
        hashtagCollectionView.delegate = self
        

    }
    
    @IBAction func hashtagBtnAction(_ sender: UIButton) {
        if let hashtag = hashtagTextField.text
        {
            hashtags.append(hashtag)
            hashtagTextField.text = ""
        }
        hashtagCollectionView.reloadData()
    }
    @IBAction func setLocationBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func addPhotoBtnAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose", message: "Gallery or take photo", preferredStyle: .actionSheet)
        let gallery = UIAlertAction(title: "Choose from gallery", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
                imagePicker.allowsEditing = true
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        
        let Phototake = UIAlertAction(title: "Take your photo", style: .default) { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func fetchAssetTpesList()
    {
        getAssetTypesListTask?.cancel()
        
       // activityIndicator.startAnimating()
        
        let userinfo = Resource<AssetObject , CustomError>(jsonDecoder: JSONDecoder(), path: GetAssetTypeListURL, method: .get)
        
        
        self.assetTypesListService.fetch(params: userinfo.params, method: .get, url: GetAssetTypeListURL) { (response, error) in
            if let mappedResponse = response
            {
                self.assetTypesList = mappedResponse

                self.assetTypeDropdownTextField.optionArray = self.assetTypesList
                self.assetTypeDropdownTextField.selectedRowColor = .lightGray
                self.assetTypeDropdownTextField.didSelect { (selectedItem, index, id) in
                    self.assetTypeDropdownTextField.text = selectedItem
                       }
            } else if error != nil {
                self.showAlert(with: "error" , title: "server error")
            }
        }
    }
    
    @IBAction func saveBtnAction(_ sender: UIButton) {
        
    }
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        showAlert(with: "Are you sure u want to discard changes? ", title: "Alert")
    
    }
    private func setupAssetTypeMenu( assetTypes : [String])
    {
        //        //// The list of array to display. Can be changed dynamically , testing
        //        //Its Id Values and its optional
        //        dropDown.optionIds = [1,23,54,22]
        
        assetTypeDropdownTextField.optionArray = ["Option 1", "Option 2", "Option 3"]
        
        // The the Closure returns Selected Index and String
        //        dropDown.didSelect{(selectedText , index ,id) in
        //            //            self.valueLabel.text = "Selected String: \(selectedText) \n index: \(index)"
        //            //        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // imageViewPic.contentMode = .scaleToFill
        
        //imageViewPic.image = pickedImage
        tempPickedImg = selectedImage
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func setupImagesCollection()
    {
        
    }
    
    private func showAlert(with message: String , title : String) {
        let alert = UIAlertController(title: title , message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hashtags.count == 0 ? 1 : hashtags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellHashtag = collectionView.dequeueReusableCell(withReuseIdentifier: "hashtagCell", for: indexPath) as? AssetHashtagCollectionViewCell
            else {
                return UICollectionViewCell()}
        // Set up cell
        if self.hashtags.count > 0 {
            cellHashtag.setup(hashtag: hashtags[indexPath.row])
        }
        else
        {
             cellHashtag.setup(hashtag: "REBS")
        }
        return cellHashtag
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
