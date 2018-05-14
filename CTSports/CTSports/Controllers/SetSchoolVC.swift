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
import FirebaseDatabase
import Firebase


class SetSchoolVC : UITableViewController, UISearchBarDelegate, UISearchControllerDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    var noResultsView: UIView!
    
    var arrayOfSchools = [String]()
    var filteredSchools = [String]()
    
    var letterDict = [String: [String]]()
    var sectionTitleArray: [String]?
    
    var newColor = UIColor.black
    
    override func viewDidLoad() {
        if sweetBlue.isLight(){
            newColor = UIColor.black
        }else{
            newColor = sweetBlue
        }
        super.viewDidLoad()
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = newColor
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
        
        self.getSchools()
        
    }
    func getSchools(){
        let fileURLProject = Bundle.main.path(forResource: "schoolcodes", ofType: "txt")
        // Read from the file
        var readStringProject = ""
        do {
            readStringProject = try String(contentsOfFile: fileURLProject!, encoding: String.Encoding.utf8)
            var lines = readStringProject.components(separatedBy: .newlines)
            //sort through lines and add to dictionary
            lines = lines.filter(){$0 != ""}
            
            for line in lines {
                let fullNameArr = line.components(separatedBy: ":")
                let firstCharacter: String = fullNameArr[0][0]
                if (self.letterDict[firstCharacter]?.append(fullNameArr[0])) == nil {
                    self.letterDict[firstCharacter] = [fullNameArr[0]]
                }
//                self.letterDict[firstCharacter]?.append(fullNameArr[0])
                schoolsDict[fullNameArr[0]] = fullNameArr[1]
        
            }
        } catch let error as NSError {
            print("Failed reading from URL: \(fileURLProject), Error: " + error.localizedDescription)
        }
        self.sectionTitleArray = Array(letterDict.keys).sorted(by: <)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if sweetBlue.isLight(){
            newColor = UIColor.black
        }else{
            newColor = sweetBlue
        }
        if arrayOfSchools.count == 0{
            self.getSchools()
        }
        self.navigationController?.navigationBar.barTintColor = newColor
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
            if (filteredSchools.count == 0) {
                noResultsView.isHidden = false
            }
            else {
                noResultsView.isHidden = true
            }
            return filteredSchools.count
        }
        else {
            if noResultsView != nil {
                noResultsView.isHidden = true
            }
            
            let townWithLetterArray: Array = letterDict[sectionTitleArray![section] as! String]!
            return townWithLetterArray.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "SetInfoCell", for: indexPath) as! SetInfoCell
        
        arrayOfSchools = Array(schoolsDict.keys).sorted(by: <)
        var currentSchool = ""
        
        if searchController.isActive && searchController.searchBar.text != "" {
            if (filteredSchools.count != 0){
                currentSchool = filteredSchools[indexPath.row]
            }
        }else{
            currentSchool = letterDict[sectionTitleArray![indexPath.section]]![indexPath.row]
        }
        
        
        cell.infoText?.text = currentSchool
        cell.schoolView.backgroundColor = schoolColors[currentSchool] ?? newColor
        
        print("School: \(currentSchool) isbright:\(schoolColors[currentSchool]?.isLight())")
        
        cell.schoolView.layer.cornerRadius = cell.schoolView.layer.frame.size.width / 2
        cell.SchoolInitial.text = currentSchool.getInitals()
        
        if((schoolColors[currentSchool] ?? newColor).isLight()){
            cell.SchoolInitial.textColor = UIColor.black
        }else{
            cell.SchoolInitial.textColor = UIColor.white
        }
        
        if (currentSchool.getInitals().count >= 2){
            cell.SchoolInitial.font = UIFont (name: "SFCollegiateSolid-Bold", size: 35)
        }
        else{
            cell.SchoolInitial.font = UIFont (name: "SFCollegiateSolid-Bold", size: 42)
        }
        return cell
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    }
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return (sectionTitleArray!.index(of: title)) ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousVC = backViewController()
        schoolChanged = true
        if searchController.isActive && searchController.searchBar.text != "" {
            school = schoolsDict[filteredSchools[indexPath.row]]!
            schoolKey = filteredSchools[indexPath.row]
            print("Filtered school: \(school)")
            defaults.set(school, forKey: "defaultSchool")
            defaults.set(schoolKey, forKey: "defaultSchoolKey")
            NotificationCenter.default.post(name: NSNotification.Name.init("changedSchool"), object: nil)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DefaultSportsVC") as! DefaultSportsVC
            NetworkManager.sharedInstance.performRequestSchool()
            NetworkManager.sharedInstance.createCustomSportsArray()

            if (previousVC?.title == "Initial") {
                //record analytics
                ref.observeSingleEvent(of: .value, with: { (snapshot)  in
                    // Get all percentages
                    let totalData = snapshot.value as? NSDictionary
                    //iterate through array and set each one
                    
                    var schoolName : String
                    if (schoolKey == "Acad. of the Holy Family") {
                        schoolName = "Acad. of the Holy Family"
                    } else if (schoolKey == "E.O.Smith") {
                        schoolName = "EO Smith"
                    } else {
                        schoolName = schoolKey
                    }
                    
                    var schoolData: Int = totalData![schoolName] as! Int
                    schoolData += 1;
                    
                    ref.child(school).setValue(schoolData)
                    print("\(school) has been changed to \(schoolData) users.")
                    defaults.set(true, forKey: "dataCollected")
                    
                })
                navigationController?.pushViewController(vc,
                                                         animated: true)
            } else {
                NetworkManager.sharedInstance.performRequestSchool()
                NetworkManager.sharedInstance.createCustomSportsArray()

                self.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }else{
            school = schoolsDict[letterDict[sectionTitleArray![indexPath.section]]![indexPath.row]]!
            schoolKey = letterDict[sectionTitleArray![indexPath.section]]![indexPath.row]
            print("Normal school: \(school)")
            defaults.set(school, forKey: "defaultSchool")
            defaults.set(schoolKey, forKey: "defaultSchoolKey")
            NotificationCenter.default.post(name: NSNotification.Name.init("changedSchool"), object: nil)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DefaultSportsVC") as! DefaultSportsVC
            NetworkManager.sharedInstance.performRequestSchool()
            NetworkManager.sharedInstance.createCustomSportsArray()

            
            
            
            if (previousVC?.title == "Initial") {
                //record analytics
                ref.observeSingleEvent(of: .value, with: { (snapshot)  in
                    // Get all percentages
                    let totalData = snapshot.value as? NSDictionary
                    //iterate through array and set each one
                    
                    
                    var schoolName : String
                    if (schoolKey == "Acad. of the Holy Family") {
                        schoolName = "Acad. of the Holy Family"
                    } else if (schoolKey == "E.O.Smith") {
                        schoolName = "EO Smith"
                    } else {
                        schoolName = schoolKey
                    }
                    
                    var schoolData: Int = totalData![schoolName] as! Int
                    schoolData += 1;
                    
                    ref.child(school).setValue(schoolData)
                    print("\(school) has been changed to \(schoolData) users.")
                    defaults.set(true, forKey: "dataCollected")
                })
                navigationController?.pushViewController(vc,
                                                        animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)

            }
          
        }
        sweetBlue = schoolColors[schoolKey] ?? UIColor(red:0.00, green:0.34, blue:0.60, alpha:1.0)

    }
    
    @IBAction func donePressed(_ sender: AnyObject) {
        
//        NetworkManager.sharedInstance.performRequestSchool()
//        NetworkManager.sharedInstance.createCustomSportsArray()
        self.dismiss(animated: true, completion: nil)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredSchools.removeAll()
        filteredSchools = arrayOfSchools.filter { school in
            return school.lowercased().contains(searchText.lowercased())
        }
        print("Done Filtering")
        tableView.reloadData()
    }
    
}

extension SetSchoolVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}





