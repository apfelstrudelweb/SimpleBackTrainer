//
//  GroupWorkoutMembership+CoreDataProperties.swift
//  Visual Back Trainer
//
//  Created by Ulrich Vormbrock on 17.09.18.
//  Copyright © 2018 Rookie. All rights reserved.
//
//

import Foundation
import CoreData


extension GroupWorkoutMembership {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GroupWorkoutMembership> {
        return NSFetchRequest<GroupWorkoutMembership>(entityName: "GroupWorkoutMembership")
    }

    @NSManaged public var group: Musclegroup?
    @NSManaged public var workout: NSSet?

}

// MARK: Generated accessors for workout
extension GroupWorkoutMembership {

    @objc(addWorkoutObject:)
    @NSManaged public func addToWorkout(_ value: Workout)

    @objc(removeWorkoutObject:)
    @NSManaged public func removeFromWorkout(_ value: Workout)

    @objc(addWorkout:)
    @NSManaged public func addToWorkout(_ values: NSSet)

    @objc(removeWorkout:)
    @NSManaged public func removeFromWorkout(_ values: NSSet)

}
