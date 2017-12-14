//
//  NSDateExtension.swift
//  CTSports
//
//  Created by Neal Soni on 12/13/17.
//  Copyright © 2017 Neal Soni. All rights reserved.
//

import Foundation

extension Date {
    
    func addDay(_ daysToAdd: Int) -> Date {
        return (Calendar.current as NSCalendar)
            .date(
                byAdding: .day,
                value: daysToAdd,
                to: self,
                options: []
            )!
    }
}

extension NSDate
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self as Date)
    }
    
}
