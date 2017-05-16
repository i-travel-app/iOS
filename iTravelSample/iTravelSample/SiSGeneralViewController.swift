//
//  SiSGeneralViewController.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 11.05.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class SiSGeneralViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SiSNewTripDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var cellsArray = [SiSTripModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0..<5 {
            let tmp = SiSTripModel.init()
            print(tmp.tripTitle!, tmp.participantsCount!, tmp.targetCountry!, tmp.targetTown!)
            cellsArray.append(tmp)
        }
    
        self.tableView.delegate = self
        self.tableView.dataSource = self        
    }
    
    // MARK: -TableView dataSource-
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        if indexPath.row == cellsArray.count {
            let cell: SiSTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath as IndexPath) as! SiSTableViewCell
            return cell
        } else {
            let cell: SiSTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! SiSTableViewCell
            let trip = self.cellsArray[indexPath.row]
            cell.labelText.text = "\(trip.tripTitle!), участников: \(trip.participantsCount!),\nстрана: \(trip.targetCountry!), город: \(trip.targetTown!)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == self.cellsArray.count {
            DispatchQueue.main.async(execute: {
                //self.stopIndicator()
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SiSNewTripViewController") as! SiSNewTripViewController
                viewController.trip = SiSTripModel()
                viewController.delegate = self
                self.navigationController!.pushViewController(viewController, animated: true)
                return
            })
        }
        
    }
    
    func addTripToCellsArray(trip: SiSTripModel) {
        self.cellsArray.append(trip)
        self.tableView.reloadData()
    }

}
