//
//  Participant+CoreDataClass.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 26.06.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import CoreData

public class Participant: NSManagedObject {
    
    internal func getParticipantID(context: NSManagedObjectContext) -> Int? {
        let request: NSFetchRequest<Participant> = Participant.fetchRequest()
        //let sortDescriptor = NSSortDescriptor(key: "idUser", ascending: true)
        //request.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                let participant = results.last!
                print("\n\n\n\n\nparticipant is \(participant.name) - \(participant.idUser)")
                return Int(participant.idUser) + 1
            } else {
                print("There are no Participants")
                return 1
            }
        }
        catch {
            fatalError("Cannot get movie info")
        }
        
        return nil
    }
    
    internal static func getParticipants(managedObjectContext: NSManagedObjectContext) -> NSFetchedResultsController<Participant> {
        let fetchedResultController: NSFetchedResultsController<Participant>
        
        let request: NSFetchRequest<Participant> = Participant.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultController.performFetch()
            
        } catch {
            
            fatalError("Error in fetching records")
        }
        
        return fetchedResultController
    }
    
}

