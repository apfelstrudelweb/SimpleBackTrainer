//
//  ViewController.swift
//  Trainingsplan
//
//  Created by Ulrich Vormbrock on 06.04.18.
//  Copyright © 2018 Ulrich Vormbrock. All rights reserved.
//

import UIKit
import DragDropiOS
import CoreData


class TrainingsplanViewController: BaseViewController, DragDropCollectionViewDelegate, DropTableViewDelegate {

    var fetchedResultsController1: NSFetchedResultsController<Trainingsplan>!
    var fetchedResultsController2: NSFetchedResultsController<NSFetchRequestResult>!
    
    var collectionIDs: [IndexPath : NSManagedObjectID] = Dictionary<IndexPath, NSManagedObjectID>()
    
    var dragDropItem: DragDropItem!
    var dragDropManager:DragDropManager!
    
    var trainingsplan: Trainingsplan!
    
    var droppedWorkout: Workout!
    
    var tableData: [Trainingsplan]!
    
    
    var addMode = false
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var dragDropTableView: DragDropTableView!
    @IBOutlet weak var dragDropCollectionView: DragDropCollectionView!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    
    func updateTrainingsplan() {
        

        if let position = droppedWorkout?.droppedPosition {
            
            CoreDataManager.sharedInstance.insertIntoTrainingsplan(workout: droppedWorkout, position: Int(position))
        }
        
        self.getTrainingsplan()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Plan"

        //addSlideMenuButton()
        
        dragDropTableView.allowsSelection = false
        dragDropTableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: "videoCell")
        dragDropCollectionView.register(UINib(nibName: "DragDropCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "musclegroupCell")
        
        dragDropTableView.tableFooterView = UIView(frame: .zero)
        dragDropTableView.rowHeight = UITableViewAutomaticDimension
        dragDropTableView.estimatedRowHeight = 10
        
        self.setDragDropTableView()
        self.setDragDropCollectionView()
        dragDropManager = DragDropManager(canvas: self.view, views: [dragDropCollectionView,dragDropTableView])
        
        configureFetchedResultsController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.getTrainingsplan()
        toggleAddMode()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil, completion: {
            _ in
            
            guard let tableView = self.dragDropTableView else {
                return
            }
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            self.toggleAddMode()
            
            //self.dragDropTableView.reloadData()
        })
        
    }
    
    public func getTrainingsplan() {
        do {
            try fetchedResultsController1.performFetch()
            let count = try CoreDataManager.sharedInstance.managedObjectContext.count(for: fetchedResultsController1.fetchRequest)
            self.tabBarController?.tabBar.items![1].badgeValue = String(count)
            tableData = fetchedResultsController1.fetchedObjects!
            
            try fetchedResultsController2.performFetch()
            
        } catch {
            print("An error occurred")
        }
        
        self.dragDropCollectionView.reloadData()
        self.dragDropTableView.reloadData()
    }
    
    func configureFetchedResultsController() {
        
        let fetchRequest1 = NSFetchRequest<Trainingsplan> (entityName: "Trainingsplan")
        fetchRequest1.sortDescriptors = [NSSortDescriptor (key: "position", ascending: true)]
        self.fetchedResultsController1 = NSFetchedResultsController<Trainingsplan> (
            fetchRequest: fetchRequest1,
            managedObjectContext: CoreDataManager.sharedInstance.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        self.fetchedResultsController1.delegate = self
        
        let fetchRequest2 = NSFetchRequest<NSFetchRequestResult> (entityName: "GroupWorkoutMembership")
        fetchRequest2.relationshipKeyPathsForPrefetching = ["workout"]
        fetchRequest2.predicate = NSPredicate(format: "workout.@count > 0")
        fetchRequest2.sortDescriptors = [NSSortDescriptor (key: "group.id", ascending: true, selector: #selector(NSNumber.compare(_:)))]
        
        self.fetchedResultsController2 = NSFetchedResultsController<NSFetchRequestResult> (
            fetchRequest: fetchRequest2,
            managedObjectContext: CoreDataManager.sharedInstance.managedObjectContext,
            sectionNameKeyPath: "group.alias",
            cacheName: nil)
        self.fetchedResultsController2.delegate = self
    }
    
    func setDragDropTableView() {
        dragDropTableView.dropTableViewDelegate = self
        dragDropTableView.contentInset = UIEdgeInsets.zero
        dragDropTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.dragDropTableView.frame.width, height: 50))
    }
    
    func setDragDropCollectionView() {
        dragDropCollectionView.dragDropDelegate = self
        
        let collectionViewFlowLayout = DecorationCollectionViewFlowLayout()
        collectionViewFlowLayout.minimumLineSpacing = 10
        collectionViewFlowLayout.minimumInteritemSpacing = 10
        //collectionViewFlowLayout.itemSize = CGSize(width: 100, height: 100)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let availableWidth = self.view.frame.size.width - 2*collectionViewFlowLayout.minimumInteritemSpacing
        let itemWidth = 0.3*availableWidth
        collectionViewFlowLayout.itemSize = CGSize(width: itemWidth, height: 1.1*itemWidth)
        
        collectionViewFlowLayout.headerReferenceSize = CGSize(width: 0, height: 50)
        dragDropCollectionView.collectionViewLayout = collectionViewFlowLayout
        dragDropCollectionView.backgroundColor = .white
        dragDropCollectionView.bounces = false
    }
    
    // MARK: editing mode
    @IBAction func startEditing(_ sender: UIBarButtonItem) {
        
        self.dragDropTableView.setEditing(!self.dragDropTableView.isEditing, animated: true)
        
        editButton.image = self.dragDropTableView.isEditing ? UIImage (named: "okButton") : UIImage (named: "editButton")
        addButton.isEnabled = !self.dragDropTableView.isEditing
        // TODO: do we need this?
        dragDropTableView.dropTableViewDelegate = self.dragDropTableView.isEditing ? nil : self
    }
    
    @IBAction func addButtonTouched(_ sender: UIBarButtonItem) {
        addMode = !addMode
        toggleAddMode()
    }
    
    func toggleAddMode() {

        let isLandscape = self.view.frame.size.width > self.view.frame.size.height
        addButton.isEnabled = !isLandscape
        
        if isLandscape {
            addMode = false
        }

        addButton.image = addMode ? UIImage (named: "okButton") : UIImage (named: "plusButton")
        editButton.isEnabled = !addMode
        tableViewHeight.constant = addMode ? 0.4*view.bounds.size.height : 0.9*view.bounds.size.height
        
        dragDropCollectionView.isHidden = !addMode


        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
            
            self.view.layoutIfNeeded()
        }, completion: { (finished: Bool) in
            DispatchQueue.main.async {
                if self.addMode {
                    // necessary that used items are greyed out
                    self.dragDropCollectionView.reloadData()
                }
            }
        })
    }
}

//MARK: UICollectionViewDelegate
extension TrainingsplanViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard fetchedResultsController2 != nil else {
            return 0
        }
        if let sections = fetchedResultsController2.sections {
            return sections.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard fetchedResultsController2 != nil else {
            return 0
        }
        if let result = fetchedResultsController2.fetchedObjects {
            let group = result[section] as? GroupWorkoutMembership
            
            let items = group?.workout?.allObjects as! [Workout]
            return items.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DragDropCollectionViewCell.cellIdentifier, for: indexPath) as! DragDropCollectionViewCell
        
        let group = fetchedResultsController2.fetchedObjects![indexPath.section] as? GroupWorkoutMembership
        var workouts = group?.workout!.allObjects as! [Workout]
        workouts = workouts.sorted { $0.id < $1.id }
        let workout = workouts[indexPath.row]
        
        cell.imageView.layer.borderColor = UIColor.lightGray.cgColor
        cell.imageView.layer.borderWidth = 1
        cell.imageView.image = UIImage(data:workout.icon! as Data, scale:1.0)
        cell.alpha = (workout.traininsgplanId != nil) ? 0.3 : 1
        cell.dragDropSymbol.tintColor = .lightGray//self.navigationController?.navigationBar.barTintColor
//        cell.dragDropSymbol.layer.borderColor = UIColor.lightGray.cgColor
//        cell.dragDropSymbol.layer.borderWidth = 1
        cell.dragDropSymbol.alpha = (workout.traininsgplanId != nil) ? 0 : 1
        cell.label.text = NSLocalizedString(workout.alias!, comment: "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SectionHeader", for: indexPath) as! ApplicationHeaderCollectionReusableView

        let membership = fetchedResultsController2.fetchedObjects![indexPath.section] as? GroupWorkoutMembership
        
        if let count = membership?.workout?.count {
            let trimmedString = NSLocalizedString((membership?.group?.alias)!, comment: "").replacingOccurrences(of: "\\s?\\([^)]*\\)", with: "", options: .regularExpression)
            header.titleLabel.text = trimmedString + " (\(count))"
        }

        header.backgroundColor = membership?.group?.color?.colorFromString()
        
        return header
    }
    
    //    // MARK: UICollectionViewDelegate Protocol
    //    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
    //        if elementKind == UICollectionElementKindSectionHeader, let view = view as? ApplicationHeaderCollectionReusableView {
    //            view.titleLabel.textColor = UIColor.white
    //        } else if elementKind == ApplicationBackgroundCollectionReusableView.kind() {
    //            let workout = self.fetchedResultsController2.object(at: indexPath)
    //            view.backgroundColor = (workout.musclegroupId?.color as? UIColor)
    //        }
    //    }
}

// MARK: UITableViewDelegate And UITableViewDataSource methods
extension TrainingsplanViewController:UITableViewDelegate, UITableViewDataSource {
    //MARK: UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        guard fetchedResultsController1 != nil else {
            return 0
        }
        if let sections = fetchedResultsController1.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard fetchedResultsController1 != nil else {
            return 0
        }
        if let sections = fetchedResultsController1.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"videoCell", for: indexPath) as! VideoCell
        
        let workout = fetchedResultsController1.object(at: indexPath)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Workout")
        let predicate = NSPredicate(format: "id = %d", workout.id)
        fetchRequest.predicate = predicate
        
        var retrievedWorkout: Workout
        
        do {
            retrievedWorkout = try CoreDataManager.sharedInstance.managedObjectContext.fetch(fetchRequest).first as! Workout
            
        } catch {
            fatalError("Failed to delete object: \(error)")
        }
        
        cell.premiumImageView.isHidden = true
        cell.favoriteButton.isHidden = true
        cell.favoriteDelimter.isHidden = true
        cell.stackView.isHidden = false
        cell.videoImageView?.alpha = 1
        
        //cell.videoLabel.text = NSLocalizedString(retrievedWorkout.alias!, comment: "")
        cell.videoImageView.image = UIImage(data:retrievedWorkout.icon! as Data, scale:1.0)
        
        var colors = [MusclegroupColor]()

        //let sortedMusclegroups = retrievedWorkout.musclegroupId?.sorted { (($0 as! Musclegroup).id) < (($1 as! Musclegroup).id) }
        
        let memberships = retrievedWorkout.membership!.allObjects as! [GroupWorkoutMembership]

        for member in memberships {
            let group = member.group
            let musclegroupColor = MusclegroupColor.init(withId: (group?.id)!, color: (group?.color?.colorFromString())!)
            colors.append(musclegroupColor)
        }
        
        
        let sortedColors = colors.sorted( by: { $0.id < $1.id } )
        
        cell.videoLabel.text =  NSLocalizedString(retrievedWorkout.alias!, comment: "") //String(retrievedWorkout.id)
        
        let sortedStripeViews = cell.stripeViewCollection.sorted(by: { $0.tag < $1.tag })
        
        for (i, stripeView) in sortedStripeViews.enumerated() {
            let color = i<sortedColors.count ? sortedColors[i].color : .clear
            stripeView.backgroundColor = color
        }
        
        return cell
    }
    
    // REMINDER: make sure we work with the same fetchedResultsController!!!
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Redundancy: workout is fetched twice, also in
            let workoutInTrainingsplan = self.fetchedResultsController1.object(at: indexPath)
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Workout")
            let predicate = NSPredicate(format: "id = %d", workoutInTrainingsplan.id)
            fetchRequest.predicate = predicate
            
            var retrievedWorkout: Workout
            
            do {
                retrievedWorkout = try CoreDataManager.sharedInstance.managedObjectContext.fetch(fetchRequest).first as! Workout
                
            } catch {
                fatalError("Failed to delete object: \(error)")
            }
            
            CoreDataManager.sharedInstance.removeFromTrainingsplan(workout: retrievedWorkout)
        }
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        tableData = fetchedResultsController1.fetchedObjects!
        var workouts = [Workout]()
        
        let sortedTableData = fetchedResultsController1.fetchedObjects?.sorted { ($0.position) < ($1.position) }
        
        
        for (index, workout) in (sortedTableData?.enumerated())! {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Workout")
            let predicate = NSPredicate(format: "id = %d", workout.id)
            fetchRequest.predicate = predicate
            
            var retrievedWorkout: Workout
            
            do {
                retrievedWorkout = try CoreDataManager.sharedInstance.managedObjectContext.fetch(fetchRequest).first as! Workout
                
            } catch {
                fatalError("Failed to delete object: \(error)")
            }
            
            workouts.insert(retrievedWorkout, at: index)
        }
        
        let itemToMove = workouts[sourceIndexPath.row]
        workouts.remove(at: sourceIndexPath.row)
        workouts.insert(itemToMove, at: destinationIndexPath.row)
        
        for (index, workout) in workouts.enumerated() {
            workout.traininsgplanId?.position = Int16(index)
        }
        
        do {
            try CoreDataManager.sharedInstance.managedObjectContext.save()
        } catch let error {
            print("Failure to save context: \(error.localizedDescription)")
        }
    }
}

// MARK: NSFetchedResultsControllerDelegate methods
extension TrainingsplanViewController:NSFetchedResultsControllerDelegate {
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.dragDropTableView.beginUpdates()
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                           didChange anObject: Any,
                           at indexPath: IndexPath?,
                           for type: NSFetchedResultsChangeType,
                           newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.dragDropTableView.insertRows(at: [newIndexPath!], with: .middle)
            //            if controller == fetchedResultsController1 {
            //
            //                self.dragDropTableView.insertRows(at: [newIndexPath!], with: .middle)
            //
            //                // let point = CGPoint(x: 0, y: (newIndexPath?.row)! * 60 + 60)
            //                //                    self.dragDropTableView.contentSize = CGSize(width: self.dragDropTableView.contentSize.width, height: CGFloat((newIndexPath?.row)! * 60 + 60))
            //                //                    self.dragDropTableView.setContentOffset(point, animated: true)
            //            } else {
            //                //self.dragDropCollectionView.insertItems(at: [newIndexPath!])
        //            }
        case .delete:
            self.dragDropTableView.deleteRows(at: [indexPath!], with: .automatic)
        case .move:
            self.dragDropTableView.moveRow(at: indexPath!, to: newIndexPath!)
            fallthrough
        case .update:
            print(indexPath!)
        }
        //        DispatchQueue.main.async {
        //            if controller == self.fetchedResultsController1 {
        //                self.dragDropTableView.reloadData()
        //                //  self.dragDropTableView.layoutIfNeeded()
        //                print("ContentOffset = ",self.dragDropTableView.contentOffset)
        //                print("content Size = ", self.dragDropTableView.contentSize)
        //            } else {
        //                self.dragDropCollectionView.reloadData()
        //            }
        //        }
        
    }
    
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        self.getTrainingsplan()
        self.dragDropTableView.endUpdates()
    }
}

extension TrainingsplanViewController:TrainingModelDelegate {
    func didRetrieveWorkouts(workouts: [WorkoutData]) {
        //        CoreDataManager.sharedInstance.managedObjectContext.automaticallyMergesChangesFromParent = true
        //        CoreDataManager.sharedInstance.updateMusclegroup(serverGroupsData: groups)
        
        configureFetchedResultsController()
        do {
            try fetchedResultsController1.performFetch()
            try fetchedResultsController2.performFetch()
        } catch {
            print("An error occurred")
        }
        
        self.dragDropCollectionView.reloadData()
        self.dragDropTableView.reloadData()
    }
    
    func didRetrieveTrainingsplan(exercises: [TrainingsplanData]) {
        // TODO: implement
    }
    
    func showErrorMessage(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension TrainingsplanViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == dragDropTableView {
//            print("ContentOffset = ",scrollView.contentOffset)
//            print("content Size = ", scrollView.contentSize)
//            print("TAbleViewHeight = ", self.dragDropTableView.frame.height)
        }
    }
}

extension UIColor {
    var hue: CGFloat {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getHue(&hue,
                    saturation: &saturation,
                    brightness: &brightness,
                    alpha: &alpha)
        return hue
    }
}

class MusclegroupColor: NSObject {
    
    var id: Int16
    var color: UIColor
    
    init(withId id: Int16, color: UIColor) {
        self.id = id
        self.color = color
    }
    
}

//extension UIView {
//    func animateConstraintWithDuration(duration: TimeInterval = 0.5) {
//        UIView.animate(withDuration: duration, animations: { [weak self] in
//            self?.layoutIfNeeded() ?? ()
//        })
//    }
//}
//
//extension NSLayoutConstraint {
//    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
//        return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
//    }
//}
