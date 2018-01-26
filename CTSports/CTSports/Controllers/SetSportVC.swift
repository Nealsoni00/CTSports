//
//  SetSportVC.swift
//  CTSports
//
//  Created by Neal Soni on 12/18/17.
//  Copyright © 2017 Neal Soni. All rights reserved.
//

import UIKit
import SwiftSpinner
import Alamofire
import PopupDialog

var sport: String = defaults.object(forKey: "defaultSport") as? String ?? ""
var sportKey: String = defaults.object(forKey: "defaultSportKey") as? String ?? ""

var sportsDict = [String: String]()
var sportChanged = false

class SetSportVC : UITableViewController, UISearchBarDelegate, UISearchControllerDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    var noResultsView: UIView!
    
    var arrayOfSports = [String]()
    var filteredSports =  [String]()
    
    var letterDict = [String: [String]]()
    var sectionTitleArray: [String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = sweetBlue
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "AppleSDGothicNeo-Bold", size: 17)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        UIApplication.shared.statusBarStyle = .lightContent
        
   
        
        let backButton = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        self.navigationItem.title = "Select Your Sport"
        // Do any additional setup after loading the view.
        
        //Search Stuff
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView?.addSubview(searchController.searchBar)
        
        noResultsView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.width))
        noResultsView.backgroundColor = UIColor.clear
        
        let noResultsLabel = UILabel(frame: noResultsView.frame)
        noResultsLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        noResultsLabel.numberOfLines = 1
        noResultsLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        noResultsLabel.shadowColor = UIColor.lightText
        noResultsLabel.textColor = UIColor.darkGray
        noResultsLabel.shadowOffset = CGSize(width: 0, height: 1)
        noResultsLabel.backgroundColor = UIColor.clear
        noResultsLabel.textAlignment = NSTextAlignment.center
        
        noResultsLabel.text = "No Results"
        
        noResultsView.isHidden = true
        noResultsView.addSubview(noResultsLabel)
        self.tableView.insertSubview(noResultsView, belowSubview: self.tableView)
        
        self.getSports()
        
        
        

        
    }
    func getSports(){
        let fileURLProject = Bundle.main.path(forResource: "sports", ofType: "txt")
        // Read from the file
        var readStringProject = ""
        do {
            readStringProject = try String(contentsOfFile: fileURLProject!, encoding: String.Encoding.utf8)
            var lines = readStringProject.components(separatedBy: .newlines)
            //sort through lines and add to dictionary
            lines = lines.filter(){$0 != ""}
            for line in lines {
                let fullNameArr = line.components(separatedBy: ":")
                let firstCharacter: String = fullNameArr[1][0]
                if (self.letterDict[firstCharacter]?.append(fullNameArr[1])) == nil {
                    self.letterDict[firstCharacter] = [fullNameArr[1]]
                }
                //                self.letterDict[firstCharacter]?.append(fullNameArr[0])
                sportsDict[fullNameArr[1]] = fullNameArr[0]
            }
        } catch let error as NSError {
            print("Failed reading from URL: \(fileURLProject), Error: " + error.localizedDescription)
        }
        self.sectionTitleArray = Array(letterDict.keys).sorted(by: <)
    }
    override func viewDidAppear(_ animated: Bool) {
        if arrayOfSports.count == 0{
            self.getSports()
        }
        self.navigationController?.navigationBar.barTintColor = sweetBlue
     
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return 1
        }
        else {
            return sectionTitleArray!.count
        }
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive && searchController.searchBar.text != "" {
            return nil
        }
        else {
            return sectionTitleArray![section] as? String
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != "" {
            if (filteredSports.count == 0) {
                noResultsView.isHidden = false
            }
            else {
                noResultsView.isHidden = true
            }
            return filteredSports.count
        }
        else {
            if noResultsView != nil {
                noResultsView.isHidden = true
            }
            
            let sportWithLetterArray: Array = letterDict[sectionTitleArray![section] as! String]!
            return sportWithLetterArray.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "SetInfoCell", for: indexPath) as! SetInfoCell
        
        arrayOfSports = Array(sportsDict.keys).sorted(by: <)
        var currentSport = ""
        
        if searchController.isActive && searchController.searchBar.text != "" {
            if (filteredSports.count != 0){
                currentSport = filteredSports[indexPath.row]
            }
        }else{
            
            
            currentSport = letterDict[sectionTitleArray![indexPath.section]]![indexPath.row]
        }
        cell.infoText.text = currentSport

        let image: UIImage = UIImage(named: "\(currentSport.replacingOccurrences(of: " ", with: "")).png") ?? UIImage()
        cell.sportImage!.image = image.imageWithColor(sweetBlue)

        
        return cell
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    }
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return (sectionTitleArray!.index(of: title)) ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sportChanged = true
        if searchController.isActive && searchController.searchBar.text != "" {
            sport = sportsDict[filteredSports[indexPath.row]]!
            sportKey = filteredSports[indexPath.row]
            print("Filtered school: \(sport)")
            //check for duplicates
            var exists = false;
            for sport in defaultSports {
                if (sport == sportKey) {
                    print("exists")
                        exists = true;
                }
            }

            if (!exists) {
 
    
                defaultSports.append(sportKey);
                defaults.set(defaultSports, forKey: "allSports")
                NetworkManager.sharedInstance.performRequestSports()
//                NotificationCenter.default.post(name: NSNotification.Name.init("changedSport"), object: nil)
                self.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
            } else {
                print("dup")
                let popup = PopupDialog(title: "Error", message: "Sport is already a selected default. Please choose another sport or close the window.")

                popup.transitionStyle = .fadeIn
                let buttonOne = DefaultButton(title: "Dismiss") {
                }
                
                popup.addButton(buttonOne)
                // to add a single button
                popup.addButton(buttonOne)
                // Present dialog
                self.present(popup, animated: true, completion: nil)
                tableView.deselectRow(at: indexPath, animated: true)

                exists = false;
            }
            
       
            
            
        }else{
            sport = sportsDict[letterDict[sectionTitleArray![indexPath.section]]![indexPath.row]]!
            sportKey = letterDict[sectionTitleArray![indexPath.section]]![indexPath.row]
            print("Normal school: \(sport)")
            var exists = false;
            for sport in defaultSports {
                if (sport == sportKey) {
                    print("exists")
                    exists = true;
                }
            }
 
            if (!exists) {
                defaults.set(sport, forKey: "defaultSport")
                defaults.set(sportKey, forKey: "defaultSportKey")
                defaultSports.append(sportKey);
                defaults.set(defaultSports, forKey: "allSports")
                NotificationCenter.default.post(name: NSNotification.Name.init("changedSport"), object: nil)
                self.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
            } else {
                print("dup")

                let popup = PopupDialog(title: "Error", message: "Sport is already a selected default. Please choose another sport or close the window.")
                popup.transitionStyle = .fadeIn
                let buttonOne = DefaultButton(title: "Dismiss") {
                }
                
                popup.addButton(buttonOne)
                // to add a single button
                popup.addButton(buttonOne)
                // Present dialog
                self.present(popup, animated: true, completion: nil)
                tableView.deselectRow(at: indexPath, animated: true)

                exists = false;
            }
        }
    }
    
    
    
    @IBAction func donePressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredSports.removeAll()
        filteredSports = arrayOfSports.filter { sport in
            return sport.lowercased().contains(searchText.lowercased())
        }
        
        print("Done Filtering")
        tableView.reloadData()
    }
    
}



extension SetSportVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


