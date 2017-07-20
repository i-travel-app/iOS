//
//  TargetPlaceSelectingVC.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 14.06.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import MapKit

protocol TargetPlaceDelegate {
    func addTargetPlace(country: String, city: String, id: Int)
}

class TargetPlaceSelectingVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    var countriesTVActive = false
    var kbFrameSize: CGRect?
    var target: String?
    
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    @IBOutlet weak var targetCountry: UITextFieldX!
    @IBOutlet weak var targetCity: UITextFieldX!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewTopConstr: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var map: MKMapView!
    
    var targetsArray = [String]()
    var geocoder = CLGeocoder()
    var targetID: Int?
    
    var delegate: TargetPlaceDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.target != nil {
            let arr = target?.components(separatedBy: ", ")
            self.targetCity.text = arr?[0]
            self.targetCountry.text = arr?[1]
            self.showMapLocation(address: target!)
        }
        
        self.targetCountry.delegate = self
        self.targetCity.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.layer.borderColor = Constants.blueColor.cgColor
        self.tableView.layer.borderWidth = 1
        self.tableView.layer.cornerRadius = 15
        self.tableView.separatorColor = Constants.blueColor
        
        self.map.layer.borderColor = Constants.blueColor.cgColor
        self.map.layer.borderWidth = 1
        self.map.layer.cornerRadius = 15
        
        registerForKeyboardNotifications()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateViewConstraints()
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
        self.kbFrameSize = kbFrameSize
        self.bottomConstant.constant = kbFrameSize.height + 20
        UIView.animate(withDuration:0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        delegate?.addTargetPlace(country: self.targetCountry.text!, city: self.targetCity.text!, id: targetID!)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Text functions -
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let substring = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if textField.tag == 1 {
            self.countriesTVActive = true
            self.targetsArray = TargetPlace.getAllTargetsCountryFromDB(withName: substring)
        } else if textField.tag == 2 {
            self.countriesTVActive = false
            if (self.targetCountry.text?.characters.count)! > 1 || substring.characters.count > 1 {
                self.targetsArray = TargetPlace.getAllTargetsCitiesFromDB(withName: substring, andCountry: self.targetCountry.text!)
            } else if self.targetCountry.text != "" {
                self.targetsArray = TargetPlace.getAllTargetsCitiesFromDB(withName: substring, andCountry: self.targetCountry.text!)
            }
        }
        
        self.updateViewConstraints()
        tableView.reloadData()
        return true
    }
    
    // MARK: - TableView delegate -
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UITableViewCellX
        let arrayStr = self.targetsArray[indexPath.row].components(separatedBy: ", ")
        if arrayStr.count > 1{
            cell.label.text = String(arrayStr[0] + ", " + arrayStr[1])
        } else {
            cell.label.text = arrayStr[0]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targetsArray.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.countriesTVActive {
            self.targetCountry.text = self.targetsArray[indexPath.row]
        } else {
            let arrayStr = self.targetsArray[indexPath.row].components(separatedBy: ", ")
            self.targetCity.text = arrayStr[0]
            self.targetCountry.text = arrayStr[1]
            self.targetID = Int(arrayStr[2])
        }
        self.hideTableView()
        self.targetCountry.endEditing(true)
        self.targetCity.endEditing(true)
        if (self.targetCity.text?.characters.count)! > 1 && (self.targetCountry.text?.characters.count)! > 1 {
            self.showMapLocation(address: String("\(self.targetCity.text!), \(self.targetCountry.text!)"))
        } else if (self.targetCountry.text?.characters.count)! > 1 {
            self.showMapLocation(address: String("\(self.targetCountry.text!)"))
        } else if (self.targetCity.text?.characters.count)! > 1 {
            self.showMapLocation(address: String("\(self.targetCity.text!)"))
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.targetCountry {
            if (self.targetCity.text?.characters.count)! > 1 {
            self.targetCity.text = ""
            }
        }
        return true
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
            self.countriesTVActive = false
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
        if self.countriesTVActive {
            self.tableViewTopConstr.constant = 0
        } else {
            self.tableViewTopConstr.constant = self.targetCity.frame.maxY - self.targetCountry.frame.maxY
        }
        
        let heightDefault = CGFloat(self.targetsArray.count) * 44.0
        if self.kbFrameSize == nil {
            
            self.tableViewHeightConstr.constant = heightDefault
        
        } else {
            
            let frameKB = self.view.convert(kbFrameSize!, from: self.view)
            //print("frame is \(frameKB)")
            let heightRecalc = self.countriesTVActive ? frameKB.origin.y - targetCountry.frame.maxY : frameKB.origin.y - targetCity.frame.maxY
            let variable = self.countriesTVActive ? targetCountry.frame.maxY : targetCity.frame.maxY
            
            if (heightDefault + variable) >= frameKB.origin.y {
                
                self.tableViewHeightConstr.constant = heightRecalc
                
            } else {
                
                self.tableViewHeightConstr.constant = heightDefault
                
            }
            
            //print("else height is \(self.tableViewHeightConstr.constant) = \(frameKB.origin.y) - \(targetCity.frame.maxY) - \(tableView.frame.maxY)")
        }
    }
    
    func hideTableView() {
        self.targetsArray.removeAll()
        self.updateViewConstraints()
        self.tableView.reloadData()
    }
    
    func showMapLocation(address: String) {
        self.geocoder.geocodeAddressString(address) { (placemarks, error) in
            
            guard error == nil else { return }
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first!
            
            let allAnotations = self.map.annotations
            self.map.removeAnnotations(allAnotations)
            
            let annotation = MKPointAnnotation()
            annotation.title = address
            
            guard let location = placemark.location else { return }
            annotation.coordinate = location.coordinate
            
            self.map.showAnnotations([annotation], animated: true)
            self.map.selectAnnotation(annotation, animated: true)
            let span = MKCoordinateSpanMake(30, 30)
            let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
            self.map.setRegion(region, animated: true)
            self.map.isZoomEnabled = true
            self.map.isScrollEnabled = true
        }
    }

}





