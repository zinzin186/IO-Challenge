//
//  OptionCollectionViewCell.swift
//  IOS Challenge
//
//  Created by Din Vu Dinh on 6/24/20.
//  Copyright © 2020 Din Vu Dinh. All rights reserved.
//

import UIKit

class OptionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    var image: UIImage?{
        didSet{
            self.iconImageView.image = image
            self.setTinColorForImageView(color: ColorConfig.normalColor)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setTinColorForImageView(color: ColorConfig.normalColor)
    }

    
    private func setTinColorForImageView(color: UIColor){
        var image = self.iconImageView.image
        image = image?.withRenderingMode(.alwaysTemplate)
        iconImageView.image = image
        iconImageView.tintColor = color
    }
    override var isSelected: Bool{
        didSet{
            let color = isSelected ? ColorConfig.selectedColor: ColorConfig.normalColor
            self.setTinColorForImageView(color: color)
        }
    }
    override var isHighlighted: Bool{
        didSet{
            let color = isHighlighted ? ColorConfig.selectedColor: ColorConfig.normalColor
            self.setTinColorForImageView(color: color)
        }
    }
    
}
