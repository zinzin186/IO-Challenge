//
//  MapViewController.swift
//  IOS Challenge
//
//  Created by Din Vu Dinh on 6/23/20.
//  Copyright © 2020 Din Vu Dinh. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation


class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var containerView: UIView!
    var optionMapView: OptionMapView?
    private let cameraZoom: Float = 15
    private let bottomPadding: CGFloat = 180
    private var currentTravelMode = TravelModes.car
    private var fromPlace: PlaceModel?{
        didSet{
            guard let place = self.fromPlace else {return}
            self.optionMapView?.fromLocationTextField.text = place.name
            self.optionMapView?.checkInput()
            self.showPlace(place: place, isFromPosition: true)
        }
    }
    private var toPlace: PlaceModel?{
        didSet{
            guard let place = self.toPlace else {return}
            self.optionMapView?.toLocationTextField.text = place.name
            self.optionMapView?.checkInput()
            self.showPlace(place: place, isFromPosition: false)
        }
    }
    private var fromMaker: GMSMarker?
    private var toMarker: GMSMarker?
    
    private var currentRoutePolyline = [GMSPolyline]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configMapView()
        self.getCurrentLocation()
        self.setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    private func setupView(){
        self.containerView.layer.cornerRadius = 5.0
        self.containerView.layer.borderColor = UIColor.lightGray.cgColor
        self.containerView.layer.borderWidth = 1.0
        self.containerView.clipsToBounds = true
        self.addOptionMapView()
    }
    private func addOptionMapView(){
        self.optionMapView = OptionMapView()
        optionMapView?.delegate = self
        optionMapView?.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(optionMapView!)
        optionMapView?.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        optionMapView?.leftAnchor.constraint(equalTo: self.containerView.leftAnchor).isActive = true
        optionMapView?.rightAnchor.constraint(equalTo: self.containerView.rightAnchor).isActive = true
        optionMapView?.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor).isActive = true
    }
    
    private func showAlertWhenDisableGPS(){
        let alert = UIAlertController(title: "", message: "Ứng dụng không xác định được vị trí của bạn. Vui lòng vào cài đặt để bật định vị", preferredStyle: .alert)
        let settingAction = UIAlertAction(title: "Cài đặt", style: .default) {[weak self] (_) in
            self?.gotoSettingApp()
        }
        alert.addAction(settingAction)
        let cancelAction = UIAlertAction(title: "Thoát", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    private func gotoSettingApp(){
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {return}
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
    private func configMapView(){
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = false
        self.mapView.settings.compassButton = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: bottomPadding + 20, right: 20)
    }

    
    private func getCurrentLocation() {
        LocationManager.shared.getCurrentLocation {[weak self] (location) in
            guard let strongSelf = self else {return}
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            strongSelf.mapView.camera = GMSCameraPosition(latitude: latitude, longitude: longitude, zoom: strongSelf.cameraZoom)
        }
    }
    
}

extension MapViewController: OptionMapDelegate{
    func showDirection(travelMode: TravelModes) {
        self.currentTravelMode = travelMode
        direction(travelMode: travelMode)
    }
    
    func revertPosition() {
        let fPlace = self.fromPlace
        let tPlace = self.toPlace
        self.fromPlace = tPlace
        self.toPlace = fPlace
        direction(travelMode: currentTravelMode)
    }
    
    func inputFromLocation() {
        let vc = SearchViewController(nibName: "SearchViewController", bundle: nil)
        vc.resultCallback = { [weak self] place in
            guard let strongSelf = self else {return}
            strongSelf.fromPlace = place
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func inputToLocation() {
        let vc = SearchViewController(nibName: "SearchViewController", bundle: nil)
        vc.resultCallback = { [weak self] place in
            guard let strongSelf = self else {return}
            strongSelf.toPlace = place
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func showPlace(place: PlaceModel, isFromPosition: Bool){
        mapView.camera = GMSCameraPosition(latitude: place.lat, longitude: place.long, zoom: cameraZoom)
        let placeLocation = CLLocationCoordinate2D(latitude: place.lat, longitude: place.long)
        let maker = GMSMarker(position: placeLocation)
        maker.icon = isFromPosition ? UIImage(named: "location_pin_blue"): UIImage(named: "location_pin")
        maker.title = place.name
        maker.snippet = place.address
        maker.map = mapView
        if isFromPosition{
            self.fromMaker?.map = nil
            self.fromMaker = maker
        }else{
            self.toMarker?.map = nil
            self.toMarker = maker
        }
    }
    
}
extension MapViewController{
    private func direction(travelMode: TravelModes) {
        if travelMode == .bicycle{
            showAlertWhenNoRoute()
            return
        }
        guard let fromPlace = self.fromPlace, let toPlace = self.toPlace else {return}
        let origin: String = "\(fromPlace.lat),\(fromPlace.long)"
        let destination: String =
        "\(toPlace.lat),\(toPlace.long)"
        GoogleMapApi.shared.getDirections(origin: origin,
            destination: destination,
            travelMode: travelMode) { [weak self] (success) in
            if success {
                DispatchQueue.main.async {
                    self?.drawRoute(travelMode: travelMode)
                }
            } else {
                self?.showAlertWhenNoRoute()
            }
        }
    }
    private func drawRoute(travelMode: TravelModes) {
        self.removeOldPolyline()
        for step in GoogleMapApi.shared.selectSteps {
            if step.polyline.points != "" {
                let path = GMSPath(fromEncodedPath: step.polyline.points)
                let routePolyline = GMSPolyline(path: path)
                routePolyline.strokeColor = travelMode.lineColor
                routePolyline.strokeWidth = 4.0
                routePolyline.map = mapView
                self.currentRoutePolyline.append(routePolyline)
            } else {
                return
            }
        }
    }
    private func afterDirection() {
        GoogleMapApi.shared.totalDistanceInMeters = 0
        GoogleMapApi.shared.totalDurationInSeconds = 0
        GoogleMapApi.shared.selectLegs.removeAll()
        GoogleMapApi.shared.selectSteps.removeAll()
    }
    private func removeOldPolyline(){
        for i in 0..<self.currentRoutePolyline.count{
            self.currentRoutePolyline[i].map = nil
        }
        currentRoutePolyline.removeAll()
    }
    func showAlertWhenNoRoute(){
        let alert = UIAlertController(title: "Alert", message: "No route found!", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
