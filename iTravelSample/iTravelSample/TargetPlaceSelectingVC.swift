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

    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    
    @IBOutlet weak var targetCountry: UITextFieldX!
    @IBOutlet weak var targetCity: UITextFieldX!
    @IBOutlet weak var tableViewCountries: UITableView!
    @IBOutlet weak var tableViewCities: UITableView!
    @IBOutlet weak var tableViewHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstr2: NSLayoutConstraint!
    
    var targetsArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.targetCountry.delegate = self
        self.targetCity.delegate = self
        self.tableViewCountries.delegate = self
        self.tableViewCountries.dataSource = self
        self.tableViewCities.delegate = self
        self.tableViewCities.dataSource = self
        
        self.tableViewCountries.layer.borderColor = Constants.blueColor.cgColor
        self.tableViewCountries.layer.borderWidth = 1
        self.tableViewCountries.layer.cornerRadius = 15
        self.tableViewCountries.separatorColor = Constants.blueColor
        
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
        
        self.targetsArray = textField.tag == 1 ? CoreDataStack.instance.getAllTargetsCountryFromDB(withName: substring) : CoreDataStack.instance.getAllTargetsCitiesFromDB(withName: substring, andCountry: self.targetCountry.text!)
        self.updateViewConstraints()
        tableViewCountries.reloadData()
        tableViewCities.reloadData()
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
        self.targetCountry.text = self.targetsArray[indexPath.row]
        
        if (self.tableViewCountries != nil) {
            self.hideTableView(tableView: self.tableViewCountries)
            self.targetCountry.endEditing(true)
        } else {
            
        }
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
        if (self.tableViewCountries != nil) {
            self.tableViewHeightConstr.constant = CGFloat(self.targetsArray.count) * 44.0
        } else {
            self.tableViewHeightConstr2.constant = CGFloat(self.targetsArray.count) * 44.0
        }
    }
    
    func hideTableView(tableView: UITableView) {
        self.targetsArray.removeAll()
        self.updateViewConstraints()
        tableView.reloadData()
    }

}
