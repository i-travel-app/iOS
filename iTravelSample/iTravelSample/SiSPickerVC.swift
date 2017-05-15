//
//  SiSPickerVC.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 15.05.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class SiSPickerVC: UIViewController {

    @IBOutlet weak var titleLabelOutlet: UILabel!
    var textFieldTag: Int = 0
    
    var callback : ((String) -> Void)?
    
    @IBOutlet weak var placesPickerOutlet: UIPickerView!
    @IBOutlet weak var datesPickerOutlet: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch textFieldTag {
        case 1: titleLabelOutlet.text = "Выберите страну и город:"; self.datesPickerOutlet.alpha = 0
        case 2: titleLabelOutlet.text = "Выберите дату начала поездки:"; self.placesPickerOutlet.alpha = 0
        case 3: titleLabelOutlet.text = "Выберите конечную дату поездки:"; self.placesPickerOutlet.alpha = 0
        default: break
        }

    }
    
    @IBAction func done(_ sender: Any) {
        callback?("Hi")
        self.dismissPicker((Any).self)
    }
    @IBAction func dismissPicker(_ sender: Any) {
        dismiss(animated: true)
    }
}
