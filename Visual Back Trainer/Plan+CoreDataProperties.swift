//
//  Plan+CoreDataProperties.swift
//  Trainingsplan
//
//  Created by Ulrich Vormbrock on 15.04.18.
//  Copyright © 2018 Ulrich Vormbrock. All rights reserved.
//
//

import Foundation
import CoreData


extension Plan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plan> {
        return NSFetchRequest<Plan>(entityName: "Plan")
    }

    @NSManaged public var id: Int16
    @NSManaged public var workouts: NSSet?

}

// MARK: Generated accessors for workouts
extension Plan {

    @objc(addWorkoutsObject:)
    @NSManaged public func addToWorkouts(_ value: Workout)

    @objc(removeWorkoutsObject:)
    @NSManaged public func removeFromWorkouts(_ value: Workout)

    @objc(addWorkouts:)
    @NSManaged public func addToWorkouts(_ values: NSSet)

    @objc(removeWorkouts:)
    @NSManaged public func removeFromWorkouts(_ values: NSSet)

}
