//
//  DefaultSportingEvent.swift
//  CTSports
//
//  Created by Jack Sharkey on 12/30/17.
//  Copyright © 2017 Neal Soni. All rights reserved.
//

import Foundation


class DefaultSportingEvent: NSObject {
    var defaultSport = ""
    var defaultSportKey = ""
    
    init(sport: String) {
        defaultSport = sport;
    }

}
