//
//  AppDelegate.swift
//  CTSports
//
//  Created by Neal Soni on 12/13/17.
//  Copyright © 2017 Neal Soni. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseDatabase

let adID = "ca-app-pub-6421137549100021/4156411631"

let defaults = UserDefaults.standard
var defaultSports = defaults.array(forKey: "allSports") as? Array ?? [String]()
var school: String = defaults.object(forKey: "defaultSchool") as? String ?? ""
var schoolKey: String = defaults.object(forKey: "defaultSchoolKey") as? String ?? ""
var dataCollected = defaults.bool(forKey: "dataCollected") as? Bool ?? false
let center = UNUserNotificationCenter.current()
var ref: DatabaseReference!

var schoolsDict = [String: String]()
var schoolChanged = false

var sweetBlue = UIColor(red:0.00, green:0.34, blue:0.60, alpha:1.0)
let sweetGreen = UIColor(red:0.3, green:0.8, blue:0.13, alpha:1.0)
var empty = false; 
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  { //DataReturnedDelegate

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print(NetworkManager.sharedInstance)

        var sportsFromDefaults = defaults.array(forKey: "allSports")
        
        
        print("Default Sports: \(defaultSports)")
        
        UINavigationBar.appearance().barStyle = .blackOpaque

        school = (defaults.object(forKey: "defaultSchool") as? String) ?? ""
        schoolKey = (defaults.object(forKey: "defaultSchoolKey") as? String) ?? ""
        sport = defaults.object(forKey: "defaultSport") as? String ?? ""
        sportKey = defaults.object(forKey: "defaultSportKey") as? String ?? ""
        dataCollected = defaults.bool(forKey: "dataCollected") as? Bool ?? false
        print(school)
        print(dataCollected)
        print("hello")
        
        sweetBlue = schoolColors[schoolKey] ?? UIColor(red:0.00, green:0.34, blue:0.60, alpha:1.0)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: sweetBlue], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.gray], for: .normal)
        
        NetworkManager.sharedInstance.performRequestSchool()
        NetworkManager.sharedInstance.getSports()
        
        if (defaultSports.isEmpty) {
            empty = true;
        }
//        NetworkManager.sharedInstance.performRequestSports()
        
//         NetworkManager.sharedInstance.createCustomSportsArray()

//        NetworkManager.sharedInstance.delegate = self
    
        FirebaseApp.configure()
        ref = Database.database().reference()

        return true

    }
    
//    func dataRecieved(allGames: [SportingEvent]) {
////        print(NetworkManager.sharedInstance.allGames)
//    }
//    func specificDataRecived(specificGames: [SportingEvent]) {
//
//    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

