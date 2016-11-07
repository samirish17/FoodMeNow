//
//  TodayViewController.swift
//  FMNWidget
//
//  Created by Sam Irish on 10/23/16.
//  Copyright © 2016 foodmenow. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation
import Foundation


class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate {
    var locationManager: CLLocationManager = CLLocationManager()
    var userLocation: CLLocation!
    var locs: JSON!
    var current: Int!
    @IBOutlet weak var typeOf: UIImageView!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var miles: UILabel!
    
    @IBAction func Next(_ sender: AnyObject) {
        self.current = self.current + 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.current = 0
        locationManager.delegate = self
        
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        userLocation = locationManager.location
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.startUpdatingLocation()
        
        userLocation = locationManager.location
        
    }
    
    private func widgetPerformUpdate(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        locationManager.startUpdatingLocation()
        
        userLocation = locationManager.location
        
        if (self.locs != nil) {
            self.place.text = self.locs["results"][self.current]["name"].string
        }
        
        completionHandler(NCUpdateResult.newData)
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
            //let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //print("responseString = \(responseString)")
            
            self.locs = JSON(data: data!)
            self.place.text = self.locs["results"][self.current]["name"].string
            print(self.locs["results"][0]["name"])
            print("-----------------------------------------------")
            
            let placelocation = CLLocation(latitude: self.locs["results"][0]["geometry"]["location"]["lat"].double!, longitude: self.locs["results"][0]["geometry"]["location"]["lng"].double!)
            
            let distanceInMiles = placelocation.distance(from: self.userLocation)/1609.344
            
            self.miles.text = String(round(distanceInMiles*100)/100)+" Miles";
            
            // Convert server json response to NSDictionary
//            do {
//                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
//                    
//                    // Print out dictionary
//                    //print(convertedJsonIntoDict["results"])
//                    print("made it")
//                    
//                }
//            } catch let error as NSError {
//                print(error.localizedDescription)
//            }
            
        }
        
        task.resume()
    }
}
