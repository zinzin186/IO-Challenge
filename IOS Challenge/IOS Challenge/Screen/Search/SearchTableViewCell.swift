//
//  SearchTableViewCell.swift
//  IOS Challenge
//
//  Created by Din Vu Dinh on 6/24/20.
//  Copyright © 2020 Din Vu Dinh. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setImageForIcon(image: UIImage?){
        let newImage = image?.withRenderingMode(.alwaysTemplate)
        self.iconImageView.image = newImage
        self.iconImageView.tintColor = UIColor.lightGray
        
    }
}
