//
//  CoreDataStack.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 10.06.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    // Singleton
    static let instance = CoreDataStack()
    private init() {}
    
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "Trips", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Trips")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension CoreDataStack {
    
    // MARK: - CSV Parser Methods
    func parseCSV (contentsOfURL: NSURL, encoding: String.Encoding) -> [(id:Int, city:String, regionR: String?, regionO: String?, country: String)]? {
        
        // Load the CSV file and parse it
        let delimiter = "\n"
        var items:[(id:Int, city:String, regionR: String?, regionO: String?, country: String)]?
        
        do {
            let content = try String(contentsOf: contentsOfURL as URL, encoding: encoding)
            items = []
            let lines:[String] = content.components(separatedBy: delimiter)
            let chars: [Character] = ["\"", "\\"]
            for line in lines {
                var values:[String] = line.components(separatedBy: ",")
                for (index, val) in values.enumerated() {
                    var str = val.stringByRemovingAll(characters: chars)
                    str = val.characters.first == " " ? str.substring(from: str.index(str.startIndex, offsetBy: 1)) : str
                    values[index] = str.capitalized
                    //print(str)
                    //print(values[index])
                }
                
                switch values.count {
                case 3: items?.append((id: Int(values[0])!, city: values[1], regionR: nil, regionO: nil, country: values[2]))
                //print(values[2])
                case 4: items?.append((id: Int(values[0])!, city: values[1], regionR: nil, regionO: values[2], country: values[3]))
                //print(values[3])
                case 5: items?.append((id: Int(values[0])!, city: values[1], regionR: values[2], regionO: values[3], country: values[4]))
                //print(values[4])
                default: break
                }
                
                //print(values.count)
            }
            
            
            
        } catch {
            print(error)
        }
        
        return items
    }
    
    func preloadData() {
        let startTime = Date()
        if let contentsOfURL = Bundle.main.url(forResource: "test", withExtension: "csv"){
            DispatchQueue.global(qos: .background).async {
                if let items = self.parseCSV(contentsOfURL: contentsOfURL as NSURL, encoding: String.Encoding.utf8) {
                    DispatchQueue.main.async() {
                        // Preload the menu items
                        print("Targets were preloaded and it's count = \(items.count)")
                        // Show preload time
                        print("It takes time: \(Date().timeIntervalSince(startTime))")
                        self.savePreloadedData(items: items)
                    }
                }
            }
        }
    }
    
    func savePreloadedData(items: [(id:Int, city:String, regionR: String?, regionO: String?, country: String)]) {
        //let context = self.persistentContainer.viewContext
        //let entity = NSEntityDescription.entity(forEntityName: "TargetPlace", in: context)
        let managedObjectContext = CoreDataStack.instance.persistentContainer.viewContext
        managedObjectContext.perform({
            do {
            for value in items {
                let target = TargetPlace(context: managedObjectContext)
                target.idTargetPlace = Int16(value.id)
                target.city = value.city
                target.country = value.country
                
                if let regionR = value.regionR {
                    target.regionR = regionR
                }
                
                if let regionO = value.regionO {
                    target.regionO = regionO
                }
            }
            try managedObjectContext.save()
        }
        catch let error as NSError {
            print("Error in parsing JSON data: \(error.localizedDescription)")
            }
        })
        
        // пытаюсь проверить наполнение кордаты
        TargetPlace().getAllTargetsFromDB()
    }
    
    // MARK - Participants methods - 
    func getAllParticipantsFromDB() -> Array<Participant> {
        var array = [Participant]()
        let context = self.persistentContainer.viewContext
        let  fetchRequest: NSFetchRequest<Participant> = Participant.fetchRequest()
        
        do {
            array = try context.fetch(fetchRequest)
            if array.isEmpty {
                //print("данных нет!")
            } else {
                //print("в кордате аж \(array.count) записей!!!")
            }
        } catch let error as NSError {
            print(error.userInfo)
        }
        
        return array
    }
    
}
