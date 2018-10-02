//
//  Workout+CoreDataProperties.swift
//  Visual Back Trainer
//
//  Created by Ulrich Vormbrock on 02.10.18.
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
    @NSManaged public var droppedPosition: Int16
    @NSManaged public var icon: NSData?
    @NSManaged public var id: Int16
    @NSManaged public var imgName: String?
    @NSManaged public var intensity: Int16
    @NSManaged public var isBall: Bool
    @NSManaged public var isDumbbell: Bool
    @NSManaged public var isLive: Bool
    @NSManaged public var isMachine: Bool
    @NSManaged public var isMat: Bool
    @NSManaged public var isPremium: Bool
    @NSManaged public var isTheraband: Bool
    @NSManaged public var videoUrl: String?
    @NSManaged public var instructions: NSOrderedSet?
    @NSManaged public var membership: NSSet?
    @NSManaged public var remarks: NSOrderedSet?
    @NSManaged public var titles: NSSet?
    @NSManaged public var traininsgplanId: Trainingsplan?

}

// MARK: Generated accessors for instructions
extension Workout {

    @objc(insertObject:inInstructionsAtIndex:)
    @NSManaged public func insertIntoInstructions(_ value: Instruction, at idx: Int)

    @objc(removeObjectFromInstructionsAtIndex:)
    @NSManaged public func removeFromInstructions(at idx: Int)

    @objc(insertInstructions:atIndexes:)
    @NSManaged public func insertIntoInstructions(_ values: [Instruction], at indexes: NSIndexSet)

    @objc(removeInstructionsAtIndexes:)
    @NSManaged public func removeFromInstructions(at indexes: NSIndexSet)

    @objc(replaceObjectInInstructionsAtIndex:withObject:)
    @NSManaged public func replaceInstructions(at idx: Int, with value: Instruction)

    @objc(replaceInstructionsAtIndexes:withInstructions:)
    @NSManaged public func replaceInstructions(at indexes: NSIndexSet, with values: [Instruction])

    @objc(addInstructionsObject:)
    @NSManaged public func addToInstructions(_ value: Instruction)

    @objc(removeInstructionsObject:)
    @NSManaged public func removeFromInstructions(_ value: Instruction)

    @objc(addInstructions:)
    @NSManaged public func addToInstructions(_ values: NSOrderedSet)

    @objc(removeInstructions:)
    @NSManaged public func removeFromInstructions(_ values: NSOrderedSet)

}

// MARK: Generated accessors for membership
extension Workout {

    @objc(addMembershipObject:)
    @NSManaged public func addToMembership(_ value: GroupWorkoutMembership)

    @objc(removeMembershipObject:)
    @NSManaged public func removeFromMembership(_ value: GroupWorkoutMembership)

    @objc(addMembership:)
    @NSManaged public func addToMembership(_ values: NSSet)

    @objc(removeMembership:)
    @NSManaged public func removeFromMembership(_ values: NSSet)

}

// MARK: Generated accessors for remarks
extension Workout {

    @objc(insertObject:inRemarksAtIndex:)
    @NSManaged public func insertIntoRemarks(_ value: Remark, at idx: Int)

    @objc(removeObjectFromRemarksAtIndex:)
    @NSManaged public func removeFromRemarks(at idx: Int)

    @objc(insertRemarks:atIndexes:)
    @NSManaged public func insertIntoRemarks(_ values: [Remark], at indexes: NSIndexSet)

    @objc(removeRemarksAtIndexes:)
    @NSManaged public func removeFromRemarks(at indexes: NSIndexSet)

    @objc(replaceObjectInRemarksAtIndex:withObject:)
    @NSManaged public func replaceRemarks(at idx: Int, with value: Remark)

    @objc(replaceRemarksAtIndexes:withRemarks:)
    @NSManaged public func replaceRemarks(at indexes: NSIndexSet, with values: [Remark])

    @objc(addRemarksObject:)
    @NSManaged public func addToRemarks(_ value: Remark)

    @objc(removeRemarksObject:)
    @NSManaged public func removeFromRemarks(_ value: Remark)

    @objc(addRemarks:)
    @NSManaged public func addToRemarks(_ values: NSOrderedSet)

    @objc(removeRemarks:)
    @NSManaged public func removeFromRemarks(_ values: NSOrderedSet)

}

// MARK: Generated accessors for titles
extension Workout {

    @objc(addTitlesObject:)
    @NSManaged public func addToTitles(_ value: Title)

    @objc(removeTitlesObject:)
    @NSManaged public func removeFromTitles(_ value: Title)

    @objc(addTitles:)
    @NSManaged public func addToTitles(_ values: NSSet)

    @objc(removeTitles:)
    @NSManaged public func removeFromTitles(_ values: NSSet)

}
