//
//  SiSPersonDetailsVC.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 16.05.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class SiSPersonDetailsVC: UIViewController, UITextFieldDelegate {
    
    var name = ""
    var surname = ""
    var age = ""
    var gender = ""
    
    @IBOutlet weak var nameTF: UITextFieldX!
    @IBOutlet weak var surnameTF: UITextFieldX!
    @IBOutlet weak var ageTF: UITextFieldX!
    @IBOutlet weak var genderTF: UITextFieldX!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameTF.text = name
        self.surnameTF.text = surname
        self.ageTF.text = age
        self.genderTF.text = gender
        
        self.nameTF.delegate = self
        self.surnameTF.delegate = self
        self.ageTF.delegate = self
        self.genderTF.delegate = self
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.nameTF {
            
            self.surnameTF.becomeFirstResponder()
            
        } else if textField == self.surnameTF {
            
            self.genderTF.becomeFirstResponder()
            
        } else if textField == self.genderTF {
            
            self.ageTF.becomeFirstResponder()
            
        } else {
            
            self.ageTF.resignFirstResponder()
        }
        
        return true
    }

}
