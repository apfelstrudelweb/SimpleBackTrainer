//
//  Workout+CoreDataProperties.swift
//  Simple Back Trainer
//
//  Created by Ulrich Vormbrock on 14.06.18.
//  Copyright © 2018 Rookie. All rights reserved.
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
    @NSManaged public var icon: NSData?
    @NSManaged public var videoUrl: String?
    @NSManaged public var musclegroupId: Musclegroup?
    @NSManaged public var traininsgplanId: Plan?

}
