//
//  Workout+CoreDataProperties.swift
//  Visual Back Trainer
//
//  Created by Ulrich Vormbrock on 18.09.18.
//  Copyright © 2018 Rookie. All rights reserved.
//
//

import Foundation
import CoreData


extension Workout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workout> {
        return NSFetchRequest<Workout>(entityName: "Workout")
    }

    @NSManaged public var alias: String?
    @NSManaged public var droppedPosition: Int16
    @NSManaged public var icon: NSData?
    @NSManaged public var id: Int16
    @NSManaged public var imgName: String?
    @NSManaged public var intensity: Int16
    @NSManaged public var isBall: Bool
    @NSManaged public var isDumbbell: Bool
    @NSManaged public var isLive: Bool
    @NSManaged public var isMachine: Bool
    @NSManaged public var isMat: Bool
    @NSManaged public var isPremium: Bool
    @NSManaged public var isTheraband: Bool
    @NSManaged public var videoUrl: String?
    @NSManaged public var instructions: Instruction?
    @NSManaged public var membership: NSSet?
    @NSManaged public var remarks: NSSet?
    @NSManaged public var title: Title?
    @NSManaged public var traininsgplanId: Trainingsplan?

}

// MARK: Generated accessors for membership
extension Workout {

    @objc(addMembershipObject:)
    @NSManaged public func addToMembership(_ value: GroupWorkoutMembership)

    @objc(removeMembershipObject:)
    @NSManaged public func removeFromMembership(_ value: GroupWorkoutMembership)

    @objc(addMembership:)
    @NSManaged public func addToMembership(_ values: NSSet)

    @objc(removeMembership:)
    @NSManaged public func removeFromMembership(_ values: NSSet)

}

// MARK: Generated accessors for remarks
extension Workout {

    @objc(addRemarksObject:)
    @NSManaged public func addToRemarks(_ value: Remark)

    @objc(removeRemarksObject:)
    @NSManaged public func removeFromRemarks(_ value: Remark)

    @objc(addRemarks:)
    @NSManaged public func addToRemarks(_ values: NSSet)

    @objc(removeRemarks:)
    @NSManaged public func removeFromRemarks(_ values: NSSet)

}
