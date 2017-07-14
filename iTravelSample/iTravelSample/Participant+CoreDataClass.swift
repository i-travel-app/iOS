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
        let sortDescriptor = NSSortDescriptor(key: "idUser", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                let participant = results.last!
                print("\n\n\n\n\nparticipant is \(String(describing: participant.name)) - \(participant.idUser)")
                return Int(participant.idUser) + 1
            } else {
                print("There are no Participants")
                return 1
            }
        } catch {
            fatalError("Cannot get participants info")
        }
        
        return nil
    }
    
    internal static func getParticipants(context: NSManagedObjectContext) -> [Participant] {
        let request: NSFetchRequest<Participant> = Participant.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            let results = try context.fetch(request)
            return results
            
        } catch {
            fatalError("Cannot get movie info")
        }
    }
    
}

