//
//  Things+CoreDataProperties.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 30.09.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//
//

import Foundation
import CoreData


extension Things {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Things> {
        return NSFetchRequest<Things>(entityName: "Things")
    }

    @NSManaged public var id: Int16
    @NSManaged public var title: String?
    @NSManaged public var array: NSSet?

}

// MARK: Generated accessors for array
extension Things {

    @objc(addArrayObject:)
    @NSManaged public func addToArray(_ value: ThingsArray)

    @objc(removeArrayObject:)
    @NSManaged public func removeFromArray(_ value: ThingsArray)

    @objc(addArray:)
    @NSManaged public func addToArray(_ values: NSSet)

    @objc(removeArray:)
    @NSManaged public func removeFromArray(_ values: NSSet)

}
