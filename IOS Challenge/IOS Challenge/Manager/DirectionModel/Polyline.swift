//
//  Polyline.swift
//  IOS Challenge
//
//  Created by Din Vu Dinh on 6/25/20.
//  Copyright © 2020 Din Vu Dinh. All rights reserved.
//

import Foundation
import ObjectMapper

struct Polyline: Mappable {
    
    var points = ""
    
    init() {
    }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        points  <- map["points"]
    }
    
}

