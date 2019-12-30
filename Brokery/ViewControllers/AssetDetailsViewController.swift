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

class AssetDetailsViewController: UIViewController , MapDelegateProtocol {
    
    @IBOutlet var assetNameLabel: UILabel!
    
    @IBOutlet var assetDescriptionLabel: UILabel!
    
    @IBOutlet var hashtagCollectionView: UICollectionView!
    
    @IBOutlet var assetImagesCollectionView: UICollectionView!
    
    
    @IBOutlet var mapView: GMSMapView!
    
    
    var assetModel : AssetDto?
    var assetTages : [String] = []
    var assetGallery : [String] = []
    
    let hashtagCollectionViewIdentifier = "hashtagCell"
    let assetImagesCollectionViewIdentifier = "imageCell"
    var marker = GMSMarker()
    
 
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
        }
    }
    
    func updateAssetDetailsLocation(assetLocation: CLLocationCoordinate2D) {
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
            self.assetDescriptionLabel.text =  asset.description
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

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using se(gue.destination.
     //)! Pass the selected object to the new view controller.
     }
     */
    
}
extension AssetDetailsViewController : UICollectionViewDelegate , UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.hashtagCollectionView {
                return self.assetTages.count
        }
        return self.assetGallery.count == 0 ? 1 : self.assetGallery.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.hashtagCollectionView {
            guard let cellHashtag = collectionView.dequeueReusableCell(withReuseIdentifier: hashtagCollectionViewIdentifier, for: indexPath) as? AssetHashtagCollectionViewCell
                else {
                    return UICollectionViewCell()}
                // Set up cell
            cellHashtag.setup(hashtag: assetTages[indexPath.row])
                return cellHashtag
        } else {
            guard let cellAssetImage = collectionView.dequeueReusableCell(withReuseIdentifier: assetImagesCollectionViewIdentifier, for: indexPath) as? AssetImageCollectionViewCell else {
                    return UICollectionViewCell()
            }
                // ...Set up cell
            if self.assetGallery.count > 0 {
                cellAssetImage.setup(assetImagePath: self.assetGallery[indexPath.row])
            } else {
                if let image = UIImage(named: "testImage") {
                    cellAssetImage.setup(image: image)
                }
            }
            
            return cellAssetImage
        }
    }
    
}
