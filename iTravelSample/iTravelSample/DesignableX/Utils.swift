//
//  Utils.swift
//  coreDataDemo
//
//  Created by Stanly Shiyanovskiy on 11.06.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let blueColor = UIColor(displayP3Red: 72/255, green: 179/255, blue: 229/255, alpha: 1)
}

// Clean string 
extension String {
    func stringByRemovingAll(characters: [Character]) -> String {
        return String(self.characters.filter({ !characters.contains($0) }))
    }
    
//    func stringByRemovingAll(subStrings: [String]) -> String {
//        var resultString = self
//        subStrings.map { resultString = resultString.replacingOccurrences(of: $0, with: "") }
//        return resultString
//    }
}

extension Date {
    
    func toString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy" //Your date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let date = dateFormatter.string(from: date) //according to date format your date string
        return date
    }
    
    func toDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy" //Your date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let date = dateFormatter.date(from: date) //according to date format your date string
        print(date ?? "") //Convert String to Date
        return date!
    }
}
