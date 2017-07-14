//
//  User+CoreDataClass.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 13.07.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    
    internal func isUserUsed(login: String) -> Bool? {
        let context = CoreDataStack().persistentContainer.viewContext
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "login = %@", login)
        do {
            let array = try context.fetch(request)
            if array.isEmpty {
                print("Ввведен новый логин")
                return false
            } else {
                print("Ввведен логин, который уже использовался")
                return true
            }
        } catch let error as NSError {
            print(error.userInfo)
        }
        
        return nil
    }
    
    internal func getUserID(context: NSManagedObjectContext) -> Int? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "idUser", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                let user = results.last!
                print("\n\n\n\n\nuser is \(String(describing: user.name)) - \(user.idUser)")
                return Int(user.idUser) + 1
            } else {
                print("There are no Users")
                return 1
            }
        } catch {
            fatalError("Cannot get user info")
        }
        
        return nil
    }

}
