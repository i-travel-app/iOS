//
//  Participant+CoreDataProperties.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 30.09.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//
//

import Foundation
import CoreData


extension Participant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Participant> {
        return NSFetchRequest<Participant>(entityName: "Participant")
    }

    @NSManaged public var age: Int16
    @NSManaged public var idUser: Int16
    @NSManaged public var image: NSData?
    @NSManaged public var isMan: Bool
    @NSManaged public var name: String?
    @NSManaged public var trips: NSSet?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for trips
extension Participant {

    @objc(addTripsObject:)
    @NSManaged public func addToTrips(_ value: Trip)

    @objc(removeTripsObject:)
    @NSManaged public func removeFromTrips(_ value: Trip)

    @objc(addTrips:)
    @NSManaged public func addToTrips(_ values: NSSet)

    @objc(removeTrips:)
    @NSManaged public func removeFromTrips(_ values: NSSet)

}
