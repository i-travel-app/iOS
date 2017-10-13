//
//  Weather+CoreDataProperties.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 02.10.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//
//

import Foundation
import CoreData


extension Weather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weather> {
        return NSFetchRequest<Weather>(entityName: "Weather")
    }

    @NSManaged public var day: Double
    @NSManaged public var title: String?
    @NSManaged public var rain: String?
    @NSManaged public var wind: String?
    @NSManaged public var cloud: String?
    @NSManaged public var temperature: Double
    @NSManaged public var trip: Trip?

}
