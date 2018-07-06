//
//  Workout+CoreDataProperties.swift
//  Visual Back Trainer
//
//  Created by Ulrich Vormbrock on 05.07.18.
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
    @NSManaged public var isFavorite: Bool
    @NSManaged public var isLive: Bool
    @NSManaged public var isMachine: Bool
    @NSManaged public var isMat: Bool
    @NSManaged public var isPremium: Bool
    @NSManaged public var isTheraband: Bool
    @NSManaged public var videoUrl: String?
    @NSManaged public var musclegroupId: Musclegroup?
    @NSManaged public var traininsgplanId: Plan?

}
