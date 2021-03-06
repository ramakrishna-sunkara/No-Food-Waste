//
//  DonateViewController.swift
//  NoFoodWaste
//
//  Created by Ravi Shankar on 28/11/15.
//  Copyright © 2015 Ravi Shankar. All rights reserved.
//

import UIKit
import MapKit

class DonateViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var addressTextView: UITextView!

    @IBOutlet weak var locSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.title = "Donate Food Now"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(true)
        getCurrentLocation()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        navigationItem.title = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func mapLocation(sender: AnyObject) {
    
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y -= 160
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y -= 160
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }

}

extension DonateViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0] 
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            
            let address = locality! + "\n" + administrativeArea! +  "\n" + postalCode! + "\n" + country!
            
            addressTextView.text = address
        }
        
    }
    
    @IBAction func getCurrentLocation(sender: AnyObject) {
 
    }
    
    @IBAction func currentLocation(sender: AnyObject) {
        
        let locationSwitch = sender as! UISwitch
        
        if locationSwitch.on {
            getCurrentLocation()
        } else {
            
        }
    }
    
    func getCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
}
