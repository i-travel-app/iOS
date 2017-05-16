//
//  SiSNewTripViewController.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 11.05.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class SiSNewTripViewController: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, SiSPickerVCDelegate {
    
    let reuseCollectionViewIdentifier = "person"
    var items = [("Степан", "Иванов", 25, "мужской"),("Лариса Ивановна", "Петрова", 47, "женский"),("Крошка Сын", "Николаев", 12, "мужской"),("сосед Жора", "Сидоров", 41, "мужской"),("друг Жоры", "Куликов", 41, "мужской"),("Степан", "Иванов", 25, "мужской"),("Лариса Ивановна", "Петрова", 47, "женский"),("Крошка Сын", "Николаев", 12, "мужской"),("сосед Жора", "Сидоров", 41, "мужской"),("друг Жоры", "Куликов", 41, "мужской")]
    
    @IBOutlet weak var stepperValue: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var collectionViewPersons: UICollectionView!
    
    @IBOutlet weak var targetPlaceTF: UITextFieldX!
    @IBOutlet weak var startTripDate: UITextFieldX!
    @IBOutlet weak var endTripDate: UITextFieldX!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Создание поездки"

    }
    
    @IBAction func stepperAction(_ sender: Any) {
        self.stepperValue.text = String(Int(stepper.value))
        self.collectionViewPersons.reloadData()
        //print(Int(stepper.value))
    }
    
    // MARK: - Text Field -
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        // show blur VC for PickerView
        let modalVC = storyboard?.instantiateViewController(withIdentifier: "SiSPickerVC") as! SiSPickerVC
        modalVC.modalPresentationStyle = .overCurrentContext
        modalVC.textFieldTag = textField.tag
        modalVC.delegate = self
        present(modalVC, animated: true, completion: nil)
        
        return false
    }
    
    // MARK: - UICollectionViewDataSource protocol -
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(stepper.value)
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCollectionViewIdentifier, for: indexPath as IndexPath) as! SiSCollectionViewCell
        
        // Use the outlet in our cusyom class to get a reference to the UILabel in the cell
        cell.myLabel.text = self.items[indexPath.item].0
        cell.backgroundColor = UIColor.white
        cell.imagePersonOutlet.image = UIImage(named:"person.png")
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol - 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        let title = self.items[indexPath.item]
        print("You selected cell \(title)!")
        
        // open SiSPersonDetailVC
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SiSPersonDetailsVC") as! SiSPersonDetailsVC
        VC.name = title.0
        VC.surname = title.1
        VC.age = String(title.2)
        VC.gender = title.3
        self.navigationController!.pushViewController(VC, animated: true)
    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - SiSPickerVCDelegate -
    func fillTF(tFTag: Int, text: String) {
        switch tFTag {
        case 1: self.targetPlaceTF.text = text
        case 2: self.startTripDate.text = text
        case 3: self.endTripDate.text = text
        default: break
        }
        
        if self.startTripDate.text != "" && self.endTripDate.text != "" {
            checkCorrectTripDates(startDate: self.startTripDate.text!, endDate: self.endTripDate.text!)
        }
    }
    
    // MARK: - Private functions -
    
    func checkCorrectTripDates(startDate: String, endDate: String) {
        if toDate(date: startDate) > toDate(date: endDate) {
            self.startTripDate.text = ""
            self.endTripDate.text = ""
            warningAlert(title: "Ошибка при указании дат поездки!", message: "Начало поездки не может быть позже ее завершения\nВами указаны даты \nс \(startDate) \nпо \(endDate)")
        }
    }
    
    func warningAlert(title: String, message: String ){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:  { (action) -> Void in
        }))
        if presentedViewController == nil {
            self.present(alert, animated: true, completion: nil)
        } else{
            self.dismiss(animated: false) { () -> Void in
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func toDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy" //Your date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let date = dateFormatter.date(from: date) //according to date format your date string
        print(date ?? "") //Convert String to Date        
        return date!
    }
    
    
}
