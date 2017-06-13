//
//  Utils.swift
//  coreDataDemo
//
//  Created by Stanly Shiyanovskiy on 11.06.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation

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
