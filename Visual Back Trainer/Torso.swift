//
//  Torso.swift
//  sketchChanger
//
//  Created by Ulrich Vormbrock on 01.04.18.
//  Copyright © 2018 Ulrich Vormbrock. All rights reserved.
//

import UIKit
import CoreData

class DragDropItem: NSObject {
    
    var objectID: NSManagedObjectID
    var sourceIndexPath: IndexPath
    
    
    
    init(withObjectID objectID: NSManagedObjectID, sourceIndexPath: IndexPath) {
        self.objectID = objectID
        self.sourceIndexPath = sourceIndexPath
    }
    
}

class Torso: NSObject {
    
    var index: Int
    var color: UIColor
    var muscleName: String
    var tapArea: UIBezierPath

    init(withIndex index: Int, color: UIColor, muscleName: String, tapArea: UIBezierPath) {
        self.index = index
        self.color = color
        self.muscleName = muscleName
        self.tapArea = tapArea
    }

}


class FrontView: NSObject {
    
    var dict: [Torso]
    
    var fetchedResultsController: NSFetchedResultsController<Workout>!
    
    init(dict: [Torso]) {
        self.dict = dict
    }
    
    convenience override init() {
        
        var frontResult: [Musclegroup]!
  
        do {
            let fetchRequest = NSFetchRequest<Musclegroup>(entityName: "Musclegroup")
            fetchRequest.predicate = NSPredicate(format: "isFront=1")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
            frontResult = try CoreDataManager.sharedInstance.managedObjectContext.fetch(fetchRequest)

        } catch let error {
            print ("fetch task failed", error)
        }
        
        var dict : [Torso] = []
        
        for group in frontResult {
            let tapPath = NSKeyedUnarchiver.unarchiveObject(with: group.bezierPath! as Data)  as! UIBezierPath
            dict.append(Torso(withIndex: Int(group.id), color: (group.color?.colorFromString())!, muscleName: NSLocalizedString(group.alias!, comment: ""), tapArea: tapPath))
        }

        self.init(dict: dict)
    }

}

class BackView: NSObject {
    
    var dict: [Torso]
    
    init(dict: [Torso]) {
        self.dict = dict
    }
    
    convenience override init() {
        
        var backResult: [Musclegroup]!
        
        do {
            let fetchRequest = NSFetchRequest<Musclegroup>(entityName: "Musclegroup")
            fetchRequest.predicate = NSPredicate(format: "isFront=0")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
            backResult = try CoreDataManager.sharedInstance.managedObjectContext.fetch(fetchRequest)
            
        } catch let error {
            print ("fetch task failed", error)
        }

 
        var dict : [Torso] = []
        
        for group in backResult {
            let tapPath = NSKeyedUnarchiver.unarchiveObject(with: group.bezierPath! as Data)
            dict.append(Torso(withIndex: Int(group.id), color: (group.color?.colorFromString())!, muscleName: NSLocalizedString(group.alias!, comment: ""), tapArea: tapPath as! UIBezierPath))
        }
        
        self.init(dict: dict)
    }
}
