//
//  ThingsArray+CoreDataProperties.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 30.09.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//
//

import Foundation
import CoreData


extension ThingsArray {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ThingsArray> {
        return NSFetchRequest<ThingsArray>(entityName: "ThingsArray")
    }

    @NSManaged public var title: String?
    @NSManaged public var things: NSSet?
    @NSManaged public var trip: Trip?

}

// MARK: Generated accessors for things
extension ThingsArray {

    @objc(addThingsObject:)
    @NSManaged public func addToThings(_ value: Things)

    @objc(removeThingsObject:)
    @NSManaged public func removeFromThings(_ value: Things)

    @objc(addThings:)
    @NSManaged public func addToThings(_ values: NSSet)

    @objc(removeThings:)
    @NSManaged public func removeFromThings(_ values: NSSet)

}
