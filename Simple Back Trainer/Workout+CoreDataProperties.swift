//
//  Workout+CoreDataProperties.swift
//  Trainingsplan
//
//  Created by Ulrich Vormbrock on 15.04.18.
//  Copyright © 2018 Ulrich Vormbrock. All rights reserved.
//
//

import Foundation
import CoreData


extension Workout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workout> {
        return NSFetchRequest<Workout>(entityName: "Workout")
    }

    @NSManaged public var descr: String?
    @NSManaged public var id: Int16
    @NSManaged public var imgName: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var isPremium: Bool
    @NSManaged public var musclegroup: String?
    @NSManaged public var name: String?
    @NSManaged public var position: Int16
    @NSManaged public var musclegroupId: Musclegroup?
    @NSManaged public var traininsgplanId: Plan?

}
