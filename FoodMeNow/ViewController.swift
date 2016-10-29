//
//  ViewController.swift
//  FoodMeNow
//
//  Created by Michael Lu on 10/23/16.
//  Copyright © 2016 foodmenow. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager = CLLocationManager()
    var userLocation: CLLocation!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.delegate = self
//        locationManager.requestAlwaysAuthorization()
//        
//        
//        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

        userLocation = locationManager.location
        

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager( _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        
        let latestLocation: AnyObject = locations[locations.count - 1]
        
        if userLocation == nil {
            userLocation = latestLocation as! CLLocation
        }
        
        //camera
        let camera = GMSCameraPosition.camera(withLatitude:userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, zoom: 16.0)
        let mapView = GMSMapView.map(withFrame:CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView
        
        //map
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        
    }
    

}

