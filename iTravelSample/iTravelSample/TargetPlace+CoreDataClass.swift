//
//  TargetPlace+CoreDataClass.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 26.06.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import CoreData


public class TargetPlace: NSManagedObject {
    
    func getAllTargetsFromDB() {
        let context = CoreDataStack.instance.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TargetPlace> = TargetPlace.fetchRequest()
        
        do {
            let array = try context.fetch(fetchRequest)
            if array.isEmpty {
                //print("данных нет!")
            } else {
                //print("в кордате аж \(array.count) записей!!!")
            }
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
    
    func getAllTargetsCountryFromDB(withName: String) -> Array<String> {
        var set: Set<String> = []
        let context = CoreDataStack.instance.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TargetPlace> = TargetPlace.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "country BEGINSWITH[c] %@ OR country CONTAINS[c] %@", withName, String(" " + withName))
        do {
            let array = try context.fetch(fetchRequest)
            if array.isEmpty {
                //print("данных нет!")
            } else {
                for target in array {
                    set.insert(target.country!)
                    //print(set)
                }
                //print("по предикату и после переноса в сет \(set.count) записей!!!")
            }
        } catch let error as NSError {
            print(error.userInfo)
        }
        
        let arr = Array(set)
        return arr.sorted()
    }
    
    func getAllTargetsCitiesFromDB(withName: String, andCountry: String?) -> Array<String> {
        var set: Set<String> = []
        let context = CoreDataStack.instance.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TargetPlace> = TargetPlace.fetchRequest()
        if (andCountry?.characters.count)! > 1 {
            fetchRequest.predicate = NSPredicate(format: "country BEGINSWITH[c] %@ AND city BEGINSWITH[c] %@", andCountry!, withName)
        } else {
            fetchRequest.predicate = NSPredicate(format: "city BEGINSWITH[c] %@", withName)
        }
        
        do {
            let array = try context.fetch(fetchRequest)
            if array.isEmpty {
                //print("данных нет!")
            } else {
                for target in array {
                    set.insert(String("\(target.city!), \(target.country!), \(target.idTargetPlace)"))
                    //print(set)
                }
                //print("по предикату и после переноса в сет \(set.count) записей!!!")
            }
        } catch let error as NSError {
            print(error.userInfo)
        }
        
        let arr = Array(set)
        return arr.sorted()
    }
    
    internal static func getTargetPlaceBy(id: Int, context: NSManagedObjectContext) -> TargetPlace? {
        
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<TargetPlace> = TargetPlace.fetchRequest()
        
        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "idTargetPlace", ascending: true)
        fetchRequest.predicate = NSPredicate(format: "idTargetPlace = %d", id)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let places = try context.fetch(fetchRequest)
            for place in places {
                print(place.country ?? "no name")
            }
            return places.first!
            
        } catch {
            fatalError("Cannot get trip info")
        }
    }

}
