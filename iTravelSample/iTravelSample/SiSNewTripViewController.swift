//
//  SiSNewTripViewController.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 11.05.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import CoreData

class SiSNewTripViewController: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, TargetPlaceDelegate, PickerVCDelegate, ParticipantsTVCDelegate {
    
    let reuseCollectionViewIdentifier = "participant"
    
    // MARK: - Properties - 
    var participants = [Participant]()
    var context: NSManagedObjectContext!
    var country: String?
    var city: String?
    var latitude: String?
    var longitude: String?
    var targetPlaceID: Int?
    var tripPurposeValue = "Деловая"
    var transportKindValue = "Самолет"
    var trip: Trip!
    var weatherArray = [Weather]()
    
    // MARK: - Outlets -
    @IBOutlet weak var stepperValue: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var collectionViewPersons: UICollectionView!
    @IBOutlet weak var targetPlaceTF: UITextFieldX!
    @IBOutlet weak var startTripDate: UITextFieldX!
    @IBOutlet weak var endTripDate: UITextFieldX!
    @IBOutlet var purpose: UISegmentedControl!
    @IBOutlet var kindOfTransport: UISegmentedControl!
    @IBOutlet weak var saveBtnTopConstr: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Создание поездки"
        // прячем кнопку Главный экран и назначаем свою
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "<Назад", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SiSNewTripViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton

    }
    
    override func viewWillAppear(_ animated: Bool) {
        // отключаю возможность добавления учатников
        collectionViewPersons.isHidden = true
        stepper.isHidden = true
        stepperValue.isHidden = true
        
        super.viewWillAppear(animated)
        collectionViewPersons.reloadData()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if collectionViewPersons.isHidden {
            saveBtnTopConstr.constant = max((saveBtnTopConstr.constant - collectionViewPersons.frame.height - stepper.frame.height), (UIScreen.main.bounds.height - 25 - 80 - 64))
            
        }
    }
    
    @objc func back(sender: UIBarButtonItem) {
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
            self.participants.removeLast()
            self.stepperValue.text = String(participants.count)
            self.collectionViewPersons.reloadData()
        }
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
        return self.participants.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCollectionViewIdentifier, for: indexPath as IndexPath) as! SiSCollectionViewCell
        cell.configure(participant: participants[indexPath.row])
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol - 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        openParticipantChangesVC(indexPath: indexPath)
        
    }
    
    @IBAction func dismiss(_ sender: Any) {
        // Проверка на пустые поля
        if (targetPlaceTF.text?.isEmpty)! || (startTripDate.text?.isEmpty)! || (endTripDate.text?.isEmpty)! {
            // Вывод алерта, если поля пустые
            warningAlert(title: "Отсутствуют данные", message: "Для более точного списка необходимых вещей, заполните все предоставленные поля!")
        } else {
            // Сохранение поездки в БД
            if context == nil {
                context = CoreDataStack.instance.persistentContainer.viewContext
            }
            
            let newID = Trip.getTripID(context: context)
            
            trip = Trip(context: context)
            let recommended = ThingsArray(context: context)
            recommended.title = "recommended"

            let choosed = ThingsArray(context: context)
            choosed.title = "choosed"

            let inSuit = ThingsArray(context: context)
            inSuit.title = "inSuit"

            if let value = newID {
                trip.idTrip = Int16(value)
            }
            
            if let targetPlace = TargetPlace.getTargetPlaceBy(id: targetPlaceID!, context: context) {
                trip.targetPlace = targetPlace
            }
            
            // добавление погоды в свойство поездки
            if !self.weatherArray.isEmpty {
                self.trip.weather = NSSet(array: weatherArray)
            }
            
            if let startDate = startTripDate.text {
                trip.startDate = startDate.toDate() as NSDate
            }
            
            if let endDate = endTripDate.text {
                trip.endDate = endDate.toDate() as NSDate
            }
            
            trip.purpose = tripPurposeValue
            trip.kindOfTransport = transportKindValue
            
            if !participants.isEmpty {
                trip.participants = Set(participants) as NSSet
            }
            
            trip.dateCreation = Date() as NSDate
            
            if let current = User.getCurrentUser(context: context) {
                trip.user = current
                let all = User.getAllUsers()
                print("current user name \(String(describing: trip.user))")
                print("there are \(all) users in core data")
            }
            
            trip.addToThingsArrays(recommended)
            trip.addToThingsArrays(choosed)
            trip.addToThingsArrays(inSuit)
            
            do {
                try context.save()
            } catch {
                fatalError()
            }
        }
        
        back()
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
    
    // MARK: - ParticipantsTVCDelegate -
    func checkedParticipants(context: NSManagedObjectContext, array: [Participant]) {
        self.context = context
        participants.removeAll()
        participants = array
        stepperValue.text = String(participants.count)
        stepper.value = Double(participants.count)
        collectionViewPersons.reloadData()
        //print("There are in CV \(participants.count) participants")
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
        VC.temp = participants
        VC.delegate = self
        self.navigationController!.pushViewController(VC, animated: true)
    }
    
    func addTargetPlace(country: String, city: String, id: Int, latitude: String, longitude: String) {
        targetPlaceID = id
        self.country = country
        self.city = city
        self.latitude = latitude
        self.longitude = longitude
        APIStack.instance.getCityData(latitude: latitude, longitude: longitude) { (weather) in
            self.weatherArray = weather
        }
        self.targetPlaceTF.text = String("\(city), \(country)")
    }
    
    // MARK: - Actions -
    @IBAction func tripPurposeChanges(_ sender: UISegmentedControl) {
        tripPurposeValue = sender.titleForSegment(at: sender.selectedSegmentIndex)!
    }
    
    @IBAction func transportKindChanges(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: transportKindValue = "Самолет"
        case 1: transportKindValue = "Паровоз"
        case 2: transportKindValue = "Автобус"
        case 3: transportKindValue = "Корабль"
        case 4: transportKindValue = "Авто"
        case 5: transportKindValue = "Туризм"
        default: break
        }
    }
    
    func back() {
        _ = self.navigationController?.popViewController(animated: true)
        //self.tabBarController?.selectedIndex = 1
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbarVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        tabbarVC.selectedIndex = 1
        self.present(tabbarVC, animated: false, completion: nil)
        
    }
    
    func openParticipantChangesVC(indexPath: IndexPath) {
        var participant: Participant!
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ParticipantDetailsVC") as! ParticipantDetailsVC
        participant = participants[indexPath.row]
        VC.isNewParticipant = false
        VC.participant = participant
        self.navigationController!.pushViewController(VC, animated: true)
    }
}
