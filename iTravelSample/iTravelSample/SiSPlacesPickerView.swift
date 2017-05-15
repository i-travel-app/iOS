//
//  SiSPlacesPickerView.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 15.05.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class SiSPlacesPickerView: UIPickerView {
    
    let countriesArray = ["Боливия", "ЮАР", "Египет", "Турция", "Кипр", "Италия"]
    let townsArray = ["Арош", "Ренато", "Лисаур", "Уиннтито", "Левефазис", "Чипува"]
    let pickerDataArray = [countriesDict, townsDict]
    
    var country : String? = nil
    var town : String? = nil
    
}

extension SiSPlacesPickerView: UIPickerViewDataSource {
    //@available(iOS 2.0, *)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerDataArray[0].count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.pickerDataArray.count
    }
}

extension SiSPlacesPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerDataArray[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print(String(describing: self.pickerDataArray[component][row]))
        
        if component == 0 {
            self.country = String(describing: self.pickerDataArray[component][row])
            if self.town == nil {
                self.town = String(describing: self.townsArray[0])
            }
        } else  if component == 1 {
            self.town = String(describing: self.pickerDataArray[component][row])
            if self.country == nil {
                self.country = String(describing: self.countriesArray[0])
            }
        }
        
        print(self.country! + self.town!)
    }
    
}
