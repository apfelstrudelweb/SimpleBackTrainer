//
//  Musclegroup+CoreDataProperties.swift
//  Visual Back Trainer
//
//  Created by Ulrich Vormbrock on 20.07.18.
//  Copyright © 2018 Rookie. All rights reserved.
//
//

import Foundation
import CoreData


extension Musclegroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Musclegroup> {
        return NSFetchRequest<Musclegroup>(entityName: "Musclegroup")
    }

    @NSManaged public var alias: String?
    @NSManaged public var bezierPath: NSData?
    @NSManaged public var color: String?
    @NSManaged public var isFront: Bool
    @NSManaged public var id: Int16
    @NSManaged public var membership: NSSet?

}

// MARK: Generated accessors for membership
extension Musclegroup {

    @objc(addMembershipObject:)
    @NSManaged public func addToMembership(_ value: GroupWorkoutMembership)

    @objc(removeMembershipObject:)
    @NSManaged public func removeFromMembership(_ value: GroupWorkoutMembership)

    @objc(addMembership:)
    @NSManaged public func addToMembership(_ values: NSSet)

    @objc(removeMembership:)
    @NSManaged public func removeFromMembership(_ values: NSSet)

}
