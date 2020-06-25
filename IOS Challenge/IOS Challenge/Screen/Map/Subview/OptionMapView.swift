//
//  OptionMapView.swift
//  IOS Challenge
//
//  Created by Din Vu Dinh on 6/24/20.
//  Copyright © 2020 Din Vu Dinh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum TravelModes: String {
    case car = "driving"
    case bus = "transit"
    case walking = "walking"
    case bicycle = "Bicycling"
    
    var icon: UIImage?{
        switch self {
        case .car:
            return UIImage(named: "ic_qu_drive")
        case .bus:
            return UIImage(named: "ic_qu_directions_bus")
        case .walking:
            return UIImage(named: "ic_qu_walking")
        case .bicycle:
            return UIImage(named: "ic_qu_biking")
        }
    }
    var lineColor: UIColor{
        switch self {
        case .car:
            return UIColor.systemBlue
        case .bus:
            return UIColor.orange
        case .walking:
            return UIColor.green
        case .bicycle:
            return UIColor.red
        }
    }
}

protocol OptionMapDelegate: class {
    func inputFromLocation()
    func inputToLocation()
    func revertPosition()
    func showDirection(travelMode: TravelModes)
}


class OptionMapView: UIView{
    var view: UIView!
    
    @IBOutlet weak var fromLocationTextField: UITextField!
    @IBOutlet weak var toLocationTextField: UITextField!
    @IBOutlet weak var revertButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let listTravelModes = [TravelModes.car, TravelModes.bus, TravelModes.walking, TravelModes.bicycle]
    private let cellId = "CellId"
    private let paddingCell: CGFloat = 0
    private var currentTravelMode = TravelModes.car
    weak var delegate: OptionMapDelegate?
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.setupView()
    }
    
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
        let nib = UINib(nibName: "OptionMapView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    private func setupView(){
        self.revertButton.isSelected = false
        [fromLocationTextField, toLocationTextField].forEach { (textField) in
            textField?.layer.cornerRadius = 5
            textField?.layer.borderColor = ColorConfig.borderColor.cgColor
            textField?.layer.borderWidth = 1.0
        }
        self.setupCollectionView()
    }
    private func setupCollectionView(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "OptionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.cellId)
        DispatchQueue.main.async {
            if self.listTravelModes.count > 0{
                self.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
            }
        }
        
    }
    
    @IBAction func revertDirection(_ sender: Any) {
        self.delegate?.revertPosition()
    }
    
    @IBAction func gotoSearchFromLocation(_ sender: Any) {
        self.delegate?.inputFromLocation()
    }
    @IBAction func gotoSearchToLocation(_ sender: Any) {
        self.delegate?.inputToLocation()
    }
    func checkInput(){
        if !(self.fromLocationTextField.text?.isEmpty ?? true) && !(self.toLocationTextField.text?.isEmpty ?? true){
            self.revertButton.isEnabled = true
            self.delegate?.showDirection(travelMode: self.currentTravelMode)
        }
    }
}
extension OptionMapView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listTravelModes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! OptionCollectionViewCell
        cell.image = listTravelModes[indexPath.item].icon
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.calculateCellSize(collectionView: collectionView)
    }
    private func calculateCellSize(collectionView: UICollectionView)->CGSize{
        let widthCV = collectionView.frame.width
        let heightCV = collectionView.frame.height
        let widthCell = widthCV/CGFloat(self.listTravelModes.count)
        return CGSize(width: widthCell, height: heightCV)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.paddingCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentTravelMode = listTravelModes[indexPath.item]
        self.delegate?.showDirection(travelMode: listTravelModes[indexPath.item])
    }
    

}
