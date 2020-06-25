//
//  Step.swift
//  IOS Challenge
//
//  Created by Din Vu Dinh on 6/25/20.
//  Copyright © 2020 Din Vu Dinh. All rights reserved.
//

import Foundation
import ObjectMapper

struct Step: Mappable {
    
    var distance = GoogleMapValue()
    var duration = GoogleMapValue()
    var endLocation = Location()
    var htmlInstructions = ""
    var polyline = Polyline()
    var startLocation = Location()
    var travelMode = ""
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        distance            <- map["distance"]
        duration            <- map["duration"]
        endLocation         <- map["end_location"]
        htmlInstructions    <- map["html_instructions"]
        polyline            <- map["polyline"]
        startLocation       <- map["start_location"]
        travelMode          <- map["travel_mode"]
    }
    
}
