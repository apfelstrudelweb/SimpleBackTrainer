//
//  Language+CoreDataProperties.swift
//  Visual Back Trainer
//
//  Created by Ulrich Vormbrock on 17.09.18.
//  Copyright © 2018 Rookie. All rights reserved.
//
//

import Foundation
import CoreData


extension Language {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Language> {
        return NSFetchRequest<Language>(entityName: "Language")
    }

    @NSManaged public var de: String?
    @NSManaged public var en: String?
    @NSManaged public var es: String?
    @NSManaged public var instructions: Instruction?
    @NSManaged public var remarks: Remark?
    @NSManaged public var title: Title?

}
