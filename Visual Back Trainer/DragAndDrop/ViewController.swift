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

class ViewController: BaseViewController, DragDropCollectionViewDelegate, DropTableViewDelegate {

    var fetchedResultsController1: NSFetchedResultsController<Trainingsplan>!
    var fetchedResultsController2: NSFetchedResultsController<NSFetchRequestResult>!
    
    var collectionIDs: [IndexPath : NSManagedObjectID] = Dictionary<IndexPath, NSManagedObjectID>()
    
    var dragDropItem: DragDropItem!
    var dragDropManager:DragDropManager!
    
    var trainingsplan: Trainingsplan!
    
    var droppedWorkout: Workout!
    
    var tableData: [Trainingsplan]!
    
    
    var addMode = false
    
    var soloTitle: String?
    
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
        soloTitle = self.title
        addSlideMenuButton()
        
        dragDropTableView.allowsSelection = false
        dragDropTableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: "videoCell")
        
        self.setDragDropTableView()
        self.setDragDropCollectionView()
        dragDropManager = DragDropManager(canvas: self.view, views: [dragDropCollectionView,dragDropTableView])
        
        configureFetchedResultsController()
        toggleAddMode()
        
//        let planFetchRequest = NSFetchRequest<Trainingsplan>(entityName: "Trainingsplan")
//        trainingsplan = try! CoreDataManager.sharedInstance.managedObjectContext.fetch(planFetchRequest).first
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.getTrainingsplan()
        //self.dragDropTableView.reloadData()
    }
    
    public func getTrainingsplan() {
        do {
            try fetchedResultsController1.performFetch()
            let count = try CoreDataManager.sharedInstance.managedObjectContext.count(for: fetchedResultsController1.fetchRequest)
            self.title = self.soloTitle! + " (\(count))"
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
        collectionViewFlowLayout.itemSize = CGSize(width: 100, height: 70)
        collectionViewFlowLayout.sectionInset = .zero //UIEdgeInsets(top: 10, left: spacesWidth, bottom: 5, right: spacesWidth)
        collectionViewFlowLayout.headerReferenceSize = CGSize(width: 0, height: 50)
        dragDropCollectionView.collectionViewLayout = collectionViewFlowLayout
        dragDropCollectionView.backgroundColor = UIColor.white
        dragDropCollectionView.bounces = false
    }
    
    // MARK: editing mode
    @IBAction func startEditing(_ sender: UIBarButtonItem) {
        self.dragDropTableView.isEditing = !self.dragDropTableView.isEditing
        editButton.image = self.dragDropTableView.isEditing ? UIImage (named: "okButton") : UIImage (named: "editButton")
        addButton.isEnabled = !self.dragDropTableView.isEditing
        dragDropTableView.dropTableViewDelegate = self.dragDropTableView.isEditing ? nil : self
    }
    
    @IBAction func addButtonTouched(_ sender: UIBarButtonItem) {
        addMode = !addMode
        toggleAddMode()
    }
    
    func toggleAddMode() {
        
        addButton.image = addMode ? UIImage (named: "okButton") : UIImage (named: "plusButton")
        editButton.isEnabled = !addMode
        //dragDropTableView.beginUpdates()
        tableViewHeight.constant = addMode ? 0.4*view.bounds.size.height : 0.85*view.bounds.size.height
        // dragDropTableView.endUpdates()
        //        let bottomInset = addMode ?  dragDropTableView.contentInset.bottom + dragDropTableView.rowHeight : 0
        //        dragDropTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
            self.view.layoutIfNeeded()
            self.dragDropTableView.layoutIfNeeded()
        }, completion: { (finished: Bool) in
            DispatchQueue.main.async {
                
                //                self.dragDropTableView.contentOffset = CGPoint.zero
                self.dragDropCollectionView.reloadData()
                self.dragDropTableView.reloadData()
                //                let numberOfRows = self.dragDropTableView.numberOfRows(inSection: 0)
                //                if numberOfRows > 0 {
                //                    self.dragDropTableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: UITableViewScrollPosition.top, animated: false)
                //                }
            }
            
        })
    }
}

//MARK: UICollectionViewDelegate
extension ViewController:UICollectionViewDelegate, UICollectionViewDataSource {
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
//        if let sections = fetchedResultsController2.sections {
//            let currentSection = sections[section]
//            print(currentSection.numberOfObjects)
//            return currentSection.numberOfObjects
//        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DragDropCollectionViewCell.cellIdentifier, for: indexPath) as! DragDropCollectionViewCell
        
        let group = fetchedResultsController2.fetchedObjects![indexPath.section] as? GroupWorkoutMembership
        var workouts = group?.workout!.allObjects as! [Workout]
        workouts = workouts.sorted { $0.id < $1.id }
        let workout = workouts[indexPath.row]
        
        cell.imageView.layer.borderColor = UIColor.darkGray.cgColor
        cell.imageView.layer.borderWidth = 1
        cell.imageView.image = UIImage(data:workout.icon! as Data, scale:1.0)
        cell.alpha = (workout.traininsgplanId != nil) ? 0.3 : 1
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
extension ViewController:UITableViewDelegate, UITableViewDataSource {
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
        
        cell.videoLabel.text = NSLocalizedString(retrievedWorkout.alias!, comment: "") + " \(sortedColors.count)"

        // for scrolling issues when showing collection view: redraw stripes!
        for subview in cell.stackView.subviews {
            subview.removeFromSuperview()
        }
        cell.stackView.snp.removeConstraints()
        
        
        for musclegroupColor in sortedColors {
            
            let stripe = UIView()
            stripe.backgroundColor = musclegroupColor.color
            cell.stackView.addArrangedSubview(stripe)
            
            cell.stackView.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(5*sortedColors.count)
            }
            
            stripe.snp.makeConstraints { (make) -> Void in
                //make.height.equalToSuperview()
                //make.width.equalToSuperview().dividedBy(colors.count) //Double(colors.count)
                //make.width.equalTo(60/Double(colors.count))
                make.width.equalTo(5)
            }
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
extension ViewController:NSFetchedResultsControllerDelegate {
    
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
        
        self.dragDropTableView.endUpdates()
        //        let dispatchTime = DispatchTime.now() + 0.5
        //        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
        //            self.dragDropCollectionView.reloadData()
        //            self.dragDropTableView.reloadData()
        //            //self.dragDropTableView.layoutIfNeeded()
        //            print("ContentOffset = ",self.dragDropTableView.contentOffset)
        //            print("content Size = ", self.dragDropTableView.contentSize)
        //            print("Table Height = ", self.dragDropTableView.frame.height)
        //            print("ContentInset = ",self.dragDropTableView.contentInset)
        //            print("================================")
        //            //self.dragDropTableView.setContentOffset(CGPoint(x: self.dragDropTableView.contentOffset.x, y:  self.dragDropTableView.contentOffset.y - 60.0), animated: false)
        //            //            self.dragDropTableView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        //            //            self.dragDropTableView.scrollRectToVisible(CGRect(x: 0, y: 60, width: self.dragDropTableView.frame.width, height: 60), animated: true)
        //            //            self.dragDropTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        //        }
        //
        //        //        let point = CGPoint(x: 0, y: 100)
        //        //        self.dragDropTableView.setContentOffset(point, animated: true)
    }
}

extension ViewController:TrainingModelDelegate {
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
    
    func showErrorMessage(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == dragDropTableView {
            print("ContentOffset = ",scrollView.contentOffset)
            print("content Size = ", scrollView.contentSize)
            print("TAbleViewHeight = ", self.dragDropTableView.frame.height)
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
