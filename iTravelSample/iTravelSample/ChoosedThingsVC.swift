//
//  ChoosedThingsVC.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 20.09.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import CoreData

class ChoosedThingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataView: UIView!
    
    var choosedThings = [Things]()
    
    var context: NSManagedObjectContext {
        return CoreDataStack.instance.persistentContainer.viewContext
    }
    
    var thing: Things!
    var currentTrip: Trip!
    
    // get thingsArrays from Trip
    var recommendedThingsArray: ThingsArray! {
        didSet {
            recommendedThingsArray = ThingsArray.getThingsArrayFor(trip: currentTrip, thingsArrayTitle: "recommended", context: context)
        }
    }
    var choosedThingsArray: ThingsArray! {
        didSet {
            choosedThingsArray = ThingsArray.getThingsArrayFor(trip: currentTrip, thingsArrayTitle: "choosed", context: context)
        }
    }
    
    var inSuitThingsArray: ThingsArray! {
        didSet {
            inSuitThingsArray = ThingsArray.getThingsArrayFor(trip: currentTrip, thingsArrayTitle: "inSuit", context: context)
        }
    }
    
    // get things from their arrays
    var things: [Things]! {
        didSet {
            things = Things.getThingsFor(trip: currentTrip, thingsArray: recommendedThingsArray, context: context)
        }
    }
    var choosed: [Things]! {
        didSet {
            choosed = Things.getThingsFor(trip: currentTrip, thingsArray: choosedThingsArray, context: context)
        }
    }
    var inSuit: [Things]! {
        didSet {
            inSuit = Things.getThingsFor(trip: currentTrip, thingsArray: inSuitThingsArray, context: context)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        choosedThings.removeAll()
        
        updateUI()
        
        if currentTrip != nil {
            
            if choosed != nil {
                
                choosedThings = choosed
                updateUI()
                
            } else {
                
                
            }
            
        } else if things == nil && inSuit == nil {
            
            noDataView.alpha = 1
        }
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return choosedThings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "Cell"
        var cell: ThingsCellGeneric! = tableView.dequeueReusableCell(withIdentifier: identifier) as? ThingsCellGeneric
        if cell == nil {
            tableView.register(UINib(nibName: "ThingsCellGeneric", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ThingsCellGeneric
        }
        
        cell.configureCell(choosedThings[indexPath.row].title!, tag: indexPath.row, acceptSymbol: true, delSymbol: true)
        cell.delegate = self
        
        return cell
    }
        
    // MARK: - Private methods -
    func updateUI() {
        
        recommendedThingsArray = { recommendedThingsArray }()
        choosedThingsArray = { choosedThingsArray }()
        inSuitThingsArray = { inSuitThingsArray }()
        
        things = { things }()
        choosed = { choosed }()
        inSuit = { inSuit }()
        
        tableView.reloadData()
    }

}

extension ChoosedThingsVC: ThingsCellGenericDelegate {
    
    func thingCell(didPressItemNumber: Int, isAccept: Bool) {
        
        let th = choosedThings[didPressItemNumber]
        let thing = th.title!
        let item = Things.getThingsByTitle(title: thing, context: context)
        choosedThingsArray.removeFromThings(item!)
        choosedThings.remove(at: didPressItemNumber)
        
        if isAccept {
            print("Попытка переместить в \"Уже взяли\" \(thing)")
            
            inSuitThingsArray.addToThings(item!)

        } else {
            print("Попытка вернуть в \"Советуем\" \(thing)")
            
            recommendedThingsArray.addToThings(item!)
        }
        
        do {
            try context.save()
            
        } catch {
            fatalError()
        }
        
        tableView.reloadData()
    }
}
