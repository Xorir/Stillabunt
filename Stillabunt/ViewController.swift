//
//  ViewController.swift
//  Stillabunt
//
//  Created by Lord Summerisle on 2/4/18.
//  Copyright © 2018 ErmanMaris. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var latitude: CLLocationDegrees? = nil
    var longitude: CLLocationDegrees? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationCoordinates: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locationCoordinates.latitude) \(locationCoordinates.longitude)")
        latitude = locationCoordinates.latitude
        longitude = locationCoordinates.longitude
        locationManager.stopUpdatingLocation()
    }
}

