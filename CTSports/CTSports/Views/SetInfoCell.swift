//
//  SetInfoCell.swift
//  CTSports
//
//  Created by Neal Soni on 12/17/17.
//  Copyright © 2017 Neal Soni. All rights reserved.
//

import UIKit

class SetInfoCell: UITableViewCell {

    @IBOutlet weak var infoText: UILabel!
    
    @IBOutlet weak var sportImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
