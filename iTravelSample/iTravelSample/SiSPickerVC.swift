//
//  SiSPickerVC.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 15.05.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

protocol SiSPickerVCDelegate {
    func fillTF(tFTag: Int, text: String)
}

class SiSPickerVC: UIViewController {

    @IBOutlet weak var titleLabelOutlet: UILabel!
    var textFieldTag: Int = 0
    var selectedDate: String?
    
    var delegate : SiSPickerVCDelegate?
    
    @IBOutlet weak var placesPickerOutlet: UIPickerView!
    @IBOutlet weak var datesPickerOutlet: UIDatePicker!
    
    var placesPicker : SiSPlacesPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placesPicker = SiSPlacesPickerView()
        self.placesPickerOutlet.delegate = placesPicker
        self.placesPickerOutlet.dataSource = placesPicker
        
        switch textFieldTag {
        case 1: titleLabelOutlet.text = "Выберите страну и город:"; self.datesPickerOutlet.alpha = 0
        case 2: titleLabelOutlet.text = "Выберите дату начала поездки:"; self.placesPickerOutlet.alpha = 0
        case 3: titleLabelOutlet.text = "Выберите конечную дату поездки:"; self.placesPickerOutlet.alpha = 0
        default: break
        }

    }
    
    @IBAction func done(_ sender: Any) {
        let text: String? = "\(self.placesPicker.country), \(self.placesPicker.town)"
        let date = self.selectedDate ?? toString(date: Date())
        if textFieldTag == 1 {
            delegate?.fillTF(tFTag:textFieldTag, text: text!)
        } else if textFieldTag == 2 || textFieldTag == 3 {
            delegate?.fillTF(tFTag:textFieldTag, text: date)
        }
        
        self.dismissPicker((Any).self)
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        // Apply date format
        self.selectedDate = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func dismissPicker(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func toString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy" //Your date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let date = dateFormatter.string(from: date) //according to date format your date string
        return date
    }
}
