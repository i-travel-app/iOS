//
//  User+CoreDataProperties.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 14.07.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var age: Int16
    @NSManaged public var idUser: Int16
    @NSManaged public var image: NSData?
    @NSManaged public var isMan: Bool
    @NSManaged public var login: String?
    @NSManaged public var name: String?
    @NSManaged public var isCurrent: Bool
    @NSManaged public var trips: NSSet?

}

// MARK: Generated accessors for trips
extension User {

    @objc(addTripsObject:)
    @NSManaged public func addToTrips(_ value: Trip)

    @objc(removeTripsObject:)
    @NSManaged public func removeFromTrips(_ value: Trip)

    @objc(addTrips:)
    @NSManaged public func addToTrips(_ values: NSSet)

    @objc(removeTrips:)
    @NSManaged public func removeFromTrips(_ values: NSSet)

}
