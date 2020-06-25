//
//  GoogleApiTests.swift
//  IOS ChallengeTests
//
//  Created by Din Vu Dinh on 6/25/20.
//  Copyright © 2020 Din Vu Dinh. All rights reserved.
//

import XCTest
import SwiftyJSON



@testable import IOS_Challenge
class GoogleApiTests: XCTestCase {

    func checkValueModel() throws{
        let path = Bundle.main.path(forResource: "PlaceJSON", ofType: "json")
        let data = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
        let dataJson = try JSON(data: data)
        var listPlaces = [PlaceModel]()
        if let resJsons = dataJson["results"].array{
            for resJson in resJsons{
                let place = PlaceModel.init(json: resJson)
                if !place.id.isEmpty{
                    listPlaces.append(place)
                }
            }
        }
        XCTAssert(listPlaces.count == 1)
        XCTAssert(listPlaces.first?.id == "8d629878fcede53ac23cae0c898aff1e1a98bf61")
        XCTAssert(listPlaces.first?.lat == 21.0277644)
        XCTAssert(listPlaces.first?.long == 105.8341598)
    }

}
