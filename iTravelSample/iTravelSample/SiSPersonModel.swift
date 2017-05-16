//
//  SiSPersonModel.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 16.05.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

var mansNames = ["Иван","Петр","Степан","Олег","Роман","Ян","Леонид","Федор","Семен","Роберт","Жорж","Сидор","Гаврил","Богдан"]
var womansNames = ["Анна","Елена","Ольга","Татьяна","Марина","Светлана","Жанна","Яна","Алла","Екатерина","Алина","Елизавета","Надежда","Тамара"]


class SiSPersonModel: NSObject {
    var gender: String = ""
    var age: Int = 0
    var name: String = ""
    var surname: String = ""
    
    override init() {
        self.gender = randomGender()
        self.age = randomIntWithMax(maxValue: 70)
        if self.gender == "мужской" {
            self.name = mansNames[randomIntWithMax(maxValue: mansNames.count-1)]
            self.surname = mansNames[randomIntWithMax(maxValue: mansNames.count-1)] + "ов"
        } else if self.gender == "женский" {
            self.name = womansNames[randomIntWithMax(maxValue: womansNames.count-1)]
            self.surname = mansNames[randomIntWithMax(maxValue: mansNames.count-1)] + "ова"
        }
    }
}

func randomIntWithMax(maxValue: Int) -> Int {
    
    return Int(arc4random_uniform(UInt32(maxValue)) + 1)
}

func randomGender() -> String {
    return (randomIntWithMax(maxValue: 1000) % 2) == 0 ? "мужской" : "женский"
}
