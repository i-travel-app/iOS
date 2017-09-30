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
    
    static func getTripID(context: NSManagedObjectContext) -> Int? {
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
        fetchRequest.predicate = NSPredicate(format: "user.isCurrent = %@", NSNumber(value: true))
        
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
    
    static func getCurrentTrips(context: NSManagedObjectContext) -> [Trip] {
        
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        
        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "idTrip", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Add Predicate
        //fetchRequest.predicate = NSPredicate(format: "user.isCurrent = %@", NSNumber(value: true))
        fetchRequest.predicate = NSPredicate(format: "user.isCurrent = %@ AND endDate >= %@", NSNumber(value: true), NSDate())
        
        do {
            let trips = try context.fetch(fetchRequest)
            for trip in trips {
                print(trip.targetPlace?.country ?? "no name")
                print((trip.user?.isCurrent)! ? "Current" : "No current")
                //print(trip.startDate?.toString())
            }
            return trips
            
        } catch {
            fatalError("Cannot get trip info")
        }
    }
}

