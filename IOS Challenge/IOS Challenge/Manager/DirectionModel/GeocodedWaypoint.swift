//
//  GeocodedWaypoint.swift
//  IOS Challenge
//
//  Created by Din Vu Dinh on 6/25/20.
//  Copyright © 2020 Din Vu Dinh. All rights reserved.
//

import Foundation
import ObjectMapper

struct GeocodedWaypoint: Mappable {
    
    var geocoderStatus = ""
    var placeId = ""
    var types = [String]()
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        geocoderStatus <- map["geocoder_status"]
        placeId        <- map["place_id"]
        types          <- map["types"]
    }
    
}
