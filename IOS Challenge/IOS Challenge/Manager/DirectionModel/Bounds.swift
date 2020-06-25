//
//  Bounds.swift
//  IOS Challenge
//
//  Created by Din Vu Dinh on 6/25/20.
//  Copyright © 2020 Din Vu Dinh. All rights reserved.
//

import Foundation
import ObjectMapper

struct Bounds: Mappable {
    
    var northeast = Location()
    var southwest = Location()
    
    init() {
    }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        northeast   <- map["northeast"]
        southwest   <- map["southwest"]
    }
    
}
struct Location: Mappable {
    
    var latitude = 0.0
    var longtidude = 0.0
    
    init() {
    }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        latitude    <- map["lat"]
        longtidude  <- map["lng"]
    }
    
}
