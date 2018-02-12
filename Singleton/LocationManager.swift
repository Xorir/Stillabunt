//
//  LocationManager.swift
//  Stillabunt
//
//  Created by Lord Summerisle on 2/11/18.
//  Copyright © 2018 ErmanMaris. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    static let sharedInstance = LocationManager()
    var locationValues: CLLocationCoordinate2D?
    var postalCode: String?
    var administrativeArea: String?
    var locality: String?
    var areaOfInterest: String?
    var name: String?
    var thoroughfare: String?
    var address: String?
    var country: String?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    func formatAddress(name: String, areaOfInterest: String, administrativeArea: String) -> String {
        return name + " " + areaOfInterest + " " + " " + administrativeArea
    }
}
