//
//  LocationManager.swift
//  IOS Challenge
//
//  Created by Din Vu Dinh on 6/25/20.
//  Copyright © 2020 Din Vu Dinh. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject{
    static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    private var locationCallback: ((_ location: CLLocation)->Void)?
    
    override init() {
        super.init()
        self.requestAuthorization()
    }
    private func requestAuthorization() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
    }
    func getCurrentLocation(completion: @escaping(CLLocation)->Void){
        locationManager.startUpdatingLocation()
        locationCallback = { location in
            completion(location)
        }
    }
}
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.count)
        guard let userLocation = locations.first else {return}
        if let callback = self.locationCallback{
            callback(userLocation)
            self.locationCallback = nil
        }
        manager.stopUpdatingLocation()
        print("latitude = \(userLocation.coordinate.latitude) and longitude = \(userLocation.coordinate.longitude)")
        
    }
    
}
