//
//  SiSTripModel.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 11.05.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

let countriesDict = [0 : "Боливия", 1 : "ЮАР", 2 : "Египет", 3 : "Турция", 4 : "Кипр", 5 : "Италия"]
let townsDict = [0 : "Арош", 1 : "Ренато", 2 : "Лисаур", 3 : "Уиннтито", 4 : "Левефазис", 5 : "Чипува"]

class SiSTripModel: NSObject {
    var tripTitle : String? = "Название поездки"
    var participantsCount : Int? = 0
    var startDate : Date? = nil
    var endDate : Date? = nil
    var targetCountry : String? = ""
    var targetTown : String? = ""
    
    override init() {
        tripTitle = "Поездка №\(randomInt(maxValue: 100))"
        participantsCount = randomInt(maxValue: 5)
        startDate = nil
        endDate = nil
        targetCountry = countriesDict[randomInt(maxValue: 5)]
        targetTown = townsDict[randomInt(maxValue: 5)]
    }

}

func randomInt(maxValue: Int) -> Int {
    
    return Int(arc4random_uniform(UInt32(maxValue)) + 1)
}
