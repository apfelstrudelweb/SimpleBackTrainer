//
//  DragDropTableView.swift
//  Pods
//
//  Created by Rafael on 31/07/2017.
//
//


import UIKit


@objc public protocol DropTableViewDelegate : NSObjectProtocol {
    
    func tableView(_ tableView: UITableView, dragInfoForIndexPath indexPath: IndexPath) -> AnyObject
    
    //drop
    func tableView(_ tableView: UITableView, canDropWithDragInfo info:AnyObject, AtIndexPath indexPath: IndexPath) -> Bool
    @objc optional func tableView(_ tableView: UITableView, dropOutsideWithDragInfo info:AnyObject) -> Void
    func tableView(_ tableView: UITableView, dropCompleteWithDragInfo dragInfo:AnyObject, atDragIndexPath dragIndexPath: IndexPath?,withDropInfo dropInfo:AnyObject?,atDropIndexPath dropIndexPath:IndexPath) -> Void
    func tableViewStopDropping(_ tableView: UITableView)->Void
}


@objc open class DragDropTableView: UITableView, Droppable {
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate var draggingPathOfCellBeingDragged : IndexPath?
    
    fileprivate var iDataSource : UITableViewDataSource?
    fileprivate var iDelegate : UITableViewDelegate?
    
    open var dropTableViewDelegate : DropTableViewDelegate?
    
    
    func indexPathForCellOverlappingRect( _ rect : CGRect) -> IndexPath? {
        
        let centerPoint = CGPoint(x: rect.minX + rect.width/2, y: rect.minY + rect.height/2)
        print("centerPoint == ", centerPoint)
        //Rakesh Kumar
        guard visibleCells.count > 0 else {
            return IndexPath(row: 0, section: 0)
        }
        
        for cell in visibleCells {
            
            if cell.frame.contains(centerPoint) {
                //                let indexPath = self.indexPath(for: cell)
                //                let totalCell = self.numberOfRows(inSection: 0)
                //                if totalCell > 2 {
                //                    if indexPath?.row == totalCell - 1 {
                //                        return nil
                //                    }
                //                }
                return self.indexPath(for: cell)
            }
            
        }
        
        let totalCell = self.numberOfRows(inSection: 0)
        return IndexPath(row: totalCell, section: 0)
        
        // return nil
    }
    
    open func checkFroEdgesAndScroll(_ item : AnyObject, inRect rect : CGRect) -> Void {
        startDisplayLink()
        
        // Check Paging
        var normalizedRect = rect
        normalizedRect.origin.x -= self.contentOffset.x
        normalizedRect.origin.y -= self.contentOffset.y
        
        
        dragRectCurrent = normalizedRect
        
    }
    
    
    //scroll relate
    fileprivate var displayLink: CADisplayLink?
    internal var scrollSpeedValue: CGFloat = 10.0
    fileprivate var dragRectCurrent:CGRect!
    
    fileprivate func startDisplayLink() {
        guard displayLink == nil else {
            return
        }
        
        displayLink = CADisplayLink(target: self, selector: #selector(DragDropTableView.handlerDisplayLinkToContinuousScroll))
        displayLink!.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    }
    
    fileprivate func invalidateDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
        dragRectCurrent = nil
    }
    
    
    @objc func handlerDisplayLinkToContinuousScroll(){
        
        if dragRectCurrent == nil {
            return
        }
        
        let currentRect : CGRect = CGRect(x: self.contentOffset.x, y: self.contentOffset.y, width: self.bounds.size.width, height: self.bounds.size.height)
        var rectForNextScroll : CGRect = currentRect
        
        // Only vertical
        //        debugPrint("drag view rect: \(dragRectCurrent) ———— super view rect\(currentRect)")
        let topBoundary = CGRect(x: 0.0, y: -30.0, width: self.frame.size.width, height: 30.0)
        let bottomBoundary = CGRect(x: 0.0, y: self.frame.size.height, width: self.frame.size.width, height: 30.0)
        
        
        if dragRectCurrent.intersects(topBoundary) == true {
            rectForNextScroll.origin.y -= 5
            if rectForNextScroll.origin.y < 0 {
                rectForNextScroll.origin.y = 0
            }
        }
        else if dragRectCurrent.intersects(bottomBoundary) == true {
            //              debugPrint("move in bottomboundary : \(dragRectCurrent)")
            rectForNextScroll.origin.y += 5
            if rectForNextScroll.origin.y > self.contentSize.height - self.bounds.size.height {
                rectForNextScroll.origin.y = self.contentSize.height - self.bounds.size.height
            }
        }
        
        
        if currentRect.equalTo(rectForNextScroll) == false {
            print("dragCurrentRect = ", dragRectCurrent)
            print("rectForNextScroll = ", rectForNextScroll)
            scrollRectToVisible(rectForNextScroll, animated: false)
            
        }
    }
    
    
    // MARK : Droppable
    
    open func canDropWithDragInfo(_ item: AnyObject,  inRect rect: CGRect) -> Bool {
        print("canDropWithDragInfo")
        if let indexPath = self.indexPathForCellOverlappingRect(rect) {
            if dropTableViewDelegate != nil {
                
                return dropTableViewDelegate!.tableView(self, canDropWithDragInfo: item, AtIndexPath: indexPath)
                
            }
        }
        
        return false
    }
    
    open func dropOverInfoInRect(_ rect: CGRect) -> AnyObject? {
        print("dropOverInfoInRect")
        if let indexPath = self.indexPathForCellOverlappingRect(rect) {
            if dropTableViewDelegate != nil {
                return dropTableViewDelegate!.tableView(self, dragInfoForIndexPath: indexPath)
            }
        }
        return nil
    }
    
    open func dropOutside(_ dragInfo: AnyObject, inRect rect: CGRect) {
        if dropTableViewDelegate != nil && dropTableViewDelegate!.responds(to: #selector(DropTableViewDelegate.tableView(_:dropOutsideWithDragInfo:))){
            dropTableViewDelegate!.tableView!(self, dropOutsideWithDragInfo: dragInfo)
        }
    }
    
    open func stopDropping() {
        if dropTableViewDelegate != nil {
            invalidateDisplayLink()
            dropTableViewDelegate!.tableViewStopDropping(self)
            
        }
    }
    
    open func dropComplete(_ dragInfo : AnyObject,dropInfo:AnyObject?, atRect rect: CGRect) -> Void{
        print("drop complete")
        if let dropIndexPath = self.indexPathForCellOverlappingRect(rect) {
            if  let dragIndexPath = draggingPathOfCellBeingDragged{
                if dropTableViewDelegate != nil {
                    dropTableViewDelegate!.tableView(self, dropCompleteWithDragInfo: dragInfo, atDragIndexPath: dragIndexPath, withDropInfo: dropInfo, atDropIndexPath: dropIndexPath)
                    
                }
                
            }else{
                if dropTableViewDelegate != nil {
                    dropTableViewDelegate!.tableView(self, dropCompleteWithDragInfo: dragInfo, atDragIndexPath: nil, withDropInfo: dropInfo, atDropIndexPath: dropIndexPath)
                    
                }
            }
            
        }
        
        self.draggingPathOfCellBeingDragged = nil
        
    }
    
}

