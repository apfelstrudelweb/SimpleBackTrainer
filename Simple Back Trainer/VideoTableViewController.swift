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
        headerLabel.text = "Übungen" //"Übungen für die Muskelgruppe \"\(String(describing: self.title!))\""
        
        let fetchRequest = NSFetchRequest<Workout> (entityName: "Workout")
        fetchRequest.sortDescriptors = [NSSortDescriptor (key: "position", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "musclegroupId.id = %d", muscleGroupId)
        
        self.fetchedResultsController = NSFetchedResultsController<Workout> (
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataManager.sharedInstance.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        self.fetchedResultsController.delegate = self
        

        super.viewDidLoad()
        
    }

}

