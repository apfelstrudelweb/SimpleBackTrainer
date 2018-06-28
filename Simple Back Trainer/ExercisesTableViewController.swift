//
//  ExercisesTableViewController.swift
//  Simple Back Trainer
//
//  Created by Ulrich Vormbrock on 21.06.18.
//  Copyright © 2018 Rookie. All rights reserved.
//

import UIKit
import AMPopTip
import CoreData

class ExercisesTableViewController: GenericTableViewController {
    
    let inactiveColor:UIColor = .lightGray

    var fetchRequest: NSFetchRequest<Workout>!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var buttonHandweight: UIButton!
    @IBOutlet weak var buttonBand: UIButton!
    @IBOutlet weak var buttonMat: UIButton!
    @IBOutlet weak var buttonBall: UIButton!
    @IBOutlet weak var buttonMachine: UIButton!
    
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var warningBar: UIView!
    @IBOutlet weak var warningLabel: UILabel!
    
    
    
    override func viewDidLoad() {

        headerView.backgroundColor = UITabBar.appearance().barTintColor

        buttonHandweight.tintColor = self.navigationController?.navigationBar.barTintColor
        buttonBand.tintColor = inactiveColor
        buttonMat.tintColor = inactiveColor
        buttonBall.tintColor = inactiveColor
        buttonMachine.tintColor = inactiveColor
        
        buttonHandweight.setTitle("", for: .normal)
        buttonBand.setTitle("", for: .normal)
        buttonMat.setTitle("", for: .normal)
        buttonBall.setTitle("", for: .normal)
        buttonMachine.setTitle("", for: .normal)
        
    
        self.fetchRequest = NSFetchRequest<Workout> (entityName: "Workout")
        self.fetchRequest.sortDescriptors = [NSSortDescriptor (key: "position", ascending: true)]
        
        self.fetchedResultsController = NSFetchedResultsController<Workout> (
            fetchRequest: self.fetchRequest,
            managedObjectContext: CoreDataManager.sharedInstance.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        self.fetchedResultsController.delegate = self
        
        super.viewDidLoad()
        
        self.filterHandweight((Any).self)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        headerView.frame.size.height = self.view.frame.size.height > self.view.frame.size.width ? 65 : 80
    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        self.tableView.reloadData()
//    }
    
    func clearButtons() {
    
        buttonHandweight.tintColor = inactiveColor
        buttonBand.tintColor = inactiveColor
        buttonMat.tintColor = inactiveColor
        buttonBall.tintColor = inactiveColor
        buttonMachine.tintColor = inactiveColor
    }
    

    @IBAction func filterHandweight(_ sender: Any) {
        
        clearButtons()
        buttonHandweight.tintColor = self.navigationController?.navigationBar.barTintColor
        
        let predicate1 = NSPredicate(format: "musclegroupId.id < %d", 5)
        let predicate2 = NSPredicate(format: "id = %d", 3)
        let compound:NSCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        self.fetchRequest.predicate = compound
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    @IBAction func filterBand(_ sender: Any) {
        
        clearButtons()
        buttonBand.tintColor = self.navigationController?.navigationBar.barTintColor
        
        let predicate1 = NSPredicate(format: "musclegroupId.id < %d", 5)
        let predicate2 = NSPredicate(format: "id = %d", 2)
        let compound:NSCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        self.fetchRequest.predicate = compound
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    @IBAction func filterMat(_ sender: Any) {
        
        clearButtons()
        buttonMat.tintColor = self.navigationController?.navigationBar.barTintColor
        
        let predicate1 = NSPredicate(format: "musclegroupId.id < %d", 5)
        let predicate2 = NSPredicate(format: "id = %d", 1)
        let compound:NSCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        self.fetchRequest.predicate = compound
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    @IBAction func filterBall(_ sender: Any) {
        
        clearButtons()
        buttonBall.tintColor = self.navigationController?.navigationBar.barTintColor
        
        let predicate1 = NSPredicate(format: "musclegroupId.id >= %d", 5)
        let predicate2 = NSPredicate(format: "id = %d", 3)
        let compound:NSCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        self.fetchRequest.predicate = compound
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    @IBAction func filterMachine(_ sender: Any) {
        
        clearButtons()
        buttonMachine.tintColor = self.navigationController?.navigationBar.barTintColor
        
        let predicate1 = NSPredicate(format: "musclegroupId.id >= %d", 5)
        let predicate2 = NSPredicate(format: "id = %d", 2)
        let compound:NSCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        self.fetchRequest.predicate = compound
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
        self.tableView.reloadData()
    }

}
