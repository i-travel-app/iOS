//
//  SiSGeneralViewController.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 11.05.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import CoreData

// в данном контроллере обрабатывается логика отображения всех поездок пользователя, в массив вытягиваются из кор даты все поездки и отображаются в таблице в виде: Название поездки, кол-во человек, дата, место; если поездок не было, то отображается приглашение создать таковую

class SiSGeneralViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var cellsArray = [Trip]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // здесь реализуется логика загрузки историии всех поездок пользователя и добавление их в массив cellsArray
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTripAction))
        self.navigationItem.setRightBarButtonItems([addButton], animated: true)
        
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - TableView dataSource -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // возвращаем количество ячеек равное количеству поездок, если поездок 0, то показываем 1 ячейку с сообщением, что у пользователя не было еще ни одной поездки
        if cellsArray.isEmpty {
            return 1
        } else {
            return cellsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // здесь реализуем показ списка истории поездок
        let cell: UITableViewCell
        if cellsArray.isEmpty {
            cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath as IndexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .red
            cell.textLabel?.text = "Здесь отображается история Ваших поездок. К сожалению, у Вас не было еще ни одной поездки.\nДобавьте первую, нажав на кнопку ниже."
        } else {
            cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == self.cellsArray.count && !self.cellsArray.isEmpty {
            DispatchQueue.main.async(execute: {
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SiSNewTripViewController") as! SiSNewTripViewController
                //viewController.trip = SiSTripModel()
                self.navigationController!.pushViewController(viewController, animated: true)
                return
            })
        }
        
    }
    
    func addNewTripAction() {
        // открываем контроллер для создания новой поездки
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SiSNewTripViewController") as! SiSNewTripViewController
        self.navigationController!.pushViewController(viewController, animated: true)
    }
    
    func addTripToCellsArray(trip: SiSTripModel) {
        self.tableView.reloadData()
    }

}
