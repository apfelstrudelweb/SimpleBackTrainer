//
//  Musclegroup+CoreDataProperties.swift
//  Trainingsplan
//
//  Created by Ulrich Vormbrock on 15.04.18.
//  Copyright © 2018 Ulrich Vormbrock. All rights reserved.
//
//

import Foundation
import CoreData


extension Musclegroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Musclegroup> {
        return NSFetchRequest<Musclegroup>(entityName: "Musclegroup")
    }

    @NSManaged public var color: String?
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var workouts: NSSet?

}

// MARK: Generated accessors for workouts
extension Musclegroup {

    @objc(addWorkoutsObject:)
    @NSManaged public func addToWorkouts(_ value: Workout)

    @objc(removeWorkoutsObject:)
    @NSManaged public func removeFromWorkouts(_ value: Workout)

    @objc(addWorkouts:)
    @NSManaged public func addToWorkouts(_ values: NSSet)

    @objc(removeWorkouts:)
    @NSManaged public func removeFromWorkouts(_ values: NSSet)

}