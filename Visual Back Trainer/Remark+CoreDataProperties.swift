//
//  Remark+CoreDataProperties.swift
//  Visual Back Trainer
//
//  Created by Ulrich Vormbrock on 18.09.18.
//  Copyright © 2018 Rookie. All rights reserved.
//
//

import Foundation
import CoreData


extension Remark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Remark> {
        return NSFetchRequest<Remark>(entityName: "Remark")
    }

    @NSManaged public var language: Language?
    @NSManaged public var workout: Workout?

}
