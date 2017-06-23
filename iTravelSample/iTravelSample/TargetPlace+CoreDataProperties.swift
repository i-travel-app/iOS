//
//  TargetPlace+CoreDataProperties.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 23.06.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import CoreData


extension TargetPlace {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TargetPlace> {
        return NSFetchRequest<TargetPlace>(entityName: "TargetPlace");
    }

    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var idTargetPlace: Int16
    @NSManaged public var regionO: String?
    @NSManaged public var regionR: String?
    @NSManaged public var idTrip: NSSet?

}

// MARK: Generated accessors for idTrip
extension TargetPlace {

    @objc(addIdTripObject:)
    @NSManaged public func addToIdTrip(_ value: Trip)

    @objc(removeIdTripObject:)
    @NSManaged public func removeFromIdTrip(_ value: Trip)

    @objc(addIdTrip:)
    @NSManaged public func addToIdTrip(_ values: NSSet)

    @objc(removeIdTrip:)
    @NSManaged public func removeFromIdTrip(_ values: NSSet)

}
