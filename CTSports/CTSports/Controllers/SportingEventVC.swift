//
//  SportingEventVC.swift
//  CTSports
//
//  Created by Neal Soni on 12/13/17.
//  Copyright © 2017 Neal Soni. All rights reserved.
//
//
//  SportingEventVC.swift
//  staplesgotclass
//
//  Created by Neal Soni on 9/15/17.
//  Copyright © 2017 Dylan Diamond. All rights reserved.
//

import Foundation
import UIKit

class SportingEventVC: UITableViewController {
    @IBOutlet var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var opponentLabel: UILabel!
    @IBOutlet var homeLetterView: UIView!
    @IBOutlet var homeLetter: UILabel!
    @IBOutlet var opponentLetter: UILabel!
    @IBOutlet var opponentLetterView: UIView!
    
//    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var homeAwaySelector: UISegmentedControl!
    
    
    var currentEvent: SportingEvent?
    
    var headers = [String]()
    var information = [String]()
    var schoolName: [String] = [""]
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = sweetBlue
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "AppleSDGothicNeo-UltraLight", size: 15)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationItem.title = "SPORTING EVENT"
        

        if (currentEvent != nil) {
            self.navigationItem.title = "\(self.currentEvent!.sport)".uppercased()
            
            self.headers.append("Sport")
            self.information.append(self.currentEvent!.sport)
            
            self.headers.append("Date")
            self.information.append(self.currentEvent!.stringDate)
            
            self.headers.append("Time")
            self.information.append(self.currentEvent!.time)
//            self.timeLabel.text = self.currentEvent!.time
            
            self.headers.append("Location")
            self.information.append(self.currentEvent!.school)
            
            self.headers.append("Opponent")
            self.information.append(self.currentEvent!.opponent)
            
            self.headers.append("School")
            if (self.currentEvent!.directionsURL.range(of: "school") != nil){
                self.schoolName =  self.currentEvent!.directionsURL.components(separatedBy: "school=")
                self.information.append(schoolName[1])
            }else{
                self.information.append("")
            }
            
            
            self.headers.append("Game Level")
            switch self.currentEvent!.gameLevel{
            case "V":
                self.information.append("Varsity")
            case "JV":
                self.information.append("Junior Varsity")
            case "FR":
                self.information.append("Freshman")
            default:
                break;
            }
//            homeAwaySelector.isEnabled = false
            homeAwaySelector.tintColor = sweetBlue
            switch self.currentEvent!.home {
            case "Home":
                homeAwaySelector.selectedSegmentIndex = 0
//                homeAwaySelector.setEnabled(false, forSegmentAt: 0)
            case "Away":
                homeAwaySelector.tintColor = UIColor(red:0.83, green:0.18, blue:0.18, alpha:1.0)
                homeAwaySelector.selectedSegmentIndex = 1
//                homeAwaySelector.setEnabled(false, forSegmentAt: 1)
            default:
                break
            }
//            self.homeAwayLabel.text = self.currentEvent!.home
            
            self.headers.append("Game Type")
            self.information.append(self.currentEvent!.gameType)
            
            self.headers.append("Season")
            self.information.append(self.currentEvent!.season.capitalized)
            
            var opponentName = self.currentEvent!.opponent.components(separatedBy: " ")
            opponentName.append(school)
//            if (opponentName[0] != "") {
//                nameLabel.attributedText = "\(school) \nvs \n \(self.currentEvent!.opponent)".color(opponentName)
//            }else{
//                nameLabel.attributedText = "\(school) \nvs \n \(opponentName[0])".color(opponentName)
//            }
            
            nameLabel.textColor = sweetBlue
            if schoolKey.split(separator: " ").count > 2 {
                let schoolArray = schoolKey.split(separator: " ")
                if ("\(String(schoolArray[0]))  \(String(schoolArray[1]))".characters.count < 35){
                    nameLabel.text = "\(String(schoolArray[0]))  \(String(schoolArray[1])) \(String(schoolArray[2]))..."
                }else{
                    nameLabel.text = "\(String(schoolArray[0]))  \(String(schoolArray[1]))"
                }
            }else{
                nameLabel.text = schoolKey
            }
            var initials = ""
            for word in schoolKey.split(separator: " "){
                if (initials.characters.count < 2){
                    initials = initials + String(word)[0]
                }
            }
            if (initials.characters.count == 2){
                homeLetter.font = UIFont (name: "SFCollegiateSolid-Bold", size: 60)
            }
            else{
                homeLetter.font = UIFont (name: "SFCollegiateSolid-Bold", size: 69)
            }
            homeLetter.text = initials
            homeLetterView.backgroundColor = sweetBlue
            homeLetterView.layer.cornerRadius = homeLetterView.layer.frame.size.width / 2
            
            
            
            opponentLabel.textColor = UIColor(red:0.83, green:0.18, blue:0.18, alpha:1.0)

            if self.currentEvent!.opponent.split(separator: " ").count > 2 {
                let schoolArray = self.currentEvent!.opponent.split(separator: " ")
                if ("\(String(schoolArray[0]))  \(String(schoolArray[1]))".characters.count < 35){
                    opponentLabel.text = "\(String(schoolArray[0]))  \(String(schoolArray[1])) \(String(schoolArray[2]))..."
                }else{
                    opponentLabel.text = "\(String(schoolArray[0]))  \(String(schoolArray[1]))"
                }
            }else{
                opponentLabel.text = self.currentEvent!.opponent
            }
            initials = ""
            for word in  self.currentEvent!.opponent.split(separator: " "){
                if (initials.characters.count < 2){
                    initials = initials + String(word)[0]
                }
            }
            if (initials.characters.count == 2){
                opponentLetter.font = UIFont (name: "SFCollegiateSolid-Bold", size: 60)
            }
            else{
                opponentLetter.font = UIFont (name: "SFCollegiateSolid-Bold", size: 69)
            }
            opponentLetter.text = initials
            
//            opponentLabel.text = String(self.currentEvent!.opponent.split(separator: " ")[0])
//            var initialsOpponent = ""
//            for word in self.currentEvent!.opponent.split(separator: " "){
//                initialsOpponent = initialsOpponent + String(word)[0]
//            }
//            opponentLetter.text = initialsOpponent
            opponentLetterView.backgroundColor = UIColor(red:0.83, green:0.18, blue:0.18, alpha:1.0)
            opponentLetterView.layer.cornerRadius = opponentLetterView.layer.frame.size.width / 2
            
        

            if (self.currentEvent!.bus == "yes"){
                self.headers.append("Bus Time")
                self.information.append(self.currentEvent!.busTime)
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    @IBAction func levelSelectorChanged(_ sender: Any) {
        switch self.currentEvent!.home {
        case "Home":
            homeAwaySelector.selectedSegmentIndex = 0
        case "Away":
            homeAwaySelector.selectedSegmentIndex = 1
        default:
            break
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (currentEvent != nil){
            return headers.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "INFORMATION"
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "sportsInfoCell", for: indexPath) as! SportsInfoCell
        if (currentEvent != nil) {
            cell.name.text = headers[indexPath.row]
            if (information[indexPath.row] == ""){
                cell.info.text = "N/A"
            }else{
                cell.info.text = information[indexPath.row]
            }
        }
        return cell
    }
    
}

extension String {
    func getRanges(of string: String) -> [NSRange] {
        var ranges:[NSRange] = []
        if contains(string) {
            let words = self.components(separatedBy: " ")
            var position: Int = 0
            for word in words {
                if word.lowercased() == string.lowercased() {
                    let startIndex = position
                    let endIndex = word.count
                    let range = NSMakeRange(startIndex, endIndex)
                    ranges.append(range)
                }
                position += (word.count + 1)
            }
        }
        return ranges
    }
    func color(_ words: [String]) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for word in words {
            let ranges = getRanges(of: word)
            for range in ranges {
                if word.contains(find: school){
                    attributedString.addAttributes([NSAttributedStringKey.foregroundColor: UIColor(red:0.13, green:0.42, blue:0.81, alpha:1.0)], range: range)
                }else{
                    attributedString.addAttributes([NSAttributedStringKey.foregroundColor: UIColor(red:0.83, green:0.18, blue:0.18, alpha:1.0)], range: range)
                }
            }
        }
        return attributedString
    }
}



