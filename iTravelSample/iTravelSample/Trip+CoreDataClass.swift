//
//  Trip+CoreDataClass.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 26.06.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import CoreData


public class Trip: NSManagedObject {
    
    internal func getTripID(context: NSManagedObjectContext) -> Int? {
        let request: NSFetchRequest<Trip> = Trip.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "idTrip", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                let trip = results.last!
                print("\n\n\n\n\ntrip is \(String(describing: trip.targetPlace?.country)) - \(trip.idTrip)")
                return Int(trip.idTrip) + 1
            } else {
                print("There are no Trips")
                return 1
            }
        } catch {
            fatalError("Cannot get trip info")
        }
        
        return nil
    }
    
    static func getTripsForCurrentUser(context: NSManagedObjectContext) -> [Trip] {
        
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        
        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "idTrip", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Add Predicate
        //let predicate1 = NSPredicate(format: "user.isCurrent = %@", NSNumber(value: true))
        //let str = "a@a.ru"
        //fetchRequest.predicate = NSPredicate(format: "user.login = %@", str)
        
        do {
            let trips = try context.fetch(fetchRequest)
            for trip in trips {
                print(trip.targetPlace?.country ?? "no name")
            }
            return trips
            
        } catch {
            fatalError("Cannot get trip info")
        }
    }
}

