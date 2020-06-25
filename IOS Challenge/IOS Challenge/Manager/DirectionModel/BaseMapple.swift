//
//  BaseMapple.swift
//  IOS Challenge
//
//  Created by Din Vu Dinh on 6/25/20.
//  Copyright © 2020 Din Vu Dinh. All rights reserved.
//

import Foundation
import ObjectMapper

struct BaseMapple: Mappable {
    
    var geocodedWaypoints = [GeocodedWaypoint]()
    var routes = [Route]()
    var status = ""
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        geocodedWaypoints <- map["geocoded_waypoints"]
        routes            <- map["routes"]
        status            <- map["status"]
    }
    
}

