 //
//  ViewController+DragDropCollectionView.swift
//  DragDropiOS-Example
//
//  Created by yuhan on 31/07/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import DragDropiOS
import CoreData

 // MARK : DragDropCollectionViewDelegate
extension ViewController{
    func collectionView(_ collectionView: UICollectionView, touchBeginAtIndexPath indexPath: IndexPath) {
        clearCellsDrogStatusOfCollectionView()
    }
    
    func collectionView(_ collectionView: UICollectionView, representationImageAtIndexPath indexPath: IndexPath) -> UIImage? {
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, 0)
            cell.layer.render(in: UIGraphicsGetCurrentContext()!)
            
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return img
        }
        return nil
    }
    
    func collectionView(_ collectionView: UICollectionView, canDragAtIndexPath indexPath: IndexPath) -> Bool {
        
//        let objectID = collectionIDs[indexPath]
//        let workout = context.object(with: objectID!) as! Workout
//
//        let workout = self.fetchedResultsController2.object(at: indexPath)
//        print(workout.isFavorite)
//        return !workout.isFavorite
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, dragInfoForIndexPath indexPath: IndexPath) -> AnyObject {
        //let dragInfo = collectionModels[indexPath.item]
        let objectID = self.fetchedResultsController2.object(at: indexPath).objectID
        dragDropItem = DragDropItem.init(withObjectID: objectID, sourceIndexPath: indexPath)
        return dragDropItem
    }
    
    func collectionView(_ collectionView: UICollectionView, canDropWithDragInfo dataItem: AnyObject, AtIndexPath indexPath: IndexPath) -> Bool {
        _ = dataItem as! DragDropItem
        
        return true
        
//        //let overInfo = collectionModels[indexPath.item]
//        let overInfo = collectionIDs[indexPath]
//
//        debugPrint("move over index: \(indexPath.item)")
//
//        //drag source is mouse over item（self）
//        if overInfo != nil {
//            return false
//        }
//
//        clearCellsDrogStatusOfCollectionView()
//
//        for _ in collectionView.visibleCells{
//
//
//                if overInfo == nil {
//                    let cell = collectionView.cellForItem(at: indexPath) as! DragDropCollectionViewCell
//                    cell.moveOverStatus()
//                    debugPrint("can drop in . index = \(indexPath.item)")
//
//                    return true
//                }else{
//                    debugPrint("can't drop in. index = \(indexPath.item)")
//                }
//
//
//        }
//
//        return false
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, dropOutsideWithDragInfo info: AnyObject) {
        clearCellsDrogStatusOfCollectionView()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, dragCompleteWithDragInfo dragInfo:AnyObject, atDragIndexPath dragIndexPath: IndexPath,withDropInfo dropInfo:AnyObject?) -> Void{
        if (dropInfo != nil) {
            
            //collectionModels[dragIndexPath.item] = (dropInfo as! Workout)
            //collectionIDs[dragIndexPath.item] = (dropInfo as! NSManagedObjectID)
        } else {
            //collectionModels[dragIndexPath.item].name = nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropCompleteWithDragInfo dragInfo:AnyObject, atDragIndexPath dragIndexPath: IndexPath?,withDropInfo dropInfo:AnyObject?,atDropIndexPath dropIndexPath:IndexPath) -> Void{
        if let dropInfo = dropInfo as? NSManagedObjectID {
            collectionIDs[dropIndexPath] = dropInfo
        }
    }


    func collectionViewStopDropping(_ collectionView: UICollectionView) {
        clearCellsDrogStatusOfCollectionView()
        collectionView.reloadData()
    }
    
    func collectionViewStopDragging(_ collectionView: UICollectionView) {
        clearCellsDrogStatusOfCollectionView()
        collectionView.reloadData()
        
    }
    
    
    func clearCellsDrogStatusOfCollectionView(){
        for cell in dragDropCollectionView.visibleCells{
            if (cell as! DragDropCollectionViewCell).hasContent() {
                (cell as! DragDropCollectionViewCell).selectedStatus()
                continue
            }
            (cell as! DragDropCollectionViewCell).nomoralStatus()
        }
    }
}
