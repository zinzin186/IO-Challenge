//
//  NearPlaceView.swift
//  IOS Challenge
//
//  Created by Din Vu Dinh on 6/25/20.
//  Copyright © 2020 Din Vu Dinh. All rights reserved.
//

import UIKit
import GoogleMaps

protocol NearPlaceDelegate: class {
    func selectPlace(_ place: PlaceModel)
}

class NearPlaceView: UIView{
    var view: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    
    private let cellId = "CellId"
    weak var delegate: NearPlaceDelegate?
    private var listPlaces: [PlaceModel]?
    private let lat: Double
    private let long: Double
    let mapView: GMSMapView
    init(lat:Double, long: Double, mapView: GMSMapView) {
        self.lat = lat
        self.long = long
        self.mapView = mapView
        super.init(frame: .zero)
        self.setup()
        self.setupView()
    }
    
    var listMarker = [GMSMarker]()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setup(){
        view = loadViewForNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
    }
    
    private func loadViewForNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "NearPlaceView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    private func setupView(){
        self.setupTableView()
    }
    private func setupTableView(){
        self.tableView.register(UINib(nibName: "NearPlaceTableViewCell", bundle: nil), forCellReuseIdentifier: self.cellId)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
    }
    
    func getListNearPlace(){
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 250, right: 20)
        self.indicatorView.startAnimating()
        GoogleMapApi.shared.getNearByPlace(lat: lat, long: long) {[weak self] (_listPlaces) in
            guard let strongSelf = self, let listPlaces = _listPlaces else {return}
            strongSelf.listPlaces = listPlaces
            strongSelf.updateView(listPlaces: listPlaces)
            
        }
    }
    private func updateView(listPlaces: [PlaceModel]){
        self.indicatorView.stopAnimating()
        self.indicatorView.isHidden = true
        self.tableView.reloadData()
        self.removeOldMarker()
        for place in listPlaces{
            self.showMarkerPlace(place: place)
        }
    }
    func showMarkerPlace(place: PlaceModel){
        let placeLocation = CLLocationCoordinate2D(latitude: place.lat, longitude: place.long)
        let maker = GMSMarker(position: placeLocation)
        maker.title = place.name
        maker.map = mapView
    }
    private func removeOldMarker(){
        mapView.clear()
    }
}
extension NearPlaceView: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return self.listPlaces?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.listPlaces == nil{
            let cell = UITableViewCell()
            cell.textLabel?.text = "Updating nearby places..."
            cell.textLabel?.textColor = UIColor.white
            cell.contentView.backgroundColor = UIColor.systemBlue
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath) as! NearPlaceTableViewCell
        if indexPath.section == 0{
            cell.nameLabel.text = "Select this location"
            cell.addressLabel.text = "(\(self.lat), \(self.long))"
            cell.nameLabel.textColor = UIColor.white
            cell.addressLabel.textColor = UIColor.white
            cell.contentView.backgroundColor = UIColor.systemBlue
        }else{
            cell.place = self.listPlaces![indexPath.row]
        }
        
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ShowViewFromWindow.shared.dismissView()
        self.delegate?.selectPlace(self.listPlaces![indexPath.row])
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
}

