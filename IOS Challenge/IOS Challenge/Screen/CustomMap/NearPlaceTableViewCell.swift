//
//  NearPlaceTableViewCell.swift
//  IOS Challenge
//
//  Created by Din Vu Dinh on 6/25/20.
//  Copyright © 2020 Din Vu Dinh. All rights reserved.
//

import UIKit

class NearPlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var place: PlaceModel?{
        didSet{
            self.nameLabel.text = place?.name
            self.addressLabel.text = place?.address
            if let icon = place?.icon{
                self.iconImageView.loadPhotoFromURL(icon)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.contentView.backgroundColor = UIColor.white
    }
}
