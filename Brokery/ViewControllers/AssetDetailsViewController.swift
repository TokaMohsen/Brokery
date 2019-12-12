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
    
    @IBOutlet var assetLocationImageView: UIImageView!
    
     var assetModel : AssetDto?
     var assetTages : [String]?
     var assetGallery : [AssetGalleryDto]?
    
    let hashtagCollectionViewIdentifier = "hashtagCell"
    let assetImagesCollectionViewIdentifier = "imageCell"
    var marker = GMSMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hashtagCollectionView.delegate = self
        assetImagesCollectionView.delegate = self
        
        hashtagCollectionView.dataSource = self
        assetImagesCollectionView.dataSource = self
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
    
    func setupAssetView(asset : AssetDto)
    {
        if let asset = assetModel{
            if let tages = asset.tages
            {
                self.assetTages = tages
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
            if let tages = self.assetTages{
                return tages.count
            }
            return 0
        }
        if let imagesList = self.assetGallery{
            return imagesList.count
        }
       
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.hashtagCollectionView {
            let cellHashtag = collectionView.dequeueReusableCell(withReuseIdentifier: hashtagCollectionViewIdentifier, for: indexPath) as UICollectionViewCell
            
            // Set up cell
            return cellHashtag
        }
            
        else {
            let cellAssetImage = collectionView.dequeueReusableCell(withReuseIdentifier: assetImagesCollectionViewIdentifier, for: indexPath) as UICollectionViewCell
            
            // ...Set up cell
            
            return cellAssetImage
        }
        
    }
    
    
}
