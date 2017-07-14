//
//  LoginVC.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 11.07.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

// Keychain Configuration
struct KeychainConfiguration {
    static let serviceName = "iTravel"
    static let accessGroup: String? = nil
}

class LoginVC: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties -
    var passwordItems: [KeychainPasswordItem] = []
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    let touchMe = TouchIDAuth()
    var isKBShown: Bool = false
    var kbFrameSize: CGFloat = 0
    
    // MARK: - Outlets -
    @IBOutlet weak var suitLogo: UIImageViewX!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField! {
        didSet {
            let array = UserDefaults.standard.array(forKey: "usernames") as? [String] ?? [String]()
            if !array.isEmpty {
                usernameTextField.text = array.last
            }
        }
        
    }
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createInfoLabel: UILabel!
    @IBOutlet var touchIDButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isRegistered()
        touchIDButton.isHidden = !touchMe.canEvaluatePolicy()
        registerForKeyboardNotifications()
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
            if self.isKBShown == false {
                self.view.frame.origin.y -= self.kbFrameSize 
                self.suitLogo.isHidden = true
                self.view.layoutSubviews()
            }
        }
        self.isKBShown = true
    }
    
    func kbWillHide() {
        UIView.animate(withDuration:0.3) {
            if self.isKBShown {
                self.view.frame.origin.y += self.kbFrameSize
                self.suitLogo.isHidden = false
                self.view.layoutSubviews()
            }
        }
        self.isKBShown = false
    }

    
    // MARK: - Action for checking username/password
    @IBAction func loginAction(_ sender: AnyObject) {
        // Проверка логина и пароля на пустые поля
        guard
            let newAccountName = usernameTextField.text,
            let newPassword = passwordTextField.text,
            !newAccountName.isEmpty &&
                !newPassword.isEmpty else {
                    
                    let alertView = UIAlertController(title: "Login Problem",
                                                      message: "Wrong username or password.",
                                                      preferredStyle:. alert)
                    let okAction = UIAlertAction(title: "Foiled Again!", style: .default, handler: nil)
                    alertView.addAction(okAction)
                    present(alertView, animated: true, completion: nil)
                    return
        }
        
        guard (usernameTextField.text?.isValidEmail())! else {
            let alertView = UIAlertController(title: "E-mail Problem",
                                              message: "Wrong e-mail.\nYour e-mail should be as example: test@gmail.com",
                                              preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Foiled Again!", style: .default)
            alertView.addAction(okAction)
            present(alertView, animated: true, completion: nil)
            return
        }
        
        // Убираем клавиатуру
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        // Создаю условие: если кнопка создать акк и если кнопка логиниться
        if sender.tag == createLoginButtonTag {
            
            // Проверяю массив логинов на присутствие такого логина
            if !isUsernameUsed() {
                saveUser(newAccountName: newAccountName, newPassword: newPassword)
                openUserCreationVC()
            } else {
                let alertView = UIAlertController(title: "Login Problem",
                                                  message: "User already exists.",
                                                  preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Foiled Again!", style: .default)
                alertView.addAction(okAction)
                present(alertView, animated: true, completion: nil)
            }
            
        } else if sender.tag == loginButtonTag {
            
            // 7
            if checkLogin(username: usernameTextField.text!, password: passwordTextField.text!) {
                saveUser(newAccountName: usernameTextField.text!, newPassword: passwordTextField.text!)
                openUserTripsVC()
            } else {
                // 8
                let alertView = UIAlertController(title: "Login Problem",
                                                  message: "Wrong username or password.",
                                                  preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Foiled Again!", style: .default)
                alertView.addAction(okAction)
                present(alertView, animated: true, completion: nil)
            }
        }
    }
    @IBAction func touchIDLoginAction(_ sender: UIButton) {
        touchMe.authenticateUser() { message in
            if let message = message {
                // if the completion is not nil show an alert
                let alertView = UIAlertController(title: "Error",
                                                  message: message,
                                                  preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Darn!", style: .default)
                alertView.addAction(okAction)
                self.present(alertView, animated: true)
                
            } else {
                // 3
                self.performSegue(withIdentifier: "dismissLogin", sender: self)
            }
        }
    }
    
    func checkLogin(username: String, password: String) -> Bool {
        let array = UserDefaults.standard.array(forKey: "usernames") as? [String] ?? [String]()
        guard array.contains(username) else {
            return false
        }
        
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: username,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            return password == keychainPassword
        }
        catch {
            fatalError("Error reading password from keychain - \(error)")
        }
        
        return false
    }
    
    // MARK: - TextFieldDelegate -
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            usernameTextField.text = ""
            isRegistered()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.usernameTextField {
            self.usernameTextField.resignFirstResponder()
            self.passwordTextField.becomeFirstResponder()
        } else {
            self.passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    // MARK: - Private methods -
    func isRegistered() {
        let array = UserDefaults.standard.array(forKey: "usernames") as? [String] ?? [String]()
        if array.isEmpty || (usernameTextField.text?.isEmpty)! || !isUsernameUsed() {
            loginButton.setTitle("Создать", for: .normal)
            loginButton.tag = createLoginButtonTag
            createInfoLabel.text = "Введите e-mail и пароль, чтобы зарегистрироваться в приложении."
        } else if isUsernameUsed() {
            loginButton.setTitle("Войти", for: .normal)
            loginButton.tag = loginButtonTag
            createInfoLabel.text = "Используйте e-mail и пароль, чтобы восстановить историю поездок, участников и собранные чемоданы."
        } else {
            
        }
    }
    
    func isUsernameUsed() -> Bool {
        let array = UserDefaults.standard.array(forKey: "usernames") as? [String] ?? [String]()
        let hasLoginKey = array.contains(usernameTextField.text!)
        if !hasLoginKey {
            return false
        }
        return true
    }
    
    func saveUser(newAccountName: String, newPassword: String) {
        var array = UserDefaults.standard.array(forKey: "usernames") as? [String] ?? [String]()
        array.append(usernameTextField.text!)
        UserDefaults.standard.set(array, forKey: "usernames")
        do {
            
            // This is a new account, create a new keychain item with the account name.
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: newAccountName,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            
            // Save the password for the new item.
            try passwordItem.savePassword(newPassword)
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
    }
    
    func openUserCreationVC() {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "NewUserVC") as! NewUserVC
        VC.login = usernameTextField.text
        self.present(VC, animated: true, completion: nil)
    }
    
    func openUserTripsVC() {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SiSGeneralViewController") as! SiSGeneralViewController
        let navController = UINavigationController(rootViewController: VC)
        self.present(navController, animated: true, completion: nil)
    }
}









