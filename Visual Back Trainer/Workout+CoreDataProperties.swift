//
//  Workout+CoreDataProperties.swift
//  Visual Back Trainer
//
//  Created by Ulrich Vormbrock on 20.07.18.
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
    @NSManaged public var traininsgplanId: Trainingsplan?
    @NSManaged public var membership: NSSet?

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
