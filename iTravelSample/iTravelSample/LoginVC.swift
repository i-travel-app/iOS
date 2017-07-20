//
//  LoginVC.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 11.07.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import CoreData

// Keychain Configuration
struct KeychainConfiguration {
    static let serviceName = "iTravel"
    static let accessGroup: String? = nil
}

class LoginVC: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties -
    var coreData = CoreDataStack.instance
    var passwordItems: [KeychainPasswordItem] = []
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    let touchMe = TouchIDAuth()
    var isKBShown: Bool = false
    var kbFrameSize: CGFloat = 0
    var array: [User] = []
    
    // MARK: - Outlets -
    @IBOutlet weak var suitLogo: UIImageViewX!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField! {
        didSet {
            // В поле "логин" показываем логин последнего пользователя
            // В свойство array вытягиваем из БД всех пользователей
            getAllUsers()
            usernameTextField.text = getLastUserLogin()
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
                    
                    let alertView = UIAlertController(title: "Ошибка ввода!",
                                                      message: "Поля e-mail/пароля не могут быть пустыми.",
                                                      preferredStyle:. alert)
                    let okAction = UIAlertAction(title: "Продолжить", style: .default, handler: nil)
                    alertView.addAction(okAction)
                    present(alertView, animated: true, completion: nil)
                    return
        }
        
        guard (usernameTextField.text?.isValidEmail())! else {
            let alertView = UIAlertController(title: "Ошибка ввода e-mail",
                                              message: "Ошибка e-mail.\nВаш e-mail должен выглядеть, например, так: test@gmail.com",
                                              preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Продолжить", style: .default)
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
            if !isUsernameUsed()! {
                openUserCreationVC()
            } else {
                let alertView = UIAlertController(title: "Ошибка входа!",
                                                  message: "Пользователь с таким именем уже существует.",
                                                  preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Продолжить", style: .default)
                alertView.addAction(okAction)
                present(alertView, animated: true, completion: nil)
            }
            
        } else if sender.tag == loginButtonTag {
            
            if checkLogin() {
                openUserTripsVC()
            } else {
                let alertView = UIAlertController(title: "Ошибка входа!",
                                                  message: "Введен неверный e-mail или пароль.",
                                                  preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Продолжить", style: .default)
                alertView.addAction(okAction)
                present(alertView, animated: true, completion: nil)
            }
        }
    }
    @IBAction func touchIDLoginAction(_ sender: UIButton) {
        touchMe.authenticateUser() { message in
            if let message = message {
                // if the completion is not nil show an alert
                let alertView = UIAlertController(title: "Ошибка",
                                                  message: message,
                                                  preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ой!", style: .default)
                alertView.addAction(okAction)
                self.present(alertView, animated: true)
                
            } else {
                self.openUserTripsVC()
            }
        }
    }
    
    func checkLogin() -> Bool {
        guard isUsernameUsed()! else {
            return false
        }
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: usernameTextField.text!,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            return passwordTextField.text == keychainPassword
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
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        isRegistered()
    }
    
    // MARK: - Private methods -
    func getAllUsers() {
        let context = coreData.persistentContainer.viewContext
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let users = try context.fetch(request)
            if users.isEmpty {
                print("В БД нет пользователей")
            } else {
                array = users
                print("Всего в БД \(users.count) пользователей")
            }
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
    
    func isRegistered() {
        if array.isEmpty || (usernameTextField.text?.isEmpty)! || !isUsernameUsed()! {
            loginButton.setTitle("Создать", for: .normal)
            loginButton.tag = createLoginButtonTag
            createInfoLabel.text = "Введите e-mail и пароль, чтобы зарегистрироваться в приложении."
        } else if isUsernameUsed()! {
            loginButton.setTitle("Войти", for: .normal)
            loginButton.tag = loginButtonTag
            createInfoLabel.text = "Используйте e-mail и пароль, чтобы восстановить историю поездок, участников и собранные чемоданы."
        }
    }
    
    func isUsernameUsed() -> Bool? {
        // Проверка используется ли этот логин
        for user in array {
            //print("user.login = \(String(describing: user.login)) ***** usernameTextField.text = \(String(describing: usernameTextField.text))")
            if user.login == usernameTextField.text {
                //print("Ввведен логин, который уже использовался")
                return true
            }
        }
        //print("Ввведен новый логин")
        return false
    }
    
    func getLastUserLogin() -> String? {
        // Получаем логин крайнего пользователя
        
        if array.isEmpty {
            print("Пользователей нет")
            return nil
        } else {
            print("Логин последнего пользователя .......... \(String(describing: array.last?.login))")
            return array.last?.login
        }
    }
    
    func openUserCreationVC() {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "NewUserVC") as! NewUserVC
        VC.login = usernameTextField.text
        VC.password = passwordTextField.text
        self.present(VC, animated: true, completion: nil)
    }
    
    func openUserTripsVC() {
        
        // check current user isCurrent
        let moc = CoreDataStack.instance.persistentContainer.viewContext
        User.markUserAsCurrent(byLogin: usernameTextField.text!, context:moc)
        
        // open trips view controller or tabbar with it
        //let VC = self.storyboard?.instantiateViewController(withIdentifier: "SiSGeneralViewController") as! SiSGeneralViewController
       // let navController = UINavigationController(rootViewController: VC)
        //self.present(navController, animated: true, completion: nil)
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        self.present(VC, animated: true, completion: nil)
        
    }
}









