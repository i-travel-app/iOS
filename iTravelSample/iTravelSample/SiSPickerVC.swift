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
    var selectedDate: String?
    
    @IBOutlet weak var datesPickerOutlet: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch textFieldTag {
        case 2: titleLabelOutlet.text = "Выберите дату начала поездки:";
        case 3: titleLabelOutlet.text = "Выберите конечную дату поездки:";
        default: break
        }

    }
    
    @IBAction func done(_ sender: Any) {
        let date = self.selectedDate ?? Date().toString(date: Date())
        if textFieldTag == 2 || textFieldTag == 3 {
            
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
    
    
}
