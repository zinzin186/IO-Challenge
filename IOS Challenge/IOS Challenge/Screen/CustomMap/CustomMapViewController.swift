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
    private func getCurrentLocation() {
        LocationManager.shared.getCurrentLocation {[weak self] (location) in
            guard let strongSelf = self else {return}
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            strongSelf.mapView.camera = GMSCameraPosition(latitude: latitude, longitude: longitude, zoom: strongSelf.cameraZoom)
        }
    }
    @objc private func gotoSearch(){
        self.navigationController?.popViewController(animated: true)
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
