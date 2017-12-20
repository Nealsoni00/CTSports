//
//  NetworkManager.swift
//  CTSports
//
//  Created by Jack Sharkey on 12/18/17.
//  Copyright © 2017 Neal Soni. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

protocol DataReturnedDelegate: class {
    func dataRecieved(allGames : [SportingEvent])
}

class NetworkManager: NSObject {
    
    static var sharedInstance: NetworkManager?
    let baseURL = "https://www.casciac.org/xml/?"
    var allGames = [SportingEvent]()
    
    weak var delegate: DataReturnedDelegate?
    
    func performRequest(school: String)  {
        var done = false;
        let url = "\(baseURL)sc=\(school)"
        Alamofire.request(url).responseJSON { response in
            let xml = SWXMLHash.lazy(response.data!)
            
            for elem in xml["SCHEDULE_DATA"]["EVENTS"]["EVENT"].all {
                let sportName = elem["sport"].element!.text
                let gameDate1 = elem["gamedate"].element!.text
                let homeAway = elem["site"].element!.text
                var location = elem["facility"].element!.text
                let time = elem["gametime"].element!.text.replacingOccurrences(of: " p.m.", with: "PM", options: .literal, range: nil)
                let level = elem["gamelevel"].element!.text
                
                let gameType = elem["gametype"].element!.text
                let season = elem["season"].element!.text
                let opponent = elem["opponent"].element!.text
                let directionsURL = elem["directionsurl"].element!.text
                let id_num = elem["id_num"].element!.text
                let bus = elem["bus"].element!.text
                let busTime = elem["bustime"].element!.text
                
                
                var dateArray : [String] = gameDate1.components(separatedBy: "-")
                var gameDate = ""
                var weekDay = ""
                var gameNSDate = NSDate()
                
                if (gameDate1 != "TBA") {
                
                
                let index = gameDate1.index(gameDate1.startIndex, offsetBy: 8)
                var day = gameDate1.substring(from: index)
                let dayFirst = day.index(day.startIndex, offsetBy: 1);
                let temp = day.substring(to: dayFirst)
                
                if temp == "0" {
                    day = day.substring(from: dayFirst)
                }
                
                let monthName = DateFormatter().monthSymbols[Int(dateArray[1])! - 1]
                
                
                let (gameNSDate, weekDay) = self.convertDateToDay(date: gameDate1)
                //varsity game
                let gameDate = self.convertDaytoWeekday(date: gameNSDate) + ", " + monthName + " " + day
                
                } else {
                   
                }
                if location == "" {
                    location = "Location Unknown"
                }
             
                let event = SportingEvent(sport: sportName, stringDate: gameDate, gameNSDate: gameNSDate, weekday: weekDay, time: time, school: location, gameLevel: level, home: homeAway, gameType: gameType, season: season, opponent: opponent, directionsURL: directionsURL, id_num: id_num, bus: bus, busTime: busTime)

                self.allGames.append(event)
            }
             done = true;
            self.delegate?.dataRecieved(allGames: self.allGames)

        }
        //fix return
        if (done) {
            print("done")
        }
    }
    
    func convertDateToDay(date: String) -> (NSDate, String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let gameDate = dateFormatter.date(from:date)
        
        let weekDay = convertDaytoWeekday(date: gameDate! as NSDate)
        
        return (gameDate! as NSDate, weekDay as String)
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
    
}



