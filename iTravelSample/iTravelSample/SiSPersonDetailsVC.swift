//
//  SiSPersonDetailsVC.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 16.05.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

protocol SiSPersonDetailsVCDelegate {
    func addPersonToItemsArray(person: SiSPersonModel)
}

class SiSPersonDetailsVC: UIViewController, UITextFieldDelegate {
    
    var person: SiSPersonModel? = nil
    var delegate: SiSPersonDetailsVCDelegate?
    
    
    @IBOutlet weak var nameTF: UITextFieldX!
    @IBOutlet weak var surnameTF: UITextFieldX!
    @IBOutlet weak var ageTF: UITextFieldX!
    @IBOutlet weak var genderTF: UITextFieldX!
    @IBOutlet weak var saveBtn: UIButtonX!
    
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    
    @IBOutlet weak var popupView: UIViewX!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameTF.text = person?.name
        self.surnameTF.text = person?.surname
        self.ageTF.text = String(person!.age)
        self.genderTF.text = person?.gender
        
        self.nameTF.delegate = self
        self.surnameTF.delegate = self
        self.ageTF.delegate = self
        self.genderTF.delegate = self
        
        self.popupView.alpha = 0
        
        registerForKeyboardNotifications()
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.bottomConstant.constant = kbFrameSize.height + 20
        UIView.animate(withDuration:0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.genderTF {
            
            UIView.animate(withDuration: 0.3) {
                self.popupView.alpha = 0.8
            }
            
            return false
        }
        
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    @IBAction func dismissAndSave(_ sender: UIButtonX) {
        self.person?.name = self.nameTF.text!
        self.person?.surname = self.surnameTF.text!
        self.person?.age = Int(self.ageTF.text!)!
        self.person?.gender = self.genderTF.text!
        delegate?.addPersonToItemsArray(person: self.person!)
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func mensBtn(_ sender: UIButton) {
        self.genderTF.text = "мужской"
        popupAnimation()
    }
    
    @IBAction func womensBtn(_ sender: UIButton) {
        self.genderTF.text = "женский"
        popupAnimation()
    }
    
    func popupAnimation() {
        if self.popupView.alpha == 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.popupView.alpha = 0.8
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: { 
                self.popupView.alpha = 0
            })
        }
    }

}
