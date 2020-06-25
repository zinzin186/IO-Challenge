//
//  UIImageViewExtension.swift
//  IOS Challenge
//
//  Created by Din Vu Dinh on 6/25/20.
//  Copyright © 2020 Din Vu Dinh. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView{
    func loadPhotoFromURL(_ urlString: String, animation: Bool = false) {
        guard let url = URL(string: urlString) else { return }
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = imageFromCache
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async(execute: {
                guard let data = data else{return}
                if let downloadedImage = UIImage(data: data){
                    self.image = downloadedImage
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                }
            })
            
            }.resume()
        
    }
}
