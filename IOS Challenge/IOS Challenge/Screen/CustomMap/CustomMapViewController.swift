//
//  CustomMapViewController.swift
//  IOS Challenge
//
//  Created by Din Vu Dinh on 6/25/20.
//  Copyright © 2020 Din Vu Dinh. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

protocol CustomMapViewDelegate: class {
    func selectedPlace(_ place: PlaceModel)
}

class CustomMapViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    private let cameraZoom: Float = 15
    
    weak var delegate: CustomMapViewDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select a location"
        self.configMapView()
        self.getCurrentLocation()
        self.setupNavi()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    private func configMapView(){
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        self.mapView.delegate = self
    }
    private func setupNavi(){
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(gotoSearch))
        self.navigationItem.rightBarButtonItem = searchButton
    }
    @objc private func gotoSearch(){
        self.navigationController?.popViewController(animated: true)
    }
   private func getCurrentLocation(){
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                break
            case .authorizedAlways, .authorizedWhenInUse:
                checkLocationAuthorizationStatus()
            @unknown default:
                    break
            }
        }
    }
    func checkLocationAuthorizationStatus() {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.startUpdatingLocation()
    }
}
extension CustomMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.count)
        let userLocation = locations.first!
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        mapView.camera = GMSCameraPosition(latitude: latitude, longitude: longitude, zoom: cameraZoom)
        manager.stopUpdatingLocation()
        print("latitude = \(latitude) and longitude = \(longitude)")
        
    }
    
}
extension CustomMapViewController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        ShowViewFromWindow.shared.showListPlace(lat: coordinate.latitude, long: coordinate.longitude, mapView: mapView) { (place) in
            print(place.name)
            self.navigationController?.popToRootViewController(animated: true)
            self.delegate?.selectedPlace(place)
        }
    }
    
}
