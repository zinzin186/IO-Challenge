//
//  Leg.swift
//  IOS Challenge
//
//  Created by Din Vu Dinh on 6/25/20.
//  Copyright © 2020 Din Vu Dinh. All rights reserved.
//

import Foundation
import ObjectMapper

struct Leg: Mappable {
    
    var distance = GoogleMapValue()
    var duration = GoogleMapValue()
    var endAddress = ""
    var endLocation = Location()
    var startAddress = ""
    var startLocation = Location()
    var steps = [Step]()
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        distance           <- map["distance"]
        duration           <- map["duration"]
        endAddress         <- map["end_address"]
        endLocation        <- map["end_location"]
        startAddress       <- map["start_address"]
        startLocation      <- map["start_location"]
        steps              <- map["steps"]
    }
    
}
struct GoogleMapValue: Mappable {
    
    var text = ""
    var value: Int?
    
    init() {
    }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        text    <- map["text"]
        value   <- map["value"]
    }
    
}
