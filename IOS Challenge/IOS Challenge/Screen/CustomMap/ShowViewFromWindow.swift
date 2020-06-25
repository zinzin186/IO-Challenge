//
//  ShowViewFromWindow.swift
//  IOS Challenge
//
//  Created by Din Vu Dinh on 6/25/20.
//  Copyright © 2020 Din Vu Dinh. All rights reserved.
//

import UIKit
import GoogleMaps
class ShowViewFromWindow: NSObject{
    
    var nearPlaceView: NearPlaceView!
    var blackBackgroundView: UIView!
    private var heightOfView: CGFloat = 250
    static let shared = ShowViewFromWindow()
    private var callBack: ((_ place: PlaceModel)->Void)?
    func showListPlace(lat: Double, long:Double, mapView: GMSMapView, comletion: @escaping(PlaceModel)->Void) {
        if let keyWindow = UIApplication.shared.keyWindow {
            self.blackBackgroundView = UIView(frame: keyWindow.frame)
            self.blackBackgroundView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            self.blackBackgroundView.alpha = 0
            self.blackBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
            UIView.animate(withDuration: 0.5) {
                self.blackBackgroundView.alpha = 1
            }
            self.callBack = { place in
                comletion(place)
            }
            nearPlaceView = NearPlaceView(lat: lat, long: long, mapView: mapView)
            let nearPlaceViewFrame = CGRect(x: 0, y: keyWindow.frame.height, width: keyWindow.frame.width, height: 0)
            nearPlaceView.frame = nearPlaceViewFrame
            nearPlaceView.delegate = self
            keyWindow.addSubview(blackBackgroundView)
            keyWindow.addSubview(nearPlaceView)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.nearPlaceView.frame = CGRect(x: 0, y: keyWindow.frame.height - self.heightOfView, width: keyWindow.frame.width, height: self.heightOfView)
                self.blackBackgroundView.alpha = 1
            }, completion: {[weak self](completedAnimation) in
                 self?.nearPlaceView.getListNearPlace()
            })
            
            
        }
    }
    
    @objc func dismissView(){
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.nearPlaceView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: self.heightOfView)
            self.blackBackgroundView.alpha = 0
        }) { (value) in
            self.nearPlaceView.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            self.nearPlaceView.removeFromSuperview()
            self.blackBackgroundView.removeFromSuperview()
        }
    }
    
}
extension ShowViewFromWindow: NearPlaceDelegate{
    func selectPlace(_ place: PlaceModel) {
        self.callBack?(place)
    }
    
    
}
