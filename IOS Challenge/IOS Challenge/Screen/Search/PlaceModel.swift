//
//  PlaceModel.swift
//  IOS Challenge
//
//  Created by Din Vu Dinh on 6/24/20.
//  Copyright © 2020 Din Vu Dinh. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

let database = try! Realm()
class PlaceModel: Object{
    private struct ParamsKey {
        static let id = "id"
        static let address = "formatted_address"
        static let icon = "icon"
        static let name = "name"
        static let placeId = "place_id"
        static let geometry = "geometry"
        static let location = "location"
        static let lat = "lat"
        static let long = "lng"
        static let vicinity = "vicinity"
    }
    
    
    @objc dynamic var id: String = ""
    @objc dynamic var name = ""
    @objc dynamic var address = ""
    @objc dynamic var icon: String?
    @objc dynamic var placeId = ""
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var long: Double = 0.0
    
    
    
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience required init(json: JSON) {
        self.init()
        self.id = json[ParamsKey.id].string ?? ""
        if let address = json[ParamsKey.address].string{
            self.address = address
        }else{
            self.address = json[ParamsKey.vicinity].string ?? ""
        }
        self.icon = json[ParamsKey.icon].string
        self.name = json[ParamsKey.name].string ?? ""
        self.placeId = json[ParamsKey.placeId].string ?? ""
        let location = json[ParamsKey.geometry][ParamsKey.location]
        self.lat = location[ParamsKey.lat].double ?? 0.0
        self.long = location[ParamsKey.long].double ?? 0.0
    }
}
