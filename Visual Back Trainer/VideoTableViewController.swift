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
    
    var muscleGroupColor: UIColor = .lightGray


    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    

    override func viewDidLoad() {

        headerView.backgroundColor = muscleGroupColor

        let fetchRequest = NSFetchRequest<Workout> (entityName: "Workout")
        fetchRequest.sortDescriptors = [NSSortDescriptor (key: "id", ascending: true)]

        let predicate1 = NSPredicate(format: "ANY musclegroupId.id = %d", muscleGroupId)
        let predicate2 = NSPredicate(format: "isLive = %d", true)
        let compound:NSCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        fetchRequest.predicate = compound
        
        self.fetchedResultsController = NSFetchedResultsController<Workout> (
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataManager.sharedInstance.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        self.fetchedResultsController.delegate = self
        
        do {
            let count = try CoreDataManager.sharedInstance.managedObjectContext.count(for: fetchRequest)
            headerLabel.text = "\(count) Übungen"
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
        super.viewDidLoad()
        
    }

}

