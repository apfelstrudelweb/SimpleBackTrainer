//
//  VideoTableViewController.swift
//  sketchChanger
//
//  Created by Ulrich Vormbrock on 03.04.18.
//  Copyright © 2018 Ulrich Vormbrock. All rights reserved.
//

import UIKit
import CoreData

class VideoTableViewController: GenericTableViewController {
    
    var muscleGroupColor: UIColor?
    var soloTitle: String?
    let inactiveColor:UIColor = .lightGray
    
    var fetchRequest: NSFetchRequest<Workout>!
    var groupfetchResult: [NSManagedObject]? = nil

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var stripeView: UIView!
    
    @IBOutlet weak var buttonLevel1: UIButton!
    @IBOutlet weak var buttonLevel2: UIButton!
    @IBOutlet weak var buttonLevel3: UIButton!
    @IBOutlet weak var buttonLevel4: UIButton!
    
    override func viewDidLoad() {
        
        if muscleGroupId == 10 {
            muscleGroupId = 2
        } else if muscleGroupId == 17 {
            muscleGroupId = 4
        }

        soloTitle = self.title?.components(separatedBy: "(").first
        stripeView.backgroundColor = muscleGroupColor
        headerView.backgroundColor = UITabBar.appearance().barTintColor

        buttonLevel1.tintColor = inactiveColor
        buttonLevel2.tintColor = inactiveColor
        buttonLevel3.tintColor = inactiveColor
        buttonLevel4.tintColor = self.navigationController?.navigationBar.barTintColor
        
        buttonLevel1.setTitle("", for: .normal)
        buttonLevel2.setTitle("", for: .normal)
        buttonLevel3.setTitle("", for: .normal)
        buttonLevel4.setTitle("", for: .normal)

        fetchRequest = NSFetchRequest<Workout> (entityName: "Workout")
        fetchRequest?.sortDescriptors = [NSSortDescriptor (key: "id", ascending: true)]

        self.fetchedResultsController = NSFetchedResultsController<Workout> (
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataManager.sharedInstance.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        self.fetchedResultsController.delegate = self

        resetFilter()

        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        headerView.frame.size.height = self.view.frame.size.height > self.view.frame.size.width ? 50 : 65
    }
    
    func clearButtons() {
        
        buttonLevel1.tintColor = inactiveColor
        buttonLevel2.tintColor = inactiveColor
        buttonLevel3.tintColor = inactiveColor
        buttonLevel4.tintColor = inactiveColor
    }
    
    // TODO: simplify: work with enums in conjunction with intensity
    func resetFilter() {
        let predicate1 = NSPredicate(format: "ANY membership.group.id = %d", muscleGroupId)
        let predicate2 = NSPredicate(format: "isLive = %d", true)
        let compound:NSCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        fetchRequest.predicate = compound
        
        do {
            try fetchedResultsController.performFetch()
            let count = try CoreDataManager.sharedInstance.managedObjectContext.count(for: self.fetchRequest)
            self.title = self.soloTitle! + " (\(count))"
            
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func filter(intensity: Int) {

        let predicate1 = NSPredicate(format: "ANY membership.group.id = %d", muscleGroupId)
        let predicate2 = NSPredicate(format: "isLive = %d", true)
        let predicate3 = NSPredicate(format: "intensity contains[cd] %d", intensity)
        let compound:NSCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3])
        fetchRequest.predicate = compound

        do {
            try fetchedResultsController.performFetch()
            let count = try CoreDataManager.sharedInstance.managedObjectContext.count(for: self.fetchRequest)
            self.title = self.soloTitle! + " (\(count))"

        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
        self.tableView.reloadData()
    }
    

    @IBAction func filterLevel1(_ sender: Any) {
        clearButtons()
        buttonLevel1.tintColor = self.navigationController?.navigationBar.barTintColor
        filter(intensity: 1)
    }
    
    @IBAction func filterLevel2(_ sender: Any) {
        clearButtons()
        buttonLevel2.tintColor = self.navigationController?.navigationBar.barTintColor
        filter(intensity: 2)
    }
    
    @IBAction func filterLevel3(_ sender: Any) {
        clearButtons()
        buttonLevel3.tintColor = self.navigationController?.navigationBar.barTintColor
        filter(intensity: 3)
    }
    
    @IBAction func filterLevel4(_ sender: Any) {
        clearButtons()
        buttonLevel4.tintColor = self.navigationController?.navigationBar.barTintColor
        resetFilter()
    }
}

