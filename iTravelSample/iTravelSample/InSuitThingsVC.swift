//
//  InSuitThingsVC.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 21.09.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import CoreData

class InSuitThingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataView: UIView!
    
    var inSuitThings = [Things]()
    
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
        
        inSuitThings.removeAll()
        
        updateUI()
        
        if currentTrip != nil {
            
            if inSuit != nil {
                
                inSuitThings = inSuit
                updateUI()
                
            } else {
                
                
            }
            
        } else if things == nil && choosed == nil {
            
            noDataView.alpha = 1
        }
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return inSuitThings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "Cell"
        var cell: ThingsCellGeneric! = tableView.dequeueReusableCell(withIdentifier: identifier) as? ThingsCellGeneric
        if cell == nil {
            tableView.register(UINib(nibName: "ThingsCellGeneric", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ThingsCellGeneric
        }
        
        cell.configureCell(inSuitThings[indexPath.row].title!, tag: indexPath.row, acceptSymbol: false, delSymbol: true)
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

extension InSuitThingsVC: ThingsCellGenericDelegate {
    
    func thingCell(didPressItemNumber: Int, isAccept: Bool) {
        
        let th = inSuitThings[didPressItemNumber]
        let thing = th.title!
        let item = Things.getThingsByTitle(title: thing, context: context)
        inSuitThingsArray.removeFromThings(item!)
        inSuitThings.remove(at: didPressItemNumber)
        
        if !isAccept {
            print("Попытка вернуть в \"Подготовили\" \(thing)")

            choosedThingsArray.addToThings(item!)
        }
        
        do {
            try context.save()
            
        } catch {
            fatalError()
        }
        
        tableView.reloadData()
    }
}

