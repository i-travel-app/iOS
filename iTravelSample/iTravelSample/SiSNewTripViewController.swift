//
//  SiSNewTripViewController.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 11.05.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class SiSNewTripViewController: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let reuseCollectionViewIdentifier = "person"
    var items = ["Степан","Лариса Ивановна","Крошка Сын","сосед Жора","друг Жоры","Степан","Лариса Ивановна","Крошка Сын","сосед Жора","друг Жоры"]
    
    @IBOutlet weak var stepperValue: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var collectionViewPersons: UICollectionView!

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
        modalVC.callback = { message in
            
        }
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
        cell.myLabel.text = self.items[indexPath.item]
        cell.backgroundColor = UIColor.white
        cell.imagePersonOutlet.image = UIImage(named:"person.png")
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol - 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        let title = self.items[indexPath.item]
        print("You selected cell \(title)!")
    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
