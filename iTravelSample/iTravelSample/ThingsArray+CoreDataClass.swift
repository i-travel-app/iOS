//
//  ThingsArray+CoreDataClass.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 27.09.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import CoreData


public class ThingsArray: NSManagedObject {
    
        static func getThingsArrayFor(trip: Trip, thingsArrayTitle: String, context: NSManagedObjectContext) -> ThingsArray? {
    
            // Create Fetch Request
            let fetchRequest: NSFetchRequest<ThingsArray> = ThingsArray.fetchRequest()
    
            // Add Predicate
            fetchRequest.predicate = NSPredicate(format: "trip = %@ AND title = %@", trip, thingsArrayTitle)
    
            do {
                let array = try context.fetch(fetchRequest)
    
                return array.isEmpty ? nil : array.last
    
            } catch {
                fatalError("Cannot get trip info")
            }
        }
    
    static func getAllThings(trip: Trip, thingsArray: ThingsArray, context: NSManagedObjectContext) -> [Things]? {
        
        let fetchRequest: NSFetchRequest<Things> = Things.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ANY array = %@ AND ANY array.trip = %@", thingsArray, trip)
        
        do {
            let array = try context.fetch(fetchRequest)
            
            return array.isEmpty ? nil : array
            
        } catch {
            fatalError("Cannot get trip info")
        }
    }


}
