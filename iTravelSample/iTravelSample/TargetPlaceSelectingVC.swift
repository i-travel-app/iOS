//
//  TargetPlaceSelectingVC.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 14.06.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import CoreGraphics

class TargetPlaceSelectingVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    var coutriesTVActive = false
    
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    @IBOutlet weak var targetCountry: UITextFieldX!
    @IBOutlet weak var targetCity: UITextFieldX!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewTopConstr: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstr: NSLayoutConstraint!
    
    var targetsArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.targetCountry.delegate = self
        self.targetCity.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.layer.borderColor = Constants.blueColor.cgColor
        self.tableView.layer.borderWidth = 1
        self.tableView.layer.cornerRadius = 15
        self.tableView.separatorColor = Constants.blueColor
        
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
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Text functions -
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let substring = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if textField.tag == 1 {
            self.coutriesTVActive = true
            self.targetsArray = CoreDataStack.instance.getAllTargetsCountryFromDB(withName: substring)
        } else if textField.tag == 2 {
            self.coutriesTVActive = false
            if (self.targetCountry.text?.characters.count)! > 1 || substring.characters.count > 1 {
                self.targetsArray = CoreDataStack.instance.getAllTargetsCitiesFromDB(withName: substring, andCountry: self.targetCountry.text!)
            } else if self.targetCountry.text != "" {
                self.targetsArray = CoreDataStack.instance.getAllTargetsCitiesFromDB(withName: substring, andCountry: self.targetCountry.text!)
            }
        }
        
        self.updateViewConstraints()
        tableView.reloadData()
        return true
    }
    
    // MARK: - TableView delegate -
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UITableViewCellX
        cell.label.text = targetsArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targetsArray.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.coutriesTVActive {
            self.targetCountry.text = self.targetsArray[indexPath.row]
        } else {
            let arrayStr = self.targetsArray[indexPath.row].components(separatedBy: ", ")
            self.targetCity.text = arrayStr[0]
            self.targetCountry.text = arrayStr[1]
        }
        self.hideTableView()
        self.targetCountry.endEditing(true)
        self.targetCity.endEditing(true)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.hideTableView()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.bottomConstant.constant = 20.0
        UIView.animate(withDuration:0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.targetCountry {
            self.targetCountry.resignFirstResponder()
            self.targetCity.becomeFirstResponder()
            self.coutriesTVActive = false
        } else {
            self.targetCity.resignFirstResponder()
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell:
        UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.3, animations: {
            cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
        },completion: { finished in
            UIView.animate(withDuration: 0.1, animations: {
                cell.layer.transform = CATransform3DMakeScale(1,1,1)
            })
        })
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if self.coutriesTVActive {
            self.tableViewTopConstr.constant = 0
        } else {
            self.tableViewTopConstr.constant = self.targetCity.frame.maxY - self.targetCountry.frame.maxY
        }
        self.tableViewHeightConstr.constant = CGFloat(self.targetsArray.count) * 44.0

    }
    
    func hideTableView() {
        self.targetsArray.removeAll()
        self.updateViewConstraints()
        self.tableView.reloadData()
    }

}
