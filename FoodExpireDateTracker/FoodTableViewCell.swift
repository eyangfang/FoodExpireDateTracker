//
//  FoodTableViewCell.swift
//  FoodExpireDateTracker
//
//  Created by Fang Yang on 4/2/18.
//  Copyright © 2018 Yang Fang. All rights reserved.
//

import UIKit

class FoodTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
