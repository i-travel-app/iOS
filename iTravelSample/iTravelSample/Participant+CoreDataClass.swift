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
    
    internal func saveParticipant(idUser: Int, name: String, context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Participant", in: context)
        let participant = NSManagedObject(entity: entity!, insertInto: context)
        participant.setValue(idUser, forKey: "idUser")
        
        do {
            try context.save()
            print("Saved! Good Job!")
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
}

