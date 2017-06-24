//
//  ParticipantDetailsVC.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 24.06.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class ParticipantDetailsVC: UIViewController, UITextFieldDelegate {
    
    // - Outlets -
    @IBOutlet weak var imgUser: UIImageViewX!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var segmentedGender: UISegmentedControl!
    
    
    // - Properties -
    override func viewDidLoad() {
        super.viewDidLoad()

        registerForKeyboardNotifications()
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
        UIView.animate(withDuration:0.3) {
            self.view.center.y -= kbFrameSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    // - Textfields methods -
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    // - Actions -
    @IBAction func segmentedGender(_ sender: Any) {
        switch segmentedGender.selectedSegmentIndex {
        case 0: imgUser.image = UIImage(named: "Man")
        case 1: imgUser.image = UIImage(named: "Woman")
        default: break
        }
    }
    
    @IBAction func saveParticipant(_ sender: Any) {
        
    }
    


    

    
}
