//
//  Things+CoreDataClass.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 14.09.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import CoreData


public class Things: NSManagedObject {
    
    static func isThingIsInDB(title: String) -> Bool? {
        let context = CoreDataStack.instance.persistentContainer.viewContext
        let request: NSFetchRequest<Things> = Things.fetchRequest()
        request.predicate = NSPredicate(format: "title = %@", title)
        do {
            let array = try context.fetch(request)
            if array.isEmpty {
                print("\(title) -> Такой вещи нет в базе данных")
                return false
            } else {
                print("\(title) -> Такая вещь уже есть!")
                return true
            }
        } catch let error as NSError {
            print(error.userInfo)
        }
        
        return nil
    }
    
    static func getThingsByTitle(title: String, context: NSManagedObjectContext) -> Things? {
        
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Things> = Things.fetchRequest()
        
        // Add Predicate
        fetchRequest.predicate = NSPredicate(format: "title = %@", title)
        
        do {
            let things = try context.fetch(fetchRequest)

            return things.isEmpty ? nil : things.last!
            
        } catch {
            fatalError("Cannot get trip info")
        }
    }
    
//    static func getThingsForTrip(trip: Trip, state: ThingState, context: NSManagedObjectContext) -> [Things]? {
//        
//        // Create Fetch Request
//        let fetchRequest: NSFetchRequest<Things> = Things.fetchRequest()
//        
//        // Add Predicate
//        fetchRequest.predicate = NSPredicate(format: "trip = %@ AND state = %@", trip, state)
//        
//        do {
//            let things = try context.fetch(fetchRequest)
//            
//            return things.isEmpty ? nil : things
//            
//        } catch {
//            fatalError("Cannot get trip info")
//        }
//    }
    
    static func getThingsFor(trip: Trip, thingsArray: ThingsArray, context: NSManagedObjectContext) -> [Things]? {
        
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Things> = Things.fetchRequest()
        
        // Add Predicate
        fetchRequest.predicate = NSPredicate(format: "ANY array = %@ AND ANY array.trip = %@", thingsArray, trip)
        
        do {
            let things = try context.fetch(fetchRequest)
            
            return things.isEmpty ? nil : things
            
        } catch {
            fatalError("Cannot get trip info")
        }
    }
}
