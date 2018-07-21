//
//  Trainingsplan+CoreDataProperties.swift
//  Visual Back Trainer
//
//  Created by Ulrich Vormbrock on 21.07.18.
//  Copyright © 2018 Rookie. All rights reserved.
//
//

import Foundation
import CoreData


extension Trainingsplan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trainingsplan> {
        return NSFetchRequest<Trainingsplan>(entityName: "Trainingsplan")
    }

    @NSManaged public var id: Int16
    @NSManaged public var position: Int16
    @NSManaged public var workouts: NSSet?

}

// MARK: Generated accessors for workouts
extension Trainingsplan {

    @objc(addWorkoutsObject:)
    @NSManaged public func addToWorkouts(_ value: Workout)

    @objc(removeWorkoutsObject:)
    @NSManaged public func removeFromWorkouts(_ value: Workout)

    @objc(addWorkouts:)
    @NSManaged public func addToWorkouts(_ values: NSSet)

    @objc(removeWorkouts:)
    @NSManaged public func removeFromWorkouts(_ values: NSSet)

}
