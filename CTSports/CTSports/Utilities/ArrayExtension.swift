//
//  ArrayExtension.swift
//  CTSports
//
//  Created by Jack Sharkey on 12/18/17.
//  Copyright © 2017 Neal Soni. All rights reserved.
//

import Foundation

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}
