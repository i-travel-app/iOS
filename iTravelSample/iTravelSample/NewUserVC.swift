//
//  newUserVC.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 12.07.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import CoreData

class NewUserVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // - Outlets -
    @IBOutlet weak var imgUser: UIImageViewX!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var segmentedGender: UISegmentedControl!
    @IBOutlet weak var stackView: UIStackView!
    
    // - Properties -
    var isKBShown: Bool = false
    var kbFrameSize: CGFloat = 0
    var coreData = CoreDataStack()
    var user: User!
    var login: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // textfields delegates
        nameTF?.delegate = self
        ageTF?.delegate = self
        nameTF?.addPoleForButtonsToKeyboard(myAction: nil, buttonNeeds: false)
        ageTF?.addPoleForButtonsToKeyboard(myAction: #selector(ageTF.resignFirstResponder), buttonNeeds: true)
        registerForKeyboardNotifications()
        
        // imgUser gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgUser?.isUserInteractionEnabled = true
        imgUser?.addGestureRecognizer(tapGestureRecognizer)
        
        
        // imageView properties
        imgUser?.contentMode = .scaleAspectFill
        imgUser?.borderWidth = 1.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UIScreen.main.bounds.size.height > 600.0 {
            self.stackView.spacing = 50
        }
    }
    
    override func viewWillLayoutSubviews() {
        imgUser?.layer.cornerRadius = imgUser.frame.size.width / 2
        imgUser?.clipsToBounds = true
        
        super.viewWillLayoutSubviews()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imgUser.image = info[UIImagePickerControllerEditedImage] as? UIImage
        imgUser.contentMode = .scaleAspectFill
        imgUser.layer.cornerRadius = imgUser.frame.height / 2
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
                self.view.frame.origin.y -= self.kbFrameSize
            }
        }
        self.isKBShown = true
    }
    
    func kbWillHide() {
        UIView.animate(withDuration:0.3) {
            if self.isKBShown {
                self.view.frame.origin.y += self.kbFrameSize
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
    
    @IBAction func segmentedGender(_ sender: UISegmentedControl) {
        
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
    
    @IBAction func saveUser(_ sender: UIButtonX) {
        
        if (nameTF.text?.isEmpty)! || (ageTF.text?.isEmpty)! {
            warningAlert()
        } else {
            let moc = coreData.persistentContainer.viewContext
            user = User(context: coreData.persistentContainer.viewContext)
            
            if let newID = user.getUserID(context: moc) {
                user.idUser = Int16(newID)
            }
            
            if let eMail = login {
                user.login = eMail
            }
            
            if let name = nameTF.text {
                user.name = name
            }
            
            if let age = ageTF.text {
                user.age = Int16(age)!
            }
            
            switch segmentedGender.selectedSegmentIndex {
            case 0: user.isMan = true;
            case 1: user.isMan = false;
            default: break
            }
            
            if let img = imgUser.image {
                let imageData = NSData(data: UIImageJPEGRepresentation(img, 1.0)!)
                user.image = imageData
            }
            user.isCurrent = true
            
            self.coreData.saveContext()
        }
        
        // Сохранение пароля в KeyChain
        do {
            // This is a new account, create a new keychain item with the account name.
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: login!,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            
            // Save the password for the new item.
            try passwordItem.savePassword(password!)
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
        
        openUserTripsVC()
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
    
    func openUserTripsVC() {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SiSGeneralViewController") as! SiSGeneralViewController
        let navController = UINavigationController(rootViewController: VC)
        self.present(navController, animated: true, completion: nil)
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
        let alert = UIAlertController(title: "Поле не может быть пустым!", message: "Поля \"Имя\" и \"Возраст\" не могут быть пустыми для сохранения Ваших данных", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

}
