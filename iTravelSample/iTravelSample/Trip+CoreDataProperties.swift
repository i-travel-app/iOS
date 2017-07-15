//
//  Trip+CoreDataProperties.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 15.07.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var dateCreation: NSDate?
    @NSManaged public var endDate: NSDate?
    @NSManaged public var idTrip: Int16
    @NSManaged public var idUser: Int16
    @NSManaged public var startDate: NSDate?
    @NSManaged public var purpose: String?
    @NSManaged public var kindOfTransport: String?
    @NSManaged public var participants: NSSet?
    @NSManaged public var targetPlace: TargetPlace?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for participants
extension Trip {

    @objc(addParticipantsObject:)
    @NSManaged public func addToParticipants(_ value: Participant)

    @objc(removeParticipantsObject:)
    @NSManaged public func removeFromParticipants(_ value: Participant)

    @objc(addParticipants:)
    @NSManaged public func addToParticipants(_ values: NSSet)

    @objc(removeParticipants:)
    @NSManaged public func removeFromParticipants(_ values: NSSet)

}
