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
var locs: JSON!

class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate {
    var userLocation: CLLocation!
    
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitiudeLabel: UILabel!
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func performWidget()
    {
        print("---------------hi------------------")
        if currentLocation != nil {
            let latitudeText = String(format: "Lat: %.4f",
                                      currentLocation!.coordinate.latitude)
            
            let longitudeText = String(format: "Lon: %.4f",
                                       currentLocation!.coordinate.longitude)
            
            latitiudeLabel.text = latitudeText
            longitudeLabel.text = longitudeText
        }
        else {
            print("uh oh")
            latitiudeLabel.text = "no location?"
            longitudeLabel.text = "oops"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        performWidget()
    }
    
    private func widgetPerformUpdate(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        /*locationManager.delegate = self
        
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        userLocation = locationManager.location
        
        print("assigning")
        self.restaurantName.text = "test" + "\n\nDistance"
        self.imgFoodType.image = UIImage(named: "rightarrow")
        self.distance.text = "0.99999mi"*/
        
        performWidget()
        
        completionHandler(NCUpdateResult.newData)
    }
    
    private func locationManager(manager: CLLocationManager!,
                         didUpdateLocations locations: [AnyObject]!)
    {
        currentLocation = locations[locations.count - 1]
            as? CLLocation
    }
    
    /*func locationManager( _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
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
            
            locs = JSON(data: data!)
            
            print(locs["results"][0]["name"])
            print("-----------------------------------------------")
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
    }*/
}
