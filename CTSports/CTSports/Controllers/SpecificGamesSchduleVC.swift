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

class SpecificGamesSchduleVC: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate, GADBannerViewDelegate  { //DataReturnedDelegate

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
    
    var defaultLevel: Int = 0
    
    
    
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
        
//        //Info bar button
//        let settingsButton = UIButton(type: .infoLight)
//        infoButton.addTarget(self, action: #selector(AllGamesSchduleVC.infoPressed), for: .touchUpInside)
//        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
//        navigationItem.rightBarButtonItem = infoBarButtonItem
        self.defaultLevel = defaults.object(forKey: "levelSelector") as? Int ?? 0
        levelSelector.selectedSegmentIndex = self.defaultLevel
        switch self.defaultLevel {
        case 0:
            gameLevel = "V"
        case 1:
            gameLevel = "JV"
        case 2:
            gameLevel = "FR"
        case 3:
            gameLevel = "All"
        default:
            gameLevel = "V"
        }
        
        levelSelector.tintColor = sweetBlue

        
//        var customTabBarItem:UITabBarItem = UITabBarItem(title: nil,
//                                                         image: UIImage(named: "\(defaultSports[0].replacingOccurrences(of: " ", with: "")).png")?.imageWithColor(sweetBlue).withRenderingMode(UIImageRenderingMode.alwaysOriginal),
//                                                         selectedImage: UIImage(named: "\(defaultSports[0].replacingOccurrences(of: " ", with: "")).png")?.imageWithColor(UIColor.gray))
        if (defaultSports.count != 0){
            self.tabBarController?.tabBar.items![0].image = UIImage(named: "\(defaultSports[0].replacingOccurrences(of: " ", with: ""))Small.png")?.imageWithColor(UIColor.gray)
            self.tabBarController?.tabBar.items![0].selectedImage = UIImage(named: "\(defaultSports[0].replacingOccurrences(of: " ", with: ""))Small.png")?.imageWithColor(sweetBlue)
        }

        
        //Nav controller bar
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = sweetBlue
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "AppleSDGothicNeo-Bold", size: 17)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        UIApplication.shared.statusBarStyle = .lightContent
        
        for item in (self.tabBarController?.tabBar.items)! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(UIColor.gray).withRenderingMode(.alwaysOriginal)
                item.selectedImage = item.selectedImage!.imageWithColor(sweetBlue).withRenderingMode(.alwaysOriginal)
            }
        }

        
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
        
        self.activitySpinner.hidesWhenStopped = true
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.parseSpecificGamesIntoDictionaries), name: NSNotification.Name.init("loadedSpecificGames"), object: nil)
        tableView.clearsContextBeforeDrawing = true
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
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if (defaultSports.count == 1){
            self.navigationItem.title = "\(defaultSports[0]) Schedule"
            self.title = "\(defaultSports[0])"

        }else{
            self.navigationItem.title = "Your Sports"
            self.title = "Your Sports"
        }
        if (schoolKey != ""){
            let initial = schoolKey.replacingOccurrences(of: "East ", with: "").replacingOccurrences(of: "North ", with: "").replacingOccurrences(of: "South ", with: "").replacingOccurrences(of: "West ", with: "").replacingOccurrences(of: "South ", with: "").replacingOccurrences(of: "South ", with: "").replacingOccurrences(of: "St ", with: "")[schoolKey.characters.index(schoolKey.startIndex, offsetBy: 0)]
            self.tabBarController?.tabBar.items![1].image = UIImage(named: "\(initial).png")?.imageWithColor(UIColor.gray)
            self.tabBarController?.tabBar.items![1].selectedImage = UIImage(named: "\(initial).png")?.imageWithColor(sweetBlue)
        }
        if (defaultSports.count != 0){
            self.tabBarController?.tabBar.items![0].image = UIImage(named: "\(defaultSports[0].replacingOccurrences(of: " ", with: ""))Small.png")?.imageWithColor(UIColor.gray)
            self.tabBarController?.tabBar.items![0].selectedImage = UIImage(named: "\(defaultSports[0].replacingOccurrences(of: " ", with: ""))Small.png")?.imageWithColor(sweetBlue)
        }
        self.navigationController?.navigationBar.barTintColor = sweetBlue
        for item in (self.tabBarController?.tabBar.items)! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(UIColor.gray).withRenderingMode(.alwaysOriginal)
                item.selectedImage = item.selectedImage!.imageWithColor(sweetBlue).withRenderingMode(.alwaysOriginal)
            }
        }
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: sweetBlue], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.gray], for: .normal)
        levelSelector.tintColor = sweetBlue

        if (NetworkManager.sharedInstance.doneSpecific){
            parseSpecificGamesIntoDictionaries();
        }
        tableView.reloadData()
        if(defaultSports.isEmpty && school == "") {
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "InitialInstallViewController") as! UINavigationController
            self.present(vc1, animated:true, completion: nil)
            
        }


    }

    @objc func parseSpecificGamesIntoDictionaries() {
        self.removeAll()
        print("parsing SPECIFIC GAMES")
        print(NetworkManager.sharedInstance.specificGames)
        for event in NetworkManager.sharedInstance.specificGames {
            print("school: \(event.school)")
            print("sportKey: \(sport), Sport: \(event.sport), Bool: \(event.sport == sportKey)")
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
            self.allGames.append(event)
        }
        self.gameNSDatesV   = self.gameNSDatesV.removeDuplicates().sorted(by: { $0.compare($1 as Date) == .orderedAscending })
        self.gameNSDatesJV  = self.gameNSDatesJV.removeDuplicates().sorted(by: { $0.compare($1 as Date) == .orderedAscending })
        self.gameNSDatesFR  = self.gameNSDatesFR.removeDuplicates().sorted(by: { $0.compare($1 as Date) == .orderedAscending })
//        self.allGames = NetworkManager.sharedInstance.specificGames
        self.gameNSDatesAll = self.gameNSDatesAll.removeDuplicates().sorted(by: { $0.compare($1 as Date) == .orderedAscending })
        self.activitySpinner.stopAnimating()
        self.activitySpinner.isHidden = true
        self.tableView.reloadData()
        print(gameNSDatesAll.count)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if (self.uniqueNSGameDates.count == 0) {
            //            NetworkManager.sharedInstance.performRequest(school: school)
            self.updatedLast = Date(timeIntervalSinceReferenceDate: Date().timeIntervalSinceReferenceDate)
        }
        tableView.reloadData()
    }
    @objc func infoPressed() {
        
        let infoPage = self.storyboard?.instantiateViewController(withIdentifier: "infoVC") as! UINavigationController
//        
//        if #available(iOS 10.3, *) {
//            UIApplication.shared.setAlternateIconName("AppIcon-2") { error in
//                if let error = error {
//                    print()
//                    print("ERROR \(error.localizedDescription)")
//                } else {
//                    print("Success!")
//                }
//            }
//        } else {
//            // Fallback on earlier versions
//        }
        
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
        if (defaultSports.count > 0 && allGames.count > 0){
            self.tableView.backgroundView = .none
            self.navigationItem.rightBarButtonItem?.isEnabled = true

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
            //print("There are \(uniqueNSGameDates.count) Section")
            return uniqueNSGameDates.count
        }else if defaultSports.count == 0 {
            // Display a message when the table is empty
            let newView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height))
            
            let sportsIcon: UIImageView = UIImageView(frame: CGRect(x: 0, y: newView.center.y - 150, width: 120, height: 120))
            sportsIcon.image = UIImage(named: "CTSportsLogo.png")
            sportsIcon.center.x = newView.center.x
            
            let messageLabel: UILabel = UILabel(frame: CGRect(x: 0, y: newView.center.y - 20, width: newView.frame.width - 20, height: 50))
            messageLabel.text = "You have no default sports. To add a new default sport, please tap below and press \"add\""
            messageLabel.textColor = UIColor.black
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.center.x = newView.center.x
            messageLabel.font = UIFont(name: "Palatino-Italic", size: 20)
            
            let newClassButton: UIButton = UIButton(frame: CGRect(x: 0, y: newView.center.y + 50, width: 200, height: 50))
            newClassButton.backgroundColor = UIColor.purple
            newClassButton.center.x = newView.center.x
            newClassButton.setTitle("Add Sport", for: UIControlState())
            newClassButton.titleLabel?.textAlignment = .center
            newClassButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
            newClassButton.addTarget(self, action: #selector(SpecificGamesSchduleVC.addSport), for: .touchUpInside)
            
            
            newView.addSubview(sportsIcon)
            newView.addSubview(messageLabel)
            newView.addSubview(newClassButton)
            
            self.tableView.backgroundView = newView
            self.tableView.separatorStyle = .none
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.activitySpinner.stopAnimating()
        
        } else if (!activitySpinner.isAnimating){
            if Connectivity.isConnectedToInternet() {
                print("Yes! internet is available.")
                // do some tasks..
            let newView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height))

            let sportsIcon: UIImageView = UIImageView(frame: CGRect(x: 0, y: newView.center.y - 150, width: 120, height: 120))
            sportsIcon.image = UIImage(named: "CIAC.png")
            sportsIcon.center.x = newView.center.x

            let messageLabel: UILabel = UILabel(frame: CGRect(x: 0, y: newView.center.y - 20, width: newView.frame.width - 20, height: 50))
            messageLabel.text = "There are no games listed on the CIAC website for your chosen sport(s)."
            messageLabel.textColor = UIColor.black
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.center.x = newView.center.x
            messageLabel.font = UIFont(name: "Palatino-Italic", size: 20)

            let newScheduleButton: UIButton = UIButton(frame: CGRect(x: 0, y: newView.center.y + 50, width: 200, height: 50))
            newScheduleButton.backgroundColor = UIColor.purple
            newScheduleButton.center.x = newView.center.x
            newScheduleButton.setTitle("Missing Schedule?", for: UIControlState())
            newScheduleButton.titleLabel?.textAlignment = .center
            newScheduleButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
            newScheduleButton.addTarget(self, action: #selector(SpecificGamesSchduleVC.addSchedule), for: .touchUpInside)



            newView.addSubview(sportsIcon)
            newView.addSubview(messageLabel)
            newView.addSubview(newScheduleButton)

                self.tableView.backgroundView = newView

           
            } else {
                let newView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height))
                
                let sportsIcon: UIImageView = UIImageView(frame: CGRect(x: 0, y: newView.center.y - 150, width: 120, height: 120))
                sportsIcon.image = UIImage(named: "CTSportsLogo.png")
                sportsIcon.center.x = newView.center.x
                
                let messageLabel: UILabel = UILabel(frame: CGRect(x: 0, y: newView.center.y - 20, width: newView.frame.width - 20, height: 50))
                messageLabel.text = "There is no internet connection."
                messageLabel.textColor = UIColor.black
                messageLabel.numberOfLines = 0
                messageLabel.textAlignment = .center
                messageLabel.center.x = newView.center.x
                messageLabel.font = UIFont(name: "Palatino-Italic", size: 20)
            
                
                
                
                newView.addSubview(sportsIcon)
                newView.addSubview(messageLabel)
                self.tableView.backgroundView = newView

            }
            self.tableView.separatorStyle = .none
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.activitySpinner.stopAnimating()
        }
        return 0
    
    }
    @objc func addSport(){
        let addSportPage = self.storyboard?.instantiateViewController(withIdentifier: "SetSportViewController")
//        self.present(addSportPage!, animated: true, completion: nil)
        self.performSegue(withIdentifier: "SetDefaultSports", sender: nil)
    }
    @objc func addSchedule(){
//        let addSportPage = self.storyboard?.instantiateViewController(withIdentifier: "InputScheduleVC")
        self.performSegue(withIdentifier: "addGames", sender: nil)

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
        headerView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.00)
        
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
        self.tableView.rowHeight = 170.0
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
                cell.school.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
                
//                cell.home.font = UIFont(name: "HelveticaNeue", size: 35)
                cell.time.font = UIFont(name: "HelveticaNeue", size: 20)
                //print(gameDates[indexPath.row])
//                if event.gameType == "Practice"{
//                    print("Practice")
//                    cell.home.text = "P"
//                    cell.home.textColor = sweetBlue //Classic iStaples Blue
//                }else if event.home == "Home" {
//                    cell.home.text = "H"
//                    cell.home.textColor = sweetBlue //Classic iStaples Blue
//
//                } else {
//                    cell.home.text = "A"
//                    cell.home.textColor = sweetGreen
//
//                }
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
            
            cell.sport.text = tag + (event.sport)
            cell.time.text = "\(String(describing: event.time))"
            cell.school.text = event.school
            cell.school.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
            
//            cell.home.font = UIFont(name: "HelveticaNeue", size: 35)
            cell.time.font = UIFont(name: "HelveticaNeue", size: 20)
            

        }
        
        if (event.sport != ""){
            
            var opponentName = event.opponent.components(separatedBy: " ")
            opponentName.append(school)
            cell.currentEvent = event
            cell.homeLabel.textColor = sweetBlue
            if schoolKey.split(separator: " ").count > 2 {
                let schoolArray = schoolKey.split(separator: " ")
                if ("\(String(schoolArray[0]))  \(String(schoolArray[1]))".characters.count < 35){
                    cell.homeLabel.text = "\(String(schoolArray[0]))  \(String(schoolArray[1])) \(String(schoolArray[2]))..."
                }else{
                    cell.homeLabel.text = "\(String(schoolArray[0]))  \(String(schoolArray[1]))"
                }
            }else{
                cell.homeLabel.text = schoolKey
            }
            
            
            if (schoolKey.getInitals().characters.count == 2){
                cell.homeLetter.font = UIFont (name: "SFCollegiateSolid-Bold", size: 60)
            }
            else{
                cell.homeLetter.font = UIFont (name: "SFCollegiateSolid-Bold", size: 69)
            }
            cell.homeLetter.text = schoolKey.getInitals()
            cell.homeLetterView.backgroundColor = schoolColors[schoolKey] ?? sweetBlue
            cell.homeLetterView.layer.cornerRadius = cell.homeLetterView.layer.frame.size.width / 2
            
        
            
            
            if event.opponent.split(separator: " ").count > 2 {
                let schoolArray = event.opponent.split(separator: " ")
                if ("\(String(schoolArray[0]))  \(String(schoolArray[1]))".characters.count < 35){
                    cell.OpponentLabel.text = "\(String(schoolArray[0]))  \(String(schoolArray[1])) \(String(schoolArray[2]))..."
                }else{
                    cell.OpponentLabel.text = "\(String(schoolArray[0]))  \(String(schoolArray[1]))"
                }
            }else{
                cell.OpponentLabel.text = event.opponent
            }
            cell.OpponentLabel.textColor = schoolColors[cell.OpponentLabel.text!] ?? UIColor(red:0.83, green:0.18, blue:0.18, alpha:1.0)

           
            if (event.opponent.getInitals().characters.count == 2){
                cell.awayLetter.font = UIFont (name: "SFCollegiateSolid-Bold", size: 60)
            }
            else{
                cell.awayLetter.font = UIFont (name: "SFCollegiateSolid-Bold", size: 69)
            }
            cell.awayLetter.text = event.opponent.getInitals()
            cell.opponentLetterView.backgroundColor = schoolColors[cell.OpponentLabel.text!]  ?? UIColor(red:0.83, green:0.18, blue:0.18, alpha:1.0)
            cell.opponentLetterView.layer.cornerRadius = cell.opponentLetterView.layer.frame.size.width / 2
            
            
            cell.homeAwaySwitch.tintColor = schoolColors[schoolKey] ?? sweetBlue
            switch event.home {
            case "Home":
                cell.homeAwaySwitch.selectedSegmentIndex = 0
                cell.homeAwaySwitch.tintColor = schoolColors[schoolKey] ?? sweetBlue
            //                homeAwaySelector.setEnabled(false, forSegmentAt: 0)
            case "Away":
                cell.homeAwaySwitch.tintColor = schoolColors[cell.OpponentLabel.text!] ?? UIColor(red:0.83, green:0.18, blue:0.18, alpha:1.0)
                cell.homeAwaySwitch.selectedSegmentIndex = 1
            //                homeAwaySelector.setEnabled(false, forSegmentAt: 1)
            default:
                break
            }
            
        }

        
        return cell
        
    }
    
    @IBOutlet weak var levelSelector: UISegmentedControl!
    
    @IBAction func levelSelector(_ sender: Any) {
        if(levelSelector.selectedSegmentIndex == 0){
            self.gameLevel = "V"
            defaults.set(0, forKey: "levelSelector")
        }
        if(levelSelector.selectedSegmentIndex == 1){
            self.gameLevel = "JV"
            defaults.set(1, forKey: "levelSelector")
        }
        if(levelSelector.selectedSegmentIndex == 2){
            self.gameLevel = "FR"
            defaults.set(2, forKey: "levelSelector")
        }
        if(levelSelector.selectedSegmentIndex == 3){
            self.gameLevel = "All"
            defaults.set(3, forKey: "levelSelector")
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
        print("SEGUE??????")
        if (segue.identifier == "showEvent2") {
            print("Segue called")
            let newView = segue.destination as! SportingEventVC
            
            let selectedIndexPath = self.tableView.indexPathForSelectedRow
            if searchController.isActive && searchController.searchBar.text != "" {
                var indexEvent = allGames[0]
                
                if (filteredUniqueDates.count != 0 && convertedFilteredGames[filteredUniqueDates[0]]?[0] != nil){
                    uniqueNSGameDates = filteredUniqueDates
                    indexEvent = (convertedFilteredGames[filteredUniqueDates[selectedIndexPath![0]]]?[selectedIndexPath![1]])!
                    newView.currentEvent = indexEvent
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
        
        addBannerViewToView(bannerView) //ca-app-pub-6421137549100021~6410028127
        bannerView.adUnitID = adID // real one
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

extension SpecificGamesSchduleVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}



