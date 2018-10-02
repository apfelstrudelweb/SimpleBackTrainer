//
//  Remark+CoreDataProperties.swift
//  Visual Back Trainer
//
//  Created by Ulrich Vormbrock on 02.10.18.
//  Copyright © 2018 Rookie. All rights reserved.
//
//

import Foundation
import CoreData


extension Remark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Remark> {
        return NSFetchRequest<Remark>(entityName: "Remark")
    }

    @NSManaged public var language: String?
    @NSManaged public var text: String?
    @NSManaged public var workout: Workout?

}
