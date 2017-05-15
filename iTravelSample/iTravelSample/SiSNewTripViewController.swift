//
//  SiSNewTripViewController.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 11.05.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class SiSNewTripViewController: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let countriesArray = ["Боливия", "ЮАР", "Египет", "Турция", "Кипр", "Италия"]
    let townsArray = ["Арош", "Ренато", "Лисаур", "Уиннтито", "Левефазис", "Чипува"]
    let pickerDataArray = [countriesDict, townsDict]
    
    let reuseCollectionViewIdentifier = "person"
    var items = ["Степан","Лариса Ивановна","Крошка Сын","сосед Жора","друг Жоры"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Создание поездки"

    }
    
    // MARK: - Text Field -
    
    // MARK: - UICollectionViewDataSource protocol -
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
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
    
    
}
