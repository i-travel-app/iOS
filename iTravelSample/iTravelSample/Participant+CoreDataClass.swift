//
//  Participant+CoreDataClass.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 23.06.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import CoreData

@objc(Participant)
public class Participant: NSManagedObject {
    
    func getParticipantID() {
        let context = self.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Participant> = Participant.fetchRequest()
        //fetchRequest.predicate
        
        do {
            let array = try context.fetch(fetchRequest)
            if array.isEmpty {
                print("данных нет!")
            } else {
                print("в кордате аж \(array.count) записей!!!")
            }
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
    
//    func saveParticipant(items: [(id:Int, city:String, regionR: String?, regionO: String?, country: String)]) {
//        let context = self.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "TargetPlace", in: context)
//        
//        for value in items {
//            let target = NSManagedObject(entity: entity!, insertInto: context) as! TargetPlace
//            target.idTargetPlace = Int16(value.id)
//            target.city = value.city
//            target.country = value.country
//            
//            if let regionR = value.regionR {
//                target.regionR = regionR
//            }
//            
//            if let regionO = value.regionO {
//                target.regionO = regionO
//            }
//            
//        }
//        
//        do {
//            try context.save()
//            print("Saved! Good Job!")
//        } catch {
//            print(error.localizedDescription)
//        }
//        
//        // пытаюсь проверить наполнение кордаты
//        getAllTargetsFromDB()
//    }
}
