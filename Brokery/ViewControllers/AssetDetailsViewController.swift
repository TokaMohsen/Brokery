//
//  AssetDetailsViewController.swift
//  Brokery
//
//  Created by ToqaMohsen on 12/6/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import iOSDropDown
import ReadMoreTextView

class AssetDetailsViewController: BaseViewController {
    
    @IBOutlet var dropDownList: DropDown!
    @IBOutlet var assetNameLabel: UILabel!
    
    @IBOutlet weak var assetDescriptionText: ReadMoreTextView!
    
    @IBOutlet var hashtagCollectionView: UICollectionView!
    
    @IBOutlet var assetImagesCollectionView: UICollectionView!
    @IBOutlet weak var assetImagePage: UIPageControl!
    
    
    @IBOutlet var mapView: GMSMapView!
    
    static let sharedWebClient = WebClient.init(baseUrl: BaseAPIURL)
    private lazy var favouriteAssetService = AddFavoriteAssetPostService()

    var postFavouriteAssetTask: URLSessionDataTask!
    
    var assetModel : AssetDto?
    var assetTages : [String] = []
    var assetGallery : [String] = [] {
        didSet {
            assetImagePage.numberOfPages = assetGallery.count
        }
    }
    
    let hashtagCollectionViewIdentifier = "hashtagCell"
    let assetImagesCollectionViewIdentifier = "imageCell"
    var marker = GMSMarker()
    
    @IBAction func menuBtnAction(_ sender: UIButton) {
          let options = ["Add Appointment" , "Share Asset" , "Edit Asset" , "Favorite Asset"]
         dropDownList.showList()
        dropDownList.selectedRowColor = .lightGray
                dropDownList.optionArray = options
                       dropDownList.didSelect { (selectedItem, index, id) in
                        self.handleDropDownMenuSectionsNavigation(index: index)
                       }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hashtagCollectionView.register(UINib(nibName: "AssetHashtagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: hashtagCollectionViewIdentifier)
        assetImagesCollectionView.register(UINib(nibName: "AssetImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: assetImagesCollectionViewIdentifier)
        hashtagCollectionView.delegate = self
        assetImagesCollectionView.delegate = self
        
        hashtagCollectionView.dataSource = self
        assetImagesCollectionView.dataSource = self
        if let asset = self.assetModel
        {
            setupAssetView(asset: asset )
            if let lat = asset.latitude , let long = asset.longitude
            {
                let assetLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
                addAssetDetailsLocation(assetLocation:assetLocation )
            }
        }
        
        #warning("Test Data")
        assetGallery = ["testImage", "testAvatar", "testImage", "testAvatar"]
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(title: "Asset Details")
    }
    
    func addAssetDetailsLocation(assetLocation: CLLocationCoordinate2D) {
        setupMapView(lang: assetLocation.longitude, lat: assetLocation.latitude)
    }
    
    private func setupMapView(lang : Double , lat: Double)
    {
        // Create a map.
        let camera = GMSCameraPosition.camera(withLatitude: lat,
                                              longitude: lang,
                                              zoom: 10.0)
        mapView.camera = camera
        self.showMarker(position: mapView.camera.target)
    }
    
    private func showMarker(position : CLLocationCoordinate2D)
    {
        marker.position = position
        marker.title = "your location here"
        marker.snippet = "address"
        marker.map = mapView
        marker.isDraggable = true
    }
    
    func getAssetModel(asset : AssetDto)
    {
        self.assetModel = asset
    }
    
    func setupAssetView(asset : AssetDto)
    {
        if let asset =  self.assetModel
        {
            assetNameLabel.text =  asset.title
            self.assetDescriptionText.text =  asset.description
            self.assetDescriptionText.text = "SPANTECH storage units are easy and fast to build and offer an exceptionnal eave height and span capabilities that even traditional construction cannot offer. SPANTECH storage units are easy and fast to build and offer an exceptionnal eave height and span capabilities that even traditional construction cannot offer. SPANTECH storage units are easy and fast to build and offer an exceptionnal eave height and span capabilities that even traditional construction cannot offer. SPANTECH storage units are easy and fast to build and offer an exceptionnal eave height and span capabilities that even traditional construction cannot offer. SPANTECH storage units are easy and fast to build and offer an exceptionnal eave height and span capabilities that even traditional construction cannot offer. SPANTECH storage units are easy and fast to build and offer an exceptionnal eave height and span capabilities that even traditional construction cannot offer. "
            
            if let lat =  asset.latitude , let long =  asset.longitude
            {
                self.setupMapView(lang: lat, lat: long)
            }
            if let tages =  asset.tages
            {
                self.assetTages = tages
            }
         
            if let imageGallery =  asset.assetGallery
            {
                let Paths = imageGallery.compactMap({return $0.path})
                self.assetGallery = Paths.map({return BaseAPIURL + $0 })
            }
        }
    }
    
    func handleDropDownMenuSectionsNavigation(index : Int)
    {
        var vcIdentifier : String?
        
        switch index {
        case 0:
            if let asset =  self.assetModel
            {
                let storyboard = UIStoryboard(name: "Appointments", bundle: nil)
                if let viewController = storyboard.instantiateViewController(withIdentifier: "AddAppointmentViewController" ) as? AddAppointmentViewController {
                    viewController.getAssetModel(asset: asset)
                    
                    navigationController?.pushViewController(viewController, animated: true)
                }
            }
        case 1:
            if let asset =  self.assetModel
            {
                let storyboard = UIStoryboard(name: "Assets", bundle: nil)
                if let viewController = storyboard.instantiateViewController(withIdentifier: "AddAppointmentViewController" ) as? AddAppointmentViewController {
                    
                    viewController.getAssetModel(asset: asset)
                    
                    navigationController?.pushViewController(viewController, animated: true)
                }
            }
        case 2:
            if let asset =  self.assetModel
            {
                let storyboard = UIStoryboard(name: "Assets", bundle: nil)
                if let viewController = storyboard.instantiateViewController(withIdentifier: "AddAssetViewController" ) as? AddAssetViewController {
                    viewController.assetModel = asset
                    //viewController.editAssetModel(asset: asset)
                    
                    navigationController?.pushViewController(viewController, animated: true)
                }
            }
        case 3:
            self.addFavouriteAsset()
        default:
            showConfirmationAlert(with: "Asset has been added to favorite list successfully")
        }
    }
    
    private func addFavouriteAsset()
    {
        postFavouriteAssetTask?.cancel()
//        DispatchQueue.main.async {
//            self.activityIndicator.startAnimating()
//        }
        var userinfo = Resource<FavoriteAssetObject , CustomError>(jsonDecoder: JSONDecoder(), path: favouriteAssetURL, method: .post)
        
        userinfo.params = ["AssetID": self.assetModel?.id]
    
        
        self.favouriteAssetService.fetch(params: userinfo.params, method: .post, url: favouriteAssetURL) { (response, error) in
//            DispatchQueue.main.async {
//                //            self.activityIndicator.hidesWhenStopped = true
//                self.activityIndicator.stopAnimating()
//            }
            
            if let mappedResponse = response
            {
                self.showConfirmationAlert(with: "Asset has been added to favorite list successfully")

            } else if error != nil {
                //controller.handleError(error)
                DispatchQueue.main.async {
                self.showErrorAlert(with: "error", title: "server error")
                }
            }
        }
    }
    
    
    
     func showConfirmationAlert(with message: String) {
        let alert = UIAlertController(title: "Confirmation", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using se(gue.destination.
     //)! Pass the selected object to the new view controller.
     }
     */
    
}

extension AssetDetailsViewController : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if collectionView == self.hashtagCollectionView {
            if  self.assetTages.count == 0  {
                return 1
            } else {
                return self.assetTages.count
            }
           // return self.assetTages.count == 0 ? 1 : self.assetTages.count
        }
        return self.assetGallery.count == 0 ? 1 : self.assetGallery.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.hashtagCollectionView {
            return CGSize(width: 73 , height:  35)
        }
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.hashtagCollectionView {
            guard let cellHashtag = collectionView.dequeueReusableCell(withReuseIdentifier: hashtagCollectionViewIdentifier, for: indexPath) as? AssetHashtagCollectionViewCell
                else {
                    return UICollectionViewCell()}
            // Set up cell
            if self.assetTages.count > 0 {
                cellHashtag.setup(hashtag: assetTages[indexPath.row])
            }
            else
            {
                cellHashtag.setup(hashtag: "REBS")
            }
            return cellHashtag
        }
        else {
            guard let cellAssetImage = collectionView.dequeueReusableCell(withReuseIdentifier: assetImagesCollectionViewIdentifier, for: indexPath) as? AssetImageCollectionViewCell else {
                return UICollectionViewCell()
            }
            // ...Set up cell
            if self.assetGallery.count > 0 {
                cellAssetImage.setup(image: self.assetGallery[indexPath.row])
            }
            else {
                cellAssetImage.setup(image: "testImage")
            }
            
            return cellAssetImage
        }
    }
    
}

extension AssetDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.updateCurrentPageIndex()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.updateCurrentPageIndex()
    }
    
    private func updateCurrentPageIndex() {
        self.assetImagePage.currentPage = getCurrentIndex()
    }
    
    private func getCurrentIndex() -> Int {
        guard let assetImagesCollectionView = self.assetImagesCollectionView else {
            return 0
        }
        let index:Int = Int(assetImagesCollectionView.contentOffset.x / assetImagesCollectionView.frame.width)
        return index
    }
}
