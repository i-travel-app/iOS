//
//  RecommendedThingsVC.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 14.09.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import CoreData

class RecommendedThingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView? {
        didSet {
            if things == nil && choosed == nil && inSuit == nil {
                tableView?.alpha = 0
            }
        }
    }
    @IBOutlet weak var noDataView: UIView? {
        didSet {
            if things == nil && choosed == nil && inSuit == nil {
                noDataView?.alpha = 1
            }
        }
    }
    
    var viewForActivityIndicator: UIView!
    
    var recommnededThings = [Things]() {
        didSet {
            if recommnededThings.count > 0 {
                tableView?.alpha = 1
                noDataView?.alpha = 0
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return CoreDataStack.instance.persistentContainer.viewContext
    }
    
    var thing: Things!
    var currentTrip: Trip!
    
    // get thingsArrays from Trip
    var recommendedThingsArray: ThingsArray? {
        didSet {
            recommendedThingsArray = ThingsArray.getThingsArrayFor(trip: currentTrip, thingsArrayTitle: "recommended", context: context)
        }
    }
    var choosedThingsArray: ThingsArray? {
        didSet {
            choosedThingsArray = ThingsArray.getThingsArrayFor(trip: currentTrip, thingsArrayTitle: "choosed", context: context)
        }
    }
    
    var inSuitThingsArray: ThingsArray? {
        didSet {
            inSuitThingsArray = ThingsArray.getThingsArrayFor(trip: currentTrip, thingsArrayTitle: "inSuit", context: context)
        }
    }
    
    // get things from their arrays
    var things: [Things]? {
        didSet {
            if let array = recommendedThingsArray {
                things = Things.getThingsFor(trip: currentTrip, thingsArray: array, context: context)
            }
        }
    }
    var choosed: [Things]? {
        didSet {
            if let array = choosedThingsArray {
               choosed = Things.getThingsFor(trip: currentTrip, thingsArray: array, context: context)
            }
        }
    }
    var inSuit: [Things]? {
        didSet {
            if let array = inSuitThingsArray {
                inSuit = Things.getThingsFor(trip: currentTrip, thingsArray: array, context: context)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        recommnededThings.removeAll()
        
        if currentTrip != nil {
            
            updateUI()
            
            // try to get all things for this trip from DB
            if things != nil {
                
                //for arr in things! {
                    //print((arr ).title)
                //}
                
                recommnededThings = things!
                updateUI()
                
            } else if things == nil && choosed == nil && inSuit == nil {
                
                self.askServerToGetThings()
            }
            
        } else if choosed == nil && inSuit == nil && currentTrip == nil {
            tableView?.alpha = 0
            noDataView?.alpha = 1
        }
    }
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recommnededThings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "Cell"
        var cell: ThingsCellGeneric! = tableView.dequeueReusableCell(withIdentifier: identifier) as? ThingsCellGeneric
        if cell == nil {
            tableView.register(UINib(nibName: "ThingsCellGeneric", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ThingsCellGeneric
        }
        
        cell.configureCell(recommnededThings[indexPath.row].title!, tag: indexPath.row, acceptSymbol: true, delSymbol: false)
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - Private methods -
    func askServerToGetThings() {
        var weather = 0
        if currentTrip.weather?.count != 0 {
            var sumTemp = 0.0
            for temp in (currentTrip?.weather)! {
                let weather = temp as! Weather
                sumTemp += weather.temperature
            }
            
            let averageTemp = Int(sumTemp)/(currentTrip.weather?.count)!
            if averageTemp < 5 {
                weather = 1
            } else {
                weather = averageTemp > 15 ? 2 : 2 // пока ставлю либо зима, либо лето, если добавим демисезон, то это тернар нужно будет преобразовать!
            }
        }
        
        let userGender = (currentTrip.user?.isMan)! ? 1 : 2
        let tripKindValue = currentTrip.purpose == "Деловая" ? 1 : 2
        
        APIStack.instance.getThingsByPOST(weather: weather, sex: userGender, tripKind: tripKindValue, callback: { (values) in
            if !values.isEmpty {
                for value in values {
                    // check if thing is in DB, if no - add it
                    let thingDB = Things.getThingsByTitle(title: value, context: self.context)
                    if  thingDB == nil {
                        let new = Things(context: self.context)
                        new.title = value
                        
                        do {
                            try self.context.save()
                        } catch {
                            fatalError()
                        }
                    }
                }
                
                for val in values {
                    
                    if let thingDB = Things.getThingsByTitle(title: val, context: self.context) {
                        self.recommendedThingsArray!.addToThings(thingDB)
                        self.recommnededThings.append(thingDB)
                        
                        do {
                            try self.context.save()
                        } catch {
                            fatalError()
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.updateUI()
                    }
                    
                }
            }
        })
    }
    
    func showActivityIndicator() {
        
        viewForActivityIndicator = UIView()
        let activityIndicatorView = UIActivityIndicatorView()
        let loadingTextLabel = UILabel()
        
        viewForActivityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        viewForActivityIndicator.backgroundColor = UIColor.white
        view.addSubview(viewForActivityIndicator)
        
        activityIndicatorView.center = CGPoint(x: self.view.bounds.width / 2.0, y: (self.view.bounds.height / 2.0) - 49)
        
        loadingTextLabel.textColor = Constants.blueColor
        loadingTextLabel.text = "\nИдет загрузка данных с сервера...\nЭто может занять какое-то время..."
        loadingTextLabel.textAlignment = .center
        loadingTextLabel.numberOfLines = 0
        loadingTextLabel.font = UIFont(name: "Helvetica Neue", size: 14)
        loadingTextLabel.sizeToFit()
        loadingTextLabel.center = CGPoint(x: activityIndicatorView.center.x, y: activityIndicatorView.center.y - 79)
        viewForActivityIndicator.addSubview(loadingTextLabel)
        
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.activityIndicatorViewStyle = .whiteLarge
        activityIndicatorView.color = Constants.blueColor
        viewForActivityIndicator.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }
    
    func updateUI() {
        if viewForActivityIndicator != nil {
            viewForActivityIndicator.isHidden = true
        }
        
        recommendedThingsArray = { recommendedThingsArray }()
        choosedThingsArray = { choosedThingsArray }()
        inSuitThingsArray = { inSuitThingsArray }()
        
        things = { things }()
        choosed = { choosed }()
        inSuit = { inSuit }()
        
        tableView?.reloadData()
    }
    
}

extension RecommendedThingsVC: ThingsCellGenericDelegate {
    
    func thingCell(didPressItemNumber: Int, isAccept: Bool) {
        
        let th = recommnededThings[didPressItemNumber]
        let thing = th.title!
        if isAccept {
            print("Попытка переместить в \"Подготовили\" \(thing)")
            
            if let item = Things.getThingsByTitle(title: thing, context: context) {
                choosedThingsArray!.addToThings(item)
                recommendedThingsArray!.removeFromThings(item)
                recommnededThings.remove(at: didPressItemNumber)
                
                do {
                    try context.save()
                    
                } catch {
                    fatalError()
                }
                
                tableView?.reloadData()
            }
        }
    }
}
