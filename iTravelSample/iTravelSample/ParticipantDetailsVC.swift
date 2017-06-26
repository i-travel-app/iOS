//
//  ParticipantDetailsVC.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 24.06.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import CoreData

class ParticipantDetailsVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // - Outlets -
    @IBOutlet weak var imgUser: UIImageViewX!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var segmentedGender: UISegmentedControl!
    
    
    // - Properties -
    var isKBShown: Bool = false
    var kbFrameSize: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newBackButton = UIBarButtonItem(title: "<Назад", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        // textfields delegates
        nameTF.delegate = self
        ageTF.delegate = self
        nameTF.addPoleForButtonsToKeyboard(myAction: nil, buttonNeeds: false)
        ageTF.addPoleForButtonsToKeyboard(myAction: #selector(ageTF.resignFirstResponder), buttonNeeds: true)
        registerForKeyboardNotifications()
        
        // imgUser gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgUser.isUserInteractionEnabled = true
        imgUser.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imgUser.image = info[UIImagePickerControllerEditedImage] as? UIImage
        imgUser.contentMode = .scaleAspectFill
        imgUser.cornerRadius = imgUser.frame.height / 2
        imgUser.clipsToBounds = true
        imgUser.borderWidth = 1.0
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrame = (userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        kbFrameSize = kbFrame.height
        UIView.animate(withDuration:0.3) {
            if !self.isKBShown {
                self.view.center.y -= (UIScreen.main.bounds.size.height > 600.0 ? self.kbFrameSize : (self.kbFrameSize - 40))
                self.view.layoutIfNeeded()
            }
        }
        self.isKBShown = true
    }
    
    func kbWillHide() {
        UIView.animate(withDuration:0.3) {
            if self.isKBShown {
                self.view.center.y += (UIScreen.main.bounds.size.height > 600.0 ? self.kbFrameSize : (self.kbFrameSize - 40))
                self.view.layoutIfNeeded()
            }
        }
        self.isKBShown = false
    }
    
    // MARK: - Textfields methods -
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == ageTF {
            let maxLength = 2
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else {
            return true
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == nameTF {
            ageTF.becomeFirstResponder()
        }
        return true
    }
    
    // MARK: - Actions -
    @IBAction func segmentedGender(_ sender: Any) {
        
        if imgUser.image == UIImage(named: "Man") {
            imgUser.image = UIImage(named: "Woman")
            imgUser.borderWidth = 0
            imgUser.contentMode = .scaleAspectFit
        } else if imgUser.image == UIImage(named: "Woman") {
            imgUser.image = UIImage(named: "Man")
            imgUser.borderWidth = 0
            imgUser.contentMode = .scaleAspectFit
        }
        
    }
    
    @IBAction func saveParticipant(_ sender: Any) {
        if (nameTF.text?.isEmpty)! || (ageTF.text?.isEmpty)! {
            warningAlert()
        } else {
            let moc = CoreDataStack().persistentContainer.viewContext
            let participant = Participant(context: moc)
            
            if let newID = participant.getParticipantID(context: moc) {
                participant.idUser = Int16(newID)
                //print("\n\n\nnewID = \(newID)")
            }
            
            if let name = nameTF.text {
                participant.name = name
                //print("\n\n\nname = \(name)")
            }
            
            if let age = ageTF.text {
                participant.age = Int16(age)!
                //print("\n\n\nage = \(age)")
            }
            
            switch segmentedGender.selectedSegmentIndex {
            case 0: participant.isMan = true; print("\n\n\nisMan = true")
            case 1: participant.isMan = false; print("\n\n\nisMan = false")
            default: break
            }
            
            if let img = imgUser.image {
                let imageData = NSData(data: UIImageJPEGRepresentation(img, 1.0)!)
                participant.image = imageData
            }
            
            CoreDataStack().saveContext()
        }
        
        back()
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let ac = UIAlertController(title: "Источник фотографии", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Камера", style: .default) { (action) in
            self.chooseImagePickerAction(source: .camera)
        }
        let photoLibAction = UIAlertAction(title: "Фото", style: .default) { (action) in
            self.chooseImagePickerAction(source: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        ac.addAction(cameraAction)
        ac.addAction(photoLibAction)
        ac.addAction(cancelAction)
        self.present(ac, animated: true, completion: nil)
    }
    
    func back() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    func chooseImagePickerAction(source: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: - Alerts -
    func warningAlert() {
        let alert = UIAlertController(title: "Поле не может быть пустым!", message: "Поля \"Имя\" и \"Возраст\" не могут быть пустыми для сохранения данных об участнике Вашей поездки", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
}
