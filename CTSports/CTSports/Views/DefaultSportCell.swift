//
//  DefaultSchoolCell.swift
//  CTSports
//
//  Created by Jack Sharkey on 12/30/17.
//  Copyright © 2017 Neal Soni. All rights reserved.
//

import Foundation
import UIKit



class DefaultSportCell: UITableViewCell {
    
    @IBOutlet weak var sport: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
