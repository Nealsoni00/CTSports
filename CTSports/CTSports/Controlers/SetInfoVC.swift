//
//  SetSchoolVC.swift
//  CTSports
//
//  Created by Neal Soni on 12/13/17.
//  Copyright © 2017 Neal Soni. All rights reserved.
//

import UIKit
import SwiftSpinner
import Alamofire

let school = "Weston"
let schoolKey = "Weston"

var schoolsDict = [String: String]()
var sportsDict = [String: String]()

class SetSchoolVC : UITableViewController, UISearchBarDelegate, UISearchControllerDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    var noResultsView: UIView!
    
    
    
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
        
        self.navigationItem.title = "Select Your School"
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
        
        
        var fileURLProject = Bundle.main.path(forResource: "schoolcodes", ofType: "txt")
        // Read from the file
        var readStringProject = ""
        do {
            readStringProject = try String(contentsOfFile: fileURLProject!, encoding: String.Encoding.utf8)
            var lines = readStringProject.components(separatedBy: .newlines)
            //sort through lines and add to dictionary
            lines = lines.filter(){$0 != ""}
            
            for line in lines {
             
                let fullNameArr = line.components(separatedBy: ":")
                
                fullNameArr[0] // first
                fullNameArr[1] // second
                
                schoolsDict[fullNameArr[0]] = fullNameArr[1]
                
            }
            
        } catch let error as NSError {
            print("Failed reading from URL: \(fileURLProject), Error: " + error.localizedDescription)
        }
        
         fileURLProject = Bundle.main.path(forResource: "sports", ofType: "txt")
        // Read from the file
         readStringProject = ""
        do {
            readStringProject = try String(contentsOfFile: fileURLProject!, encoding: String.Encoding.utf8)
            var lines = readStringProject.components(separatedBy: .newlines)
            //sort through lines and add to dictionary
            lines = lines.filter(){$0 != ""}
            
            for line in lines {
                
                let fullNameArr = line.components(separatedBy: ":")
                
                fullNameArr[0] // first
                fullNameArr[1] // second
                
                sportsDict[fullNameArr[0]] = fullNameArr[1]
                
            }
            
        } catch let error as NSError {
            print("Failed reading from URL: \(fileURLProject), Error: " + error.localizedDescription)
        }
        
        

        
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return 0
        }else{
            return Array(schoolsDict.keys).count
            
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "SetInfoCell", for: indexPath)
        let arrayOfTowns = Array(schoolsDict.keys)
        //alphabetically
        let sortedTowns = arrayOfTowns.sorted(by: <)
        let currentTown = sortedTowns[indexPath.row]
        let splitted = currentTown
            .characters
            .splitBefore(separator: { $0.isUpperCase })
            .map{String($0)}
        print(splitted)
        var formatedName = ""
        for element in splitted{
            formatedName = formatedName + "\(element) "
            
        }
        cell.textLabel?.text = formatedName
        return cell
    }
    @IBAction func donePressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        print("Done Filtering")
        tableView.reloadData()
    }

}



extension SetSchoolVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}





