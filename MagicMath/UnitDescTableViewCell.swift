//
//  UnitDescTableViewCell.swift
//  MagicMath
//
//  Created by Abhinay Simha Vangipuram on 11/3/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

class UnitDescTableViewCell: UITableViewCell {
    
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var unitNameLabel: UILabel!
    @IBOutlet var unitDefLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
