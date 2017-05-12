//
//  SiSNewTripViewController.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 11.05.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class SiSNewTripViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let countriesDict = [0 : "Боливия", 1 : "ЮАР", 2 : "Египет", 3 : "Турция", 4 : "Кипр", 5 : "Италия"]
    let townsDict = [0 : "Арош", 1 : "Ренато", 2 : "Лисаур", 3 : "Уиннтито", 4 : "Левефазис", 5 : "Чипува"]

    @IBOutlet weak var targetPlace: UITextFieldX!
    @IBOutlet weak var startTripDate: UITextFieldX!
    @IBOutlet weak var endTripDate: UITextFieldX!
    @IBOutlet weak var participantsCount: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Создание поездки"
        self.pickerView.alpha = 0
        self.pickerView.isHidden = true
        self.blurEffect.alpha = 0
        self.blurEffect.isHidden = true

    }
    
    // MARK: - Picker View -
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString : NSAttributedString
        if component == 0 {
            attributedString = NSAttributedString(string: countriesDict[row]!, attributes: [NSForegroundColorAttributeName : UIColor.init(colorLiteralRed: 72/255, green: 179/255, blue: 229/255, alpha: 1)])
        } else {
            attributedString = NSAttributedString(string: townsDict[row]!, attributes: [NSForegroundColorAttributeName : UIColor.red])
        }
        
        return attributedString
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countriesDict.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return countriesDict[row]
        } else {
            return townsDict[row]
        }
    }
    
    // MARK: - Text Field -
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        self.pickerView.isHidden = false
        self.blurEffect.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.pickerView.center.y = self.view.bounds.midX
            self.pickerView.alpha = 1.0
            self.blurEffect.alpha = 1.0
            
        }
        
        
        return false
    }
}
