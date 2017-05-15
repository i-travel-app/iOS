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
    
}
