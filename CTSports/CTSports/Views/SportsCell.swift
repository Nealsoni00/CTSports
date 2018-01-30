//
//  GameCell.swift
//  CTSports
//
//  Created by Neal Soni on 12/13/17.
//  Copyright © 2017 Neal Soni. All rights reserved.
//


import UIKit 

class SportsCell: UITableViewCell {
    var currentEvent: SportingEvent?
    @IBOutlet weak var sport: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var school: UILabel!
    @IBOutlet weak var home: UILabel!
    
    @IBOutlet weak var opponentLetterView: UIView!
    @IBOutlet weak var homeLetterView: UIView!
    @IBOutlet weak var OpponentLabel: UILabel!
    @IBOutlet weak var homeAwaySwitch: UISegmentedControl!
    @IBOutlet weak var awayLetter: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var homeLetter: UILabel!
    
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var homeLetters: UILabel!
    @IBOutlet weak var awayView: UIView!
    @IBOutlet weak var awayLetters: UILabel!
    
    @IBOutlet weak var vsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func levelSelectorChanged(_ sender: Any) {
        switch self.currentEvent!.home {
        case "Home":
            homeAwaySwitch.selectedSegmentIndex = 0
        case "Away":
            homeAwaySwitch.selectedSegmentIndex = 1
        default:
            break
        }
    }
    
}


