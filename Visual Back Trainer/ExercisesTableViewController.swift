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
    
    var soloTitle: String?
    

    override func viewDidLoad() {
        
        soloTitle = self.title

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
        fetchRequest.predicate = NSPredicate(format: "ANY isLive = %d", true)
        self.fetchRequest.sortDescriptors = [NSSortDescriptor (key: "id", ascending: true)]
        
        self.fetchedResultsController = NSFetchedResultsController<Workout> (
            fetchRequest: self.fetchRequest,
            managedObjectContext: CoreDataManager.sharedInstance.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        self.fetchedResultsController.delegate = self
        
        super.viewDidLoad()
        
        self.filterHandweight((Any).self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        headerView.frame.size.height = self.view.frame.size.height > self.view.frame.size.width ? 50 : 65
    }
    
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
        let predicate1 = NSPredicate(format: "isLive = %d", true)
        let predicate2 = NSPredicate(format: "isDumbbell == true")
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
    
    @IBAction func filterBand(_ sender: Any) {
        
        clearButtons()
        buttonBand.tintColor = self.navigationController?.navigationBar.barTintColor
        
        let predicate1 = NSPredicate(format: "isLive = %d", true)
        let predicate2 = NSPredicate(format: "isTheraband == true")
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
    
    @IBAction func filterMat(_ sender: Any) {
        
        clearButtons()
        buttonMat.tintColor = self.navigationController?.navigationBar.barTintColor
        
        let predicate1 = NSPredicate(format: "isLive = %d", true)
        let predicate2 = NSPredicate(format: "isMat == true")
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
    
    @IBAction func filterBall(_ sender: Any) {
        
        clearButtons()
        buttonBall.tintColor = self.navigationController?.navigationBar.barTintColor

        let predicate1 = NSPredicate(format: "isLive = %d", true)
        let predicate2 = NSPredicate(format: "isBall == true")
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
    
    @IBAction func filterMachine(_ sender: Any) {
        
        clearButtons()
        buttonMachine.tintColor = self.navigationController?.navigationBar.barTintColor

        let predicate1 = NSPredicate(format: "isLive = %d", true)
        let predicate2 = NSPredicate(format: "isMachine == true")
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

}
