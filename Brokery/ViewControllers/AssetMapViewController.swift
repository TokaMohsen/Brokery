
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

struct MyPlace {
    var name: String
    var lat: Double
    var long: Double
}

class AssetMapViewController: UIViewController {

    @IBOutlet var googleMapView: GMSMapView!
    
    @IBOutlet var saveBtnAction: UIBarButtonItem!
    
    // A default location to use when location permission is not granted.
    let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    var locationManager = CLLocationManager()
    var chosenPlace: MyPlace?
    var marker = GMSMarker()
    var mapDelegate : MapDelegateProtocol?
    
    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "some_text", style: .done, target: self, action: #selector(self.action(sender:)))
        // Initialize the location manager.
        locationManager = CLLocationManager()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
//
//        placesClient = GMSPlacesClient.shared()
        
        // Create a map.
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: 10.0)
        
        googleMapView.camera = camera
        self.showMarker(position: googleMapView.camera.target)
        googleMapView.delegate = self
//        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
//        mapView.settings.myLocationButton = true
//        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        googleMapView.isMyLocationEnabled = true
        
    }
    
    @objc func action(sender: UIBarButtonItem) {
        // Function body goes here
        print("save")
    }
  
    
    
    private func showMarker(position : CLLocationCoordinate2D)
    {
        marker.position = position
        marker.title = "your location here"
        marker.snippet = "address"
        marker.map = googleMapView
        marker.isDraggable = true
        drawCircle()
        chosenPlace?.lat = position.latitude
        chosenPlace?.long = position.longitude
        if let title =  marker.title {
            chosenPlace?.name = title }
    }
    @IBAction func saveBtnAction(_ sender: UIBarButtonItem) {
        if let placePos = chosenPlace
        {
            let pos = CLLocationCoordinate2D(latitude: placePos.lat, longitude: placePos.long)
            mapDelegate?.updateAssetDetailsLocation(assetLocation: pos)
        }

    }
    
//private func takeSnapshot() {
//    UIGraphicsBeginImageContextWithOptions(googleMapView.bounds.size , true , 0)
//    googleMapView.drawHierarchy(in: googleMapView.bounds, afterScreenUpdates: true)
//    let screenShot = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage(named: "defaultAsset")!
//    UIGraphicsEndImageContext()
//   
////    // Take a snapshot of the map.
////    UIGraphicsBeginImageContextWithOptions(_mapView.bounds.size, YES, 0);
////    [_mapView drawViewHierarchyInRect:_mapView.bounds afterScreenUpdates:YES];
////    UIImage *mapSnapShot = UIGraphicsGetImageFromCurrentImageContext();
////    UIGraphicsEndImageContext();
////
////    // Put snapshot image into an UIImageView and overlay on top of map.
////    UIImageView *imageView = [[UIImageView alloc] initWithImage:mapSnapShot];
////    imageView.layer.borderColor = [UIColor redColor].CGColor;
////    imageView.layer.borderWidth = 10.0f;
////    [_mapView addSubview:imageView];
////
////    // Remove imageView after 1 second.
////    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
////    [UIView animateWithDuration:1
////    animations:^{
////    imageView.alpha = 0.0f;
////    }
////    completion:^(BOOL finished) {
////    [imageView removeFromSuperview];
////    }];
////    });
//    }
    
    
}
extension AssetMapViewController : GMSMapViewDelegate , CLLocationManagerDelegate
{
    func mapViewSnapshotReady(_ mapView: GMSMapView) {
        print("took snapshot")
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("clicked on marker")
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("end dragging")
        drawCircle()

    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        marker.position = coordinate
    }
    func drawCircle()
    {
        let circlePos = marker.position
        let circle = GMSCircle(position: circlePos, radius: 1)
        circle.map = googleMapView
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