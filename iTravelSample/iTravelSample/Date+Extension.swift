//
//  Date+Extension.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 15.07.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import UIKit

extension NSDate {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy" //Your date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let date = dateFormatter.string(from: self as Date) //according to date format your date string
        return date
    }
}
