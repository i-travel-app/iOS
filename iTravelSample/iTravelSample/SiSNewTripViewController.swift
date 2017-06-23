//
//  SiSNewTripViewController.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 11.05.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class SiSNewTripViewController: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, SiSPersonDetailsVCDelegate, TargetPlaceDelegate, PickerVCDelegate {
    
    let reuseCollectionViewIdentifier = "person"
    var items = [SiSPersonModel]()
    
    @IBOutlet weak var stepperValue: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var collectionViewPersons: UICollectionView!
    
    @IBOutlet weak var targetPlaceTF: UITextFieldX!
    @IBOutlet weak var startTripDate: UITextFieldX!
    @IBOutlet weak var endTripDate: UITextFieldX!
    
    var trip: SiSTripModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Создание поездки"
        // прячем кнопку Главный экран и назначаем свою
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "<Назад", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SiSNewTripViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    func back(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Данные не будут сохранены", message: "В случае выхода из этого меню, Ваши данные не сохранятся! Введите детали поездки и нажмите кнопку \"Сохранить\" для сохранения поездки.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:  { (action) ->
            Void in
            _ = self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertActionStyle.default, handler: nil))
        
        self.navigationController?.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func stepperAction(_ sender: Any) {
        if Int(stepper.value) > Int(self.stepperValue.text!)! {
            // Открытие выбора участников в поездке
            openParticipantsTVC()
        } else if Int(stepper.value) < Int(self.stepperValue.text!)!{
            self.items.removeLast()
            self.collectionViewPersons.reloadData()
        }
        
        self.stepperValue.text = String(Int(stepper.value))
    }
    
    // MARK: - Text Field -
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.tag == 1 {
            // show controller to select Target place
            print("Здесь открываем выбор страны и города")
            let modalVC = storyboard?.instantiateViewController(withIdentifier: "TargetPlaceSelectingVC") as! TargetPlaceSelectingVC
            modalVC.modalPresentationStyle = .overCurrentContext
            modalVC.delegate = self
            if !(textField.text?.isEmpty)! {
                modalVC.target = textField.text
            }
            present(modalVC, animated: true, completion: nil)
        } else {
            // show blur VC for PickerView
            let modalVC = storyboard?.instantiateViewController(withIdentifier: "SiSPickerVC") as! SiSPickerVC
            modalVC.modalPresentationStyle = .overCurrentContext
            modalVC.textFieldTag = textField.tag
            modalVC.delegate = self
            present(modalVC, animated: true, completion: nil)
        }
        
        return false
    }
    
    // MARK: - UICollectionViewDataSource protocol -
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCollectionViewIdentifier, for: indexPath as IndexPath) as! SiSCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        print("indexPath is \(indexPath) and indexPath.row is \(indexPath.row)")
        let person = self.items[indexPath.row]
        cell.myLabel.text = person.name + " " + person.surname
        cell.backgroundColor = UIColor.white
        cell.imagePersonOutlet.image = UIImage(named:"person.png")
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol - 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // open SiSPersonDetailVC
        openPersonVC(person: items[indexPath.row])
    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        print("Нажата кнопка Сохранить поездку")
    }
    
    // MARK: - SiSPickerVCDelegate -
    func fillTF(tFTag: Int, text: String) {
        switch tFTag {
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
        if Date().toDate(date: startDate) > Date().toDate(date: endDate) {
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
    
    func openParticipantsTVC() {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ParticipantsTVC") as! ParticipantsTVC
        self.navigationController!.pushViewController(VC, animated: true)
    }
    
    func openPersonVC(person: SiSPersonModel) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SiSPersonDetailsVC") as! SiSPersonDetailsVC
        VC.person = person
        VC.delegate = self
        self.navigationController!.pushViewController(VC, animated: true)
    }
    
    func addPersonToItemsArray(person: SiSPersonModel) {
        self.items.append(person)
        self.stepperValue.text = String(self.items.count)
        self.collectionViewPersons.reloadData()
    }
    
    func addTargetPlace(country: String, city: String) {
        self.targetPlaceTF.text = String("\(city), \(country)")
    }
    
}
