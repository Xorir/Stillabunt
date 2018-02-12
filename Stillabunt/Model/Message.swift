//
//  Message.swift
//  Stillabunt
//
//  Created by Lord Summerisle on 2/12/18.
//  Copyright © 2018 ErmanMaris. All rights reserved.
//

import Foundation

public struct Message {
    
    let latitude: Double?
    let longitude: Double?
    let message: String?
    
    init?(userDictionary: NSDictionary) {
        latitude = userDictionary.value(forKeyPath: "latitude") as? Double
        longitude = userDictionary.value(forKeyPath: "longitude") as? Double
        message = userDictionary.value(forKeyPath: "message") as? String
    }
}
