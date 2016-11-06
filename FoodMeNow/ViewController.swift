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
        
        let resourceURI = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" + String(userLocation.coordinate.latitude) + "," + String(userLocation.coordinate.longitude) + "&rankby=distance&type=restaurant&key=AIzaSyB1A692Ft8OD3PCfNTUZChXi1GS0q6urkA";
        
        
        let myURL = NSURL(string: resourceURI)
        
        let request = NSMutableURLRequest(url:myURL as! URL)
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            // let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //print("responseString = \(responseString)")
            
            
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    // Print out dictionary
                    print(convertedJsonIntoDict["results"])
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
        
        
    }
    

}

