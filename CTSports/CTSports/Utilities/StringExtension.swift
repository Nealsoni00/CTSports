//
//  StringExtension.swift
//  CTSports
//
//  Created by Neal Soni on 12/19/17.
//  Copyright © 2017 Neal Soni. All rights reserved.
//

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[Range(start ..< end)])
    }
}
extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    func getInitals() -> String{
        let school = self.replacingOccurrences(of: "of", with: "").replacingOccurrences(of: "the", with: "").replacingOccurrences(of: " @ ", with: "").replacingOccurrences(of: " & ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
        var initials = ""
        for word in school.split(separator: " "){
            if (initials.characters.count < 2){
                initials = initials + String(word)[0]
            }
        }
        return initials
        
    }
}
