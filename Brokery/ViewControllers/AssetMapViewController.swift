
//
//  AssetMapViewController.swift
//  Brokery
//
//  Created by ToqaMohsen on 12/10/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

let kGOOGLE_API_KEY = "AIzaSyB4ZQQHSyPdVdY3q4rK5SZ1zlXdeAT9S1w"

struct MyPlace {
    var name: String
    var lat: Double
    var long: Double
    var title : String
}

class AssetMapViewController: BaseViewController , UISearchBarDelegate{
    
    @IBOutlet var googleMapView: GMSMapView!
    
    @IBOutlet var saveBtnAction: UIBarButtonItem!
    
    // A default location to use when location permission is not granted.
    let defaultLocation = CLLocation(latitude: 30.033333, longitude: 31.233334)
    var locationManager = CLLocationManager()
    var chosenPlace: MyPlace?
    var marker = GMSMarker()
    var mapDelegate : MapDelegateProtocol?
    var addressString : String?
    
    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        //        // Create a map.
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: 10.0)
        
        googleMapView.camera = camera
        self.showMarker(position: googleMapView.camera.target)
        
        googleMapView.delegate = self
        googleMapView.isMyLocationEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(title: "Map")
    }
    
    @objc func action(sender: UIBarButtonItem) {
        // Function body goes here
        print("save")
    }
    
    private func showMarker(position : CLLocationCoordinate2D)
    {
        let geocoder = CLGeocoder()
        let currentLocation = CLLocation(latitude: position.latitude, longitude: position.longitude)
        geocoder.reverseGeocodeLocation(currentLocation, completionHandler: {
            placemarks, error in
            if let  placemarks = placemarks {
                
                if error == nil && placemarks.count > 0 {
                    let name = placemarks[0].name
                    DispatchQueue.main.async {
                        self.marker.title = name
                        
                        let array = placemarks[0].addressDictionary?["FormattedAddressLines"] as! [String]
                        self.marker.snippet  = array.joined(separator:",")
                        self.marker.map = self.googleMapView
                        self.marker.position = position
                    }
                }
            }
        })
        
        marker.isDraggable = true
        
        if let title =  marker.title {
            chosenPlace = MyPlace(name: marker.snippet ?? title, lat: position.latitude, long: position.longitude, title: title)
            if let snippet = marker.snippet{
                addressString = title + snippet
            }
        }
    }
    
    @IBAction func saveBtnAction(_ sender: UIBarButtonItem) {
        if let placePos = chosenPlace
        {
            let pos = CLLocationCoordinate2D(latitude: placePos.lat, longitude: placePos.long)
            mapDelegate?.updateAssetDetailsLocation(assetLocation: pos)
            mapDelegate?.updateAddAssetLocation(assetLocation: marker.snippet ?? "")
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
        }
        
    }
    
}
extension AssetMapViewController : GMSMapViewDelegate , CLLocationManagerDelegate
{
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("clicked on marker")
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("end dragging")
    }
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        marker.position = coordinate
        self.showMarker(position: marker.position)
    }
    
    func drawCircle()
    {
        DispatchQueue.main.async {
            let circlePos = self.marker.position
            let circle = GMSCircle(position: circlePos, radius: 10)
            
            circle.map = self.googleMapView
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        
        googleMapView.isMyLocationEnabled = true
        googleMapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        googleMapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        locationManager.stopUpdatingLocation()
    }
}
