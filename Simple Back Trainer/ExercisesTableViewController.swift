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

class ExercisesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let inactiveColor:UIColor = .lightGray
    var popTip = PopTip()
    
    var fetchedResultsController: NSFetchedResultsController<Workout>!
    var fetchRequest: NSFetchRequest<Workout>!

    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var buttonHandweight: UIButton!
    @IBOutlet weak var buttonBand: UIButton!
    @IBOutlet weak var buttonMat: UIButton!
    @IBOutlet weak var buttonBall: UIButton!
    @IBOutlet weak var buttonMachine: UIButton!
    
    
    @IBOutlet var buttons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        popTip.font = UIFont(name: "Avenir-Medium", size: UI_USER_INTERFACE_IDIOM() == .pad ? 20 : 14)!
        popTip.shouldDismissOnTap = true
        popTip.shouldDismissOnTapOutside = true
        popTip.shouldDismissOnSwipeOutside = true
        popTip.edgeMargin = 5
        popTip.offset = 2
        popTip.bubbleOffset = 0
        popTip.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10)
        
        self.tableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: "videoCell")
        
        self.fetchRequest = NSFetchRequest<Workout> (entityName: "Workout")
        self.fetchRequest.sortDescriptors = [NSSortDescriptor (key: "position", ascending: true)]
        
        self.fetchedResultsController = NSFetchedResultsController<Workout> (
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataManager.sharedInstance.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        self.fetchedResultsController.delegate = self
        
        self.filterHandweight((Any).self)

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        headerView.frame.size.height = self.view.frame.size.height > self.view.frame.size.width ? 65 : 80
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
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard fetchedResultsController != nil else {
            return 0
        }
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"videoCell", for: indexPath) as! VideoCell
        
        let workout = fetchedResultsController.object(at: indexPath)
        
        cell.buttonColor = (navigationController?.navigationBar.barTintColor)!
        cell.videoLabel?.text = workout.name
        
        cell.videoImageView?.image = UIImage(data:workout.icon! as Data, scale:1.0)
        cell.indexPath = indexPath
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showVideoSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVideoSegue" {
            
            if let viewController = segue.destination as? VideoPlayerViewController {
                
                let workout = fetchedResultsController.object(at: sender as! IndexPath)
                viewController.videoUrl = workout.videoUrl
            }
        }
    }

}

extension ExercisesTableViewController: VideoCellDelegate {
    
    func infoButtonTouched(_ sender: UIButton, indexPath: IndexPath, x: Int) {
        
        DispatchQueue.main.async {
            let rect = self.tableView.rectForRow(at: indexPath)
            
            let frame = sender.frame.offsetBy(dx: 0, dy: rect.origin.y)
            let tooltipWidth = frame.origin.x - CGFloat(x)
            
            self.popTip.bubbleColor = sender.backgroundColor!
            
            let workout = self.fetchedResultsController.object(at: indexPath)
            
            self.popTip.show(text: workout.descr!, direction: .left, maxWidth: tooltipWidth, in: self.view, from: frame, duration: 6)
        }
        
    }
}
