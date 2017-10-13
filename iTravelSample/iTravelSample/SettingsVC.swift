//
//  SettingsVC.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 08.10.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import CoreData

class SettingsVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties -
    var context: NSManagedObjectContext {
        return CoreDataStack.instance.persistentContainer.viewContext
    }
    var currentUser: User? {
        didSet {
            currentUser = User.getCurrentUser(context: context)
        }
    }
    var isKBShown: Bool = false
    var kbFrameSize: CGFloat = 0
    
    // MARK: - Outlets -
    @IBOutlet weak var imgUser: UIImageViewX!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var segmentedGender: UISegmentedControl!
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // textfields delegates
        nameTF?.delegate = self
        ageTF?.delegate = self
        loginTF.delegate = self
        passwordTF.delegate = self
        ageTF?.addPoleForButtonsToKeyboard(myAction: #selector(ageTF.resignFirstResponder), buttonNeeds: true)
        currentUser = { currentUser }()
        //print("Сейчас используется пользователь с логином \(currentUser?.login)")
        if let user = currentUser {
            imgUser.image = UIImage(data: user.image! as Data)
            nameTF.text = user.name
            ageTF.text = "\(user.age)"
            segmentedGender.selectedSegmentIndex = user.isMan ? 0 : 1
            loginTF.text = user.login
            
            do {
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                        account: user.login!,
                                                        accessGroup: KeychainConfiguration.accessGroup)
                let keychainPassword = try passwordItem.readPassword()
                passwordTF.text = keychainPassword
            }
            catch {
                fatalError("Error reading password from keychain - \(error)")
            }
        }
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
            self.stackView.spacing = 30
        } else {
            segmentedGender.setTitle("М", forSegmentAt: 0)
            segmentedGender.setTitle("Ж", forSegmentAt: 1)
            
        }
    }
    
    override func viewWillLayoutSubviews() {
        imgUser?.layer.cornerRadius = imgUser.frame.size.width / 2
        imgUser?.clipsToBounds = true
        
        super.viewWillLayoutSubviews()
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
    
    @objc func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrame = (userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        kbFrameSize = kbFrame.height
        UIView.animate(withDuration:0.3) {
            if !self.isKBShown {
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: self.kbFrameSize, right: 0)
                self.scrollView.contentInset = contentInsets
            }
        }
        self.isKBShown = true
    }
    
    @objc func kbWillHide() {
        UIView.animate(withDuration:0.3) {
            if self.isKBShown {
                self.scrollView.contentInset = .zero
            }
        }
        self.isKBShown = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imgUser.image = info[UIImagePickerControllerEditedImage] as? UIImage
        imgUser.contentMode = .scaleAspectFill
        imgUser.layer.cornerRadius = imgUser.frame.height / 2
        imgUser.clipsToBounds = true
        imgUser.borderWidth = 1.0
        dismiss(animated: true, completion: nil)
        
        updateUserInfo()
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
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateUserInfo()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTF {
            nameTF.resignFirstResponder()
            ageTF.becomeFirstResponder()
        } else if textField == ageTF {
            ageTF.resignFirstResponder()
            loginTF.becomeFirstResponder()
        } else if textField == loginTF {
            loginTF.resignFirstResponder()
            passwordTF.becomeFirstResponder()
        } else {
            passwordTF.resignFirstResponder()
        }
        return true
    }
    
    // MARK: - Actions -
    @IBAction func finishSession() {
        User.allUsersMakeNoCurrent()
        UserDefaults.standard.set(currentUser?.login, forKey: "last_user_session")
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.present(VC, animated: true, completion: nil)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
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
    
    func chooseImagePickerAction(source: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
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
        
        updateUserInfo()        
    }
    
    // MARK: - Private Methods -
    func updateUserInfo() {
        guard !((nameTF.text?.isEmpty)!) || !((ageTF.text?.isEmpty)!) || !((loginTF.text?.isEmpty)!) || !((passwordTF.text?.isEmpty)!) else {
            self.warningAlert()
            return
        }
        
        currentUser?.name = nameTF.text
        currentUser?.age = Int16(ageTF.text!)!
        
        switch segmentedGender.selectedSegmentIndex {
        case 0: currentUser?.isMan = true;
        case 1: currentUser?.isMan = false;
        default: break
        }
        currentUser?.login = loginTF.text
        
        let imageData = NSData(data: UIImageJPEGRepresentation(imgUser.image!, 1.0)!)
        currentUser?.image = imageData
        
        do {
            try context.save()
        } catch {
            fatalError()
        }
        
        // Сохранение пароля в KeyChain
        do {
            // This is a new account, create a new keychain item with the account name.
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: (currentUser?.login!)!,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            
            // Save the password for the new item.
            try passwordItem.savePassword(passwordTF.text!)
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
    }
    
    // MARK: - Alerts -
    func warningAlert() {
        let alert = UIAlertController(title: "Поле не может быть пустым!", message: "Поля \"Имя\", \"Возраст\", \"Логин\" и \"Пароль\" не могут быть пустыми для сохранения Ваших данных", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
