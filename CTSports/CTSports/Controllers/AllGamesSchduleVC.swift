//
//  FirstViewController.swift
//  CTSports
//
//  Created by Neal Soni on 12/13/17.
//  Copyright © 2017 Neal Soni. All rights reserved.
//

import UIKit
import SWXMLHash
import GoogleMobileAds
import Alamofire

//let sweetBlue = UIColor(red:0.13, green:0.42, blue:0.81, alpha:1.0)


class AllGamesSchduleVC: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate, GADBannerViewDelegate { //DataReturnedDelegate
    

    @IBOutlet var activitySpinner: UIActivityIndicatorView!
    //var refreshControl: UIRefreshControl!
    let searchController = UISearchController(searchResultsController: nil)
    var noResultsView: UIView!
    
    var allGames = [SportingEvent]()
    var allGamesV = [SportingEvent]()
    var allGamesJV = [SportingEvent]()
    var allGamesFR = [SportingEvent]()
    var filteredGames = [SportingEvent]()
    var convertedFilteredGames = [NSDate: [SportingEvent]]()
    var filteredUniqueDates = [NSDate]()
    
    var gamesDictionary = [NSDate: [SportingEvent]]()
    var gamesDictionaryV = [NSDate: [SportingEvent]]()
    var gamesDictionaryJV = [NSDate: [SportingEvent]]()
    var gamesDictionaryFR = [NSDate: [SportingEvent]]()
    var gamesDictionaryAll = [NSDate: [SportingEvent]]()
    var filteredGamesDictionary = [NSDate: [SportingEvent]]()
    
    var gameNSDates = [NSDate]()
    var gameNSDatesV = [NSDate]()
    var gameNSDatesJV = [NSDate]()
    var gameNSDatesFR = [NSDate]()
    var gameNSDatesAll = [NSDate]()
    
    var uniqueNSGameDates = [NSDate]()
    var uniqueNSGameDatesV = [NSDate]()
    var uniqueNSGameDatesJV = [NSDate]()
    var uniqueNSGameDatesFR = [NSDate]()
    var uniqueNSGameDatesAll = [NSDate]()
    
    var updatedLast = Date()
    
    var gameLevel = "V"
    
    var bannerView: GADBannerView! //Ads
    
    var removeAds = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
//        NetworkManager.sharedInstance.delegate = self


        //Info bar button
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(AllGamesSchduleVC.infoPressed), for: .touchUpInside)
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        navigationItem.leftBarButtonItem = infoBarButtonItem
        
        levelSelector.tintColor = sweetBlue
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = sweetBlue
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "AppleSDGothicNeo-Bold", size: 17)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        UIApplication.shared.statusBarStyle = .lightContent
        
        for item in (self.tabBarController?.tabBar.items)! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(sweetBlue).withRenderingMode(.alwaysOriginal)
                item.selectedImage = item.selectedImage!.imageWithColor(sweetBlue).withRenderingMode(.alwaysOriginal)
            }
        }
        self.navigationItem.title = "\(schoolKey.capitalized) Sports Schedule"
        
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
        
        
        self.activitySpinner.startAnimating()
        
        let currentDate = NSDate()
        let dateFormatter = DateFormatter()
        
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDate = dateFormatter.string(from: currentDate as Date)
        
        print("GOT TO REFRESH 1!")
        //refreshControl.backgroundColor = UIColor.white
        //refreshControl.tintColor = UIColor.darkGray
        
        refreshControl = UIRefreshControl()
        
        refreshControl?.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl!)
        print("GOT TO REFRESH 2!")
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.tintColor = UIColor.darkGray
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.parseAllGamesIntoDictionaries), name: NSNotification.Name.init("loadedAllGames"), object: nil)


        self.tableView.reloadData()
        
//        let tracker = GAI.sharedInstance().defaultTracker
//        tracker?.set(kGAIScreenName, value: "Sports")
//
//        let builder = GAIDictionaryBuilder.createScreenView()
//        tracker?.send(builder?.build() as! [AnyHashable: Any])
        
        //ads
        if (!removeAds){
            print("adding bannerview to view: Remove ads is \(removeAds)")
            functionsToAddBannerViewToView()
        }
        
        //detect if init install
        print(defaultSports)
        print(school)
        if(defaultSports.isEmpty && school == "") {
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "InitialInstallViewController") as! UINavigationController
            self.present(vc1, animated:true, completion: nil)

        }

        
    }
    override func viewDidAppear(_ animated: Bool) {
        if (NetworkManager.sharedInstance.done){
            
            parseAllGamesIntoDictionaries()
        }
        self.navigationController?.navigationBar.barTintColor = sweetBlue
        for item in (self.tabBarController?.tabBar.items)! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(sweetBlue).withRenderingMode(.alwaysOriginal)
                item.selectedImage = item.selectedImage!.imageWithColor(sweetBlue).withRenderingMode(.alwaysOriginal)
            }
        }
        levelSelector.tintColor = sweetBlue
        self.navigationItem.title = "\(schoolKey) Sports Schedule"
    }
    
//    func dataRecieved(allGames: [SportingEvent]) {
//        print("ALL GAMES: \(allGames)")
//
//        self.allGames = allGames
//        self.parseAllGamesIntoDictionaries()
//
//    }
//    func specificDataRecived(specificGames: [SportingEvent]) {
//        print("SPECIFIC GAMES: \(specificGames)")
//        print("WHY TF AM I HERE!")
//
//    }
    @objc func parseAllGamesIntoDictionaries() {
        self.removeAll()
        print("parsing")
        for event in NetworkManager.sharedInstance.allGames {
            let level = event.gameLevel
            let gameNSDate = event.gameNSDate
            if level == "V" {
                if (self.gamesDictionaryV[gameNSDate]?.append(event)) == nil {
                    self.gamesDictionaryV[gameNSDate] = [event]
                }
                self.gameNSDatesV.append(gameNSDate)
                self.allGamesV.append(event)
            }
            if level == "JV" {
                if (self.gamesDictionaryJV[gameNSDate]?.append(event)) == nil {
                    self.gamesDictionaryJV[gameNSDate] = [event]
                }
                self.gameNSDatesJV.append(gameNSDate)
                self.allGamesJV.append(event)
            }
            if level == "FR" {
                if (self.gamesDictionaryFR[gameNSDate]?.append(event)) == nil {
                    self.gamesDictionaryFR[gameNSDate] = [event]
                }
                self.gameNSDatesFR.append(gameNSDate)
                self.allGamesFR.append(event)
                
            }
            if level == "ALL"{
                if (self.gamesDictionaryFR[gameNSDate]?.append(event)) == nil {
                    self.gamesDictionaryFR[gameNSDate] = [event]
                }
                self.gameNSDatesFR.append(gameNSDate)
                self.allGamesFR.append(event)
                
                if (self.gamesDictionaryJV[gameNSDate]?.append(event)) == nil {
                    self.gamesDictionaryJV[gameNSDate] = [event]
                }
                self.gameNSDatesJV.append(gameNSDate)
                self.allGamesJV.append(event)
                
                if (self.gamesDictionaryV[gameNSDate]?.append(event)) == nil {
                    self.gamesDictionaryV[gameNSDate] = [event]
                }
                self.gameNSDatesV.append(gameNSDate)
                self.allGamesV.append(event)
                
            }
            if (self.gamesDictionaryAll[gameNSDate]?.append(event)) == nil {
                self.gamesDictionaryAll[gameNSDate] = [event]
            }
            self.gameNSDatesAll.append(gameNSDate)
        }
        self.gameNSDatesV   = self.gameNSDatesV.removeDuplicates()
        self.gameNSDatesJV  = self.gameNSDatesJV.removeDuplicates()
        self.gameNSDatesFR  = self.gameNSDatesFR.removeDuplicates()
        self.gameNSDatesAll = self.gameNSDatesAll.removeDuplicates()
        self.activitySpinner.stopAnimating()
        self.activitySpinner.isHidden = true
        self.tableView.reloadData()
        print(gameNSDatesAll.count)
        self.activitySpinner.stopAnimating()
    }
    
    
  
    override func viewWillAppear(_ animated: Bool) {
        if (self.uniqueNSGameDates.count == 0) {
//            NetworkManager.sharedInstance.performRequest(school: school)
            self.updatedLast = Date(timeIntervalSinceReferenceDate: Date().timeIntervalSinceReferenceDate)
        }
    }
    @objc func infoPressed() {
        let infoPage = self.storyboard?.instantiateViewController(withIdentifier: "infoVC") as! UINavigationController
        if #available(iOS 10.3, *) {
            UIApplication.shared.setAlternateIconName(nil) { error in
                if let error = error {
                    print()
                    print("ERROR \(error.localizedDescription)")
                } else {
                    print("Success!")
                }
            }
        } else {
            // Fallback on earlier versions
        }
        self.tabBarController?.present(infoPage, animated: true, completion: nil)
    }
    
    
    @objc func refresh(sender:AnyObject) {
        self.removeAll()
        NetworkManager.sharedInstance.performRequestSchool()

        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let attrsDictionary = [
            NSAttributedStringKey.foregroundColor : UIColor.darkGray
        ]
        let attributedTitle: NSAttributedString = NSAttributedString(string: "Last update: \(dateFormatter.string(from: updatedLast))", attributes: attrsDictionary)
        
        refreshControl?.attributedTitle = attributedTitle
        
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    func removeAll(){
        
        self.activitySpinner.startAnimating()
        self.activitySpinner.isHidden = false
        
        allGames.removeAll()
        allGamesV.removeAll()
        allGamesJV.removeAll()
        allGamesFR.removeAll()
        filteredGames.removeAll()
        convertedFilteredGames.removeAll()
        filteredUniqueDates.removeAll()
        
        gameNSDates.removeAll()
        gameNSDatesV.removeAll()
        gameNSDatesJV.removeAll()
        gameNSDatesFR.removeAll()
        gameNSDatesAll.removeAll()
        
        
        uniqueNSGameDates.removeAll()
        uniqueNSGameDatesV.removeAll()
        uniqueNSGameDatesJV.removeAll()
        uniqueNSGameDatesFR.removeAll()
        uniqueNSGameDatesAll.removeAll()
        
        gamesDictionary.removeAll()
        gamesDictionaryV.removeAll()
        gamesDictionaryJV.removeAll()
        gamesDictionaryFR.removeAll()
        gamesDictionaryAll.removeAll()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if (school != ""){
            self.tableView.backgroundView = .none

            if searchController.isActive && searchController.searchBar.text != "" {
                uniqueNSGameDates = filteredUniqueDates
                print("number of sections: \(filteredUniqueDates)")
            }else{
                switch gameLevel {
                case "V":
                    uniqueNSGameDates = gameNSDatesV
                case "FR":
                    uniqueNSGameDates = gameNSDatesFR
                case "JV":
                    uniqueNSGameDates = gameNSDatesJV
                case "All":
                    uniqueNSGameDates = gameNSDatesAll
                    
                default:
                    uniqueNSGameDates = gameNSDatesV
                }
            }
            return uniqueNSGameDates.count
        }else{
            let newView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height))
            
            let sportsIcon: UIImageView = UIImageView(frame: CGRect(x: 0, y: newView.center.y - 150, width: 100, height: 100))
            sportsIcon.image = UIImage(named: "CIAC.png")
            sportsIcon.center.x = newView.center.x
            
            let messageLabel: UILabel = UILabel(frame: CGRect(x: 0, y: newView.center.y - 20, width: newView.frame.width - 20, height: 50))
            messageLabel.text = "You have no default School. To add a default school, please tap below and press \"add\""
            messageLabel.textColor = UIColor.black
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.center.x = newView.center.x
            messageLabel.font = UIFont(name: "Palatino-Italic", size: 20)
            
            let newClassButton: UIButton = UIButton(frame: CGRect(x: 0, y: newView.center.y + 50, width: 200, height: 50))
            newClassButton.backgroundColor = UIColor.purple
            newClassButton.center.x = newView.center.x
            newClassButton.setTitle("Add School", for: UIControlState())
            newClassButton.titleLabel?.textAlignment = .center
            newClassButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
            newClassButton.addTarget(self, action: #selector(AllGamesSchduleVC.addSchool), for: .touchUpInside)
            
            
            newView.addSubview(sportsIcon)
            newView.addSubview(messageLabel)
            newView.addSubview(newClassButton)
            
            self.tableView.backgroundView = newView
            self.tableView.separatorStyle = .none
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        return 0
        //print("There are \(uniqueNSGameDates.count) Section")
    }
    @objc func addSchool(){
        let VC1 = self.storyboard?.instantiateViewController(withIdentifier: "SetSchoolViewController") as! UINavigationController
        self.present(VC1, animated:true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            if (filteredGames.count == 0){
                noResultsView.isHidden = false
                return 0
            }else{
                noResultsView.isHidden = true
                
                return (self.convertedFilteredGames[filteredUniqueDates[section]]?.count ?? Int())
            }
        }else{
            
            switch gameLevel {
            case "V":
                uniqueNSGameDates = gameNSDatesV
                gamesDictionary = gamesDictionaryV
            case "JV":
                uniqueNSGameDates = gameNSDatesJV
                gamesDictionary = gamesDictionaryJV
            case "FR":
                uniqueNSGameDates = gameNSDatesFR
                gamesDictionary = gamesDictionaryFR
            case "All":
                uniqueNSGameDates = gameNSDatesAll
                gamesDictionary = gamesDictionaryAll
                
            default:
                uniqueNSGameDates = gameNSDatesV
                gamesDictionary = gamesDictionaryV
                
            }
        }
        //print("Section Number: \(section). Section Name: \(uniqueNSGameDates[section]) and rows in section: \(self.gamesDictionaryV[uniqueNSGameDatesV[section]]?.count ?? Int())")
        return (self.gamesDictionary[uniqueNSGameDates[section]]?.count ?? Int())
        
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.00)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        label.text = titleForSectionHeader(section: section)!
        label.font =  UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.textColor = UIColor.black
        label.textAlignment = .center
        headerView.addSubview(label)
        
        
        return headerView
    }
    
    func titleForSectionHeader(section: Int) -> String? {
        var gameDate1 = ""
        
        if (uniqueNSGameDates.count != 0 && gamesDictionary[uniqueNSGameDates[0]]?[0] != nil){
            
            if searchController.isActive && searchController.searchBar.text != "" {
                uniqueNSGameDates = filteredUniqueDates
            }else{
                switch gameLevel {
                case "V":
                    uniqueNSGameDates = gameNSDatesV
                case "JV":
                    uniqueNSGameDates = gameNSDatesJV
                case "FR":
                    uniqueNSGameDates = gameNSDatesFR
                case "All":
                    uniqueNSGameDates = gameNSDatesAll
                default:
                    uniqueNSGameDates = gameNSDatesV
                }
            }
            
            let gameDate = uniqueNSGameDates[section].toString(dateFormat: "yyyy-MM-dd")
            let index = gameDate.index(gameDate.startIndex, offsetBy: 8)
            let day = gameDate.substring(from: index)
            let dateArray : [String] = gameDate.components(separatedBy: "-")
            let monthName = DateFormatter().monthSymbols[Int(dateArray[1])! - 1]
            
            gameDate1 = convertDaytoWeekday(date: uniqueNSGameDates[section]) + ", " + monthName + " " + day
        }
        if bannerView != nil {
            tableView.bringSubview(toFront: bannerView)
        }
        return gameDate1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SportsCell
        self.tableView.rowHeight = 73.0
        var tag = ""
        var event: SportingEvent = SportingEvent(sport: "sportName", stringDate: "gameDate", gameNSDate: Date() as NSDate, weekday: "weekDay", time: "time", school: "location", gameLevel: "level", home: "homeAway", gameType: "gameType", season: "season", opponent: "opponent", directionsURL: "", id_num: "id_num", bus: "bus", busTime: "busTime", exactDate: Date() as NSDate)
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            if (filteredUniqueDates.count != 0 && convertedFilteredGames[filteredUniqueDates[0]]?[0] != nil){
                uniqueNSGameDates = filteredUniqueDates
                event = (convertedFilteredGames[filteredUniqueDates[indexPath.section]]?[indexPath.row])!
                
                if gameLevel == "All"{
                    switch event.gameLevel {
                    case "V":
                        tag = "Varsity "
                    case "JV":
                        tag = "JV "
                    case "FR":
                        tag = "Freshman "
                    default:
                        tag = ""
                    }
                }
                cell.sport.text = tag + (event.sport)
                cell.time.text = "\(String(describing: event.time))"
                cell.school.text = event.school
                cell.school.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
                
                cell.home.font = UIFont(name: "HelveticaNeue", size: 35)
                cell.time.font = UIFont(name: "HelveticaNeue", size: 17)
                if event.gameType == "Practice"{
                    print("Practice")
                    cell.home.text = "P"
                    cell.home.textColor = sweetBlue //Classic iStaples Blue
                }else if event.home == "Home" {
                    cell.home.text = "H"
                    cell.home.textColor = sweetBlue //Classic iStaples Blue
                    
                } else {
                    cell.home.text = "A"
                    cell.home.textColor = schoolColors[event.opponent] ?? sweetGreen
                    
                }
                return cell
            }
            
        } else{
            if (uniqueNSGameDates.count != 0 && gamesDictionary[uniqueNSGameDates[0]]?[0] != nil){
                //event = (gamesDictionaryV[uniqueNSGameDates[0]]?[0])! // just a place holder for no apparent reason because swift hates me, Don't remove
                switch gameLevel {
                case "V":
                    uniqueNSGameDates = gameNSDatesV
                    event = (gamesDictionaryV[uniqueNSGameDates[indexPath.section]]?[indexPath.row])!
                case "JV":
                    uniqueNSGameDates = gameNSDatesJV
                    event = (gamesDictionaryJV[uniqueNSGameDates[indexPath.section]]?[indexPath.row])!
                    
                case "FR":
                    uniqueNSGameDates = gameNSDatesFR
                    event = (gamesDictionaryFR[uniqueNSGameDates[indexPath.section]]?[indexPath.row])!
                case "All":
                    uniqueNSGameDates = gameNSDatesAll
                    event = (gamesDictionaryAll[uniqueNSGameDates[indexPath.section]]?[indexPath.row])!
                    switch event.gameLevel {
                    case "V":
                        tag = "Varsity "
                    case "JV":
                        tag = "JV "
                    case "FR":
                        tag = "Freshman "
                    default:
                        tag = ""
                    }
                default:
                    uniqueNSGameDates = gameNSDatesV
                }
            }
            
            if event.gameType == "Practice"{
                print("Practice")
                cell.home.text = "P"
                cell.home.textColor = sweetBlue //Classic iStaples Blue
            }else if event.home == "Home" {
                cell.home.text = "H"
                cell.home.textColor = sweetBlue //Classic iStaples Blue
                
            } else {
                cell.home.text = "A"
                cell.home.textColor = schoolColors[event.opponent] ?? sweetGreen
                
            }
            
            cell.sport.text = tag + (event.sport)
            cell.time.text = "\(String(describing: event.time))"
            cell.school.text = event.school
            cell.school.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
            
            cell.home.font = UIFont(name: "HelveticaNeue", size: 35)
            cell.time.font = UIFont(name: "HelveticaNeue", size: 17)
        }
        
        if (event.sport != ""){
            
            
        }
        
        return cell
        
    }
    
    @IBOutlet weak var levelSelector: UISegmentedControl!
    
    @IBAction func levelSelector(_ sender: Any) {
        
        if(levelSelector.selectedSegmentIndex == 0){
            self.gameLevel = "V"
        }
        if(levelSelector.selectedSegmentIndex == 1){
            self.gameLevel = "JV"
        }
        if(levelSelector.selectedSegmentIndex == 2){
            self.gameLevel = "FR"
        }
        if(levelSelector.selectedSegmentIndex == 3){
            self.gameLevel = "All"
        }
        if searchController.isActive && searchController.searchBar.text != "" {
            filterContentForSearchText(searchController.searchBar.text!)
        }
        self.tableView.reloadData()
    }

    func convertDaytoWeekday(date: NSDate) -> String{
        let weekdays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday"
        ]
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let components: NSDateComponents = calendar.components(.weekday, from: date as Date) as NSDateComponents
        let weekDay = weekdays[components.weekday - 1]
        
        return weekDay
    }

    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredGames.removeAll()
        convertedFilteredGames.removeAll()
        filteredUniqueDates.removeAll()
        print("Filtering")
        switch gameLevel {
        case "V":
            filteredGames = allGamesV.filter { game in
                return game.searchCriteria.lowercased().contains(searchText.lowercased())
            }
        case "JV":
            filteredGames = allGamesJV.filter { game in
                return game.searchCriteria.lowercased().contains(searchText.lowercased())
            }
        case "FR":
            filteredGames = allGamesFR.filter { game in
                return game.searchCriteria.lowercased().contains(searchText.lowercased())
            }
        case "All":
            filteredGames = allGames.filter { game in
                return game.searchCriteria.lowercased().contains(searchText.lowercased())
            }
            
        default:
            filteredGames = allGames.filter { game in
                return game.searchCriteria.lowercased().contains(searchText.lowercased())
            }
        }
        print(filteredGames.count)
        
        for event in filteredGames {
            if (self.convertedFilteredGames[event.gameNSDate]?.append(event)) == nil {
                self.convertedFilteredGames[event.gameNSDate] = [event]
            }
            self.filteredUniqueDates.append(event.gameNSDate)
        }
        self.filteredUniqueDates = self.filteredUniqueDates.removeDuplicates()

        print("Done Filtering")
        tableView.reloadData()
        //bannerView.superview?.bringSubview(toFront: bannerView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showEvent") {
            let newView = segue.destination as! SportingEventVC
            
            let selectedIndexPath = self.tableView.indexPathForSelectedRow
            var indexEvent: SportingEvent
            if searchController.isActive && searchController.searchBar.text != "" {
                
                if (filteredUniqueDates.count != 0 && convertedFilteredGames[filteredUniqueDates[0]]?[0] != nil){
                    uniqueNSGameDates = filteredUniqueDates
                    indexEvent = (convertedFilteredGames[filteredUniqueDates[selectedIndexPath![0]]]?[selectedIndexPath![1]])!
                    newView.currentEvent = indexEvent
                }else{
                    indexEvent = allGames[0]
                }
                
                
            }else{
                print("Game date count: \(uniqueNSGameDates.count)")
                //if (uniqueNSGameDates.count != 0){
                var indexEvent: SportingEvent //= allGames[0] // just a place holder for no apparent reason because swift hates me, Don't remove
                
                switch gameLevel {
                case "V":
                    uniqueNSGameDates = gameNSDatesV
                    indexEvent = (gamesDictionaryV[uniqueNSGameDates[selectedIndexPath![0]]]?[selectedIndexPath![1]])!
                case "JV":
                    uniqueNSGameDates = gameNSDatesJV
                    indexEvent = (gamesDictionaryJV[uniqueNSGameDates[selectedIndexPath![0]]]?[selectedIndexPath![1]])!
                case "FR":
                    uniqueNSGameDates = gameNSDatesFR
                    indexEvent = (gamesDictionaryFR[uniqueNSGameDates[selectedIndexPath![0]]]?[selectedIndexPath![1]])!
                case "All":
                    uniqueNSGameDates = gameNSDatesAll
                    indexEvent = (gamesDictionaryAll[uniqueNSGameDates[selectedIndexPath![0]]]?[selectedIndexPath![1]])!
                default:
                    uniqueNSGameDates = gameNSDatesV
                    indexEvent = allGames[0]
                }
                
                newView.currentEvent = indexEvent
                
                //print(indexEvent!.sport)
                //}
            }
            let backButton = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
            
            self.navigationItem.backBarButtonItem = backButton
            
            self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated: true)
            
        }
    }
    //ADS
    func functionsToAddBannerViewToView(){
        bannerView =  GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-6421137549100021/7517677074" // real one
        //bannerView.adUnitID = adID // Test one
        //request.testDevices = @[ kGADSimulatorID ]
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID ];
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        self.tableView.insertSubview(bannerView, belowSubview: (navigationController?.navigationBar)!)
        tableView.bringSubview(toFront: bannerView)
        
    }
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        if #available(iOS 11.0, *) {
            // In iOS 11, we need to constrain the view to the safe area.
            positionBannerViewFullWidthAtBottomOfSafeArea(bannerView)
        }
        else {
            // In lower iOS versions, safe area is not available so we use
            // bottom layout guide and view edges.
            positionBannerViewFullWidthAtBottomOfView(bannerView)
        }
    }
    
    // MARK: - view positioning
    @available (iOS 11, *)
    func positionBannerViewFullWidthAtBottomOfSafeArea(_ bannerView: UIView) {
        // Position the banner. Stick it to the bottom of the Safe Area.
        // Make it constrained to the edges of the safe area.
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            guide.leftAnchor.constraint(equalTo: bannerView.leftAnchor),
            guide.rightAnchor.constraint(equalTo: bannerView.rightAnchor),
            guide.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
            ])
    }
    
    func positionBannerViewFullWidthAtBottomOfView(_ bannerView: UIView) {
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: bottomLayoutGuide,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 0))
    }
    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
}





extension AllGamesSchduleVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


