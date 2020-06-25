//
//  GoogleMapApi.swift
//  IOS Challenge
//
//  Created by Din Vu Dinh on 6/24/20.
//  Copyright © 2020 Din Vu Dinh. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import GoogleMaps

class GoogleMapApi: NSObject {
    
    
    static let shared = GoogleMapApi()
    
    var direction: DirectionOverview?
    var selectLegs = [Leg]()
    var selectSteps = [Step]()
    var originCoordinate: CLLocationCoordinate2D?
    var destinationCoordinate: CLLocationCoordinate2D?
    var totalDistanceInMeters = 0
    var totalDistance: String {
        return "TotalDistance" + "\(totalDistanceInMeters/1000) Km"
    }
    var totalDurationInSeconds = 0
    var totalDuration: String {
        return "TotalDuration" + "\(totalDurationInSeconds/86400) days, " +
            "\((totalDurationInSeconds/3600)%24) hours, " +
            "\((totalDurationInSeconds/60)%60) mins, " +
        "\(totalDurationInSeconds%60) secs"
    }
    
    
    func getListAddresBySearch(keyword: String, completion: @escaping([PlaceModel]?)->Void){
        guard let encodeString = keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        let requestURLString = "https://maps.googleapis.com/maps/api/place/textsearch/json?key=\(GoogleConfig.APIKey)&query=" + encodeString
        AF.request(requestURLString,method:.get,parameters: nil)
            .responseJSON { response in
                switch(response.result) {
                case .success(let value):
                    var listPlaces = [PlaceModel]()
                    let dataJson = JSON(value)
                    if let resJsons = dataJson["results"].array{
                        for resJson in resJsons{
                            let place = PlaceModel.init(json: resJson)
                            if !place.id.isEmpty{
                                listPlaces.append(place)
                            }
                        }
                    }
                    completion(listPlaces)
                case .failure(/*let error*/_):
                    completion(nil)
                }
        }
    }
    func getNearByPlace(lat: Double, long: Double, completion: @escaping([PlaceModel]?)->Void){
        let requestURLString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(long)&radius=5000&key=\(GoogleConfig.APIKey)"
        AF.request(requestURLString,method:.get,parameters: nil)
            .responseJSON { response in
                switch(response.result) {
                case .success(let value):
                    var listPlaces = [PlaceModel]()
                    let dataJson = JSON(value)
                    if let resJsons = dataJson["results"].array{
                        for resJson in resJsons{
                            let place = PlaceModel.init(json: resJson)
                            if !place.id.isEmpty{
                                listPlaces.append(place)
                            }
                        }
                    }
                    completion(listPlaces)
                case .failure(/*let error*/_):
                    completion(nil)
                }
        }
    }
   private func escape(string: String) -> String {
       let allowedCharacters = string.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: ":=\"#%/<>?@\\^`{|}").inverted) ?? ""
       return allowedCharacters
   }
    func getDirections(origin: String?,
                       destination: String?, travelMode: TravelModes,
                       getDirectionStatus: @escaping ((_ success: Bool) -> Void)) {
        guard let originAddress = origin else {
            getDirectionStatus(false)
            return
        }
        guard let destinationAddress = destination else {
            getDirectionStatus(false)
            return
        }
        let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
        var directionsURLString = baseURLDirections + "origin=" +
            originAddress + "&destination=" + destinationAddress
        directionsURLString += "&mode=" + travelMode.rawValue + "&key=" + GoogleConfig.APIKey
        self.parseJsonGoogleMap(directionsURLString: directionsURLString)
        { (success) in
            if success {
                print("parse ok")
                getDirectionStatus(true)
            } else {
                getDirectionStatus(false)
            }
        }
    }
    func parseJsonGoogleMap(directionsURLString: String,
                            completion: @escaping ((_ success: Bool) -> Void)) {
        if let directionsURL = URL(string: directionsURLString) {
            DispatchQueue.global(qos: .userInitiated).async {
                guard let jsonString = try? String(contentsOf: directionsURL),
                    let direction = DirectionOverview(JSONString: jsonString),
                    direction.status != "" else {
                        completion(false)
                        return
                }
                self.direction = direction
                var success = false
                if direction.status == "OK" {
                    if !direction.routes.isEmpty {
                        if direction.routes[0].overviewPolyline.points != "",
                            !direction.routes[0].legs.isEmpty,
                            !direction.routes[0].legs[0].steps.isEmpty {
                            self.selectLegs = direction.routes[0].legs
                            let result = self.calculateTotalDistanceAndDuration()
                            success = result
                        }
                    }
                }
                completion(success)
            }
        } else {
            completion(false)
            return
        }
    }
    func calculateTotalDistanceAndDuration() -> Bool {
        self.selectSteps = []
        var status = false
        for leg in self.selectLegs {
            for step in leg.steps {
                self.selectSteps.append(step)
                if let distance = step.distance.value,
                    let duration = step.duration.value {
                    totalDistanceInMeters = totalDistanceInMeters + distance
                    totalDurationInSeconds = totalDurationInSeconds + duration
                }
            }
        }
        status = true
        return status
    }
}
