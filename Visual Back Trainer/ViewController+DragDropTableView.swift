//
//  ViewController+DragDropTableView.swift
//  DragDropiOS-Example
//
//  Created by yuhan on 01/08/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import DragDropiOS
import CoreData

// MARK : DropTableViewDelegate
extension ViewController {
    

    func tableView(_ tableView: UITableView, dragInfoForIndexPath indexPath: IndexPath) -> AnyObject {
        //let dragInfo = collectionIDs.last //[indexPath]
        return dragDropItem
    }
    
    func tableView(_ tableView: UITableView, canDropWithDragInfo dataItem: AnyObject, AtIndexPath indexPath: IndexPath) -> Bool {
        _ = dataItem as! DragDropItem
        return true
    }
    
    func tableView(_ tableView: UITableView, dropCompleteWithDragInfo dragInfo:AnyObject, atDragIndexPath dragIndexPath: IndexPath?,withDropInfo dropInfo:AnyObject?, atDropIndexPath dropIndexPath:IndexPath) -> Void {
        let item = dragInfo as! DragDropItem
        droppedWorkout = CoreDataManager.sharedInstance.managedObjectContext.object(with: item.objectID) as! Workout
        droppedWorkout.droppedPosition = Int16(dropIndexPath.row)
    }
    
    
    func tableViewStopDropping(_ tableView: UITableView) {
        self.updateTrainingsplan()
    }
    
}
