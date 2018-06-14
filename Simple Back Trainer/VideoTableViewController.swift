//
//  VideoTableViewController.swift
//  sketchChanger
//
//  Created by Ulrich Vormbrock on 03.04.18.
//  Copyright © 2018 Ulrich Vormbrock. All rights reserved.
//

import UIKit
import AMPopTip
import CoreData

class VideoTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var muscleGroupColor: UIColor = .lightGray
    var muscleGroupId: Int = -1
    var popTip = PopTip()
    
    var fetchedResultsController: NSFetchedResultsController<Workout>!

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    

    override func viewDidLoad() {

        headerView.backgroundColor = muscleGroupColor
        headerLabel.text = String(muscleGroupId)  //self.title!//"Übungen für die Muskelgruppe \"\(String(describing: self.title!))\""
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: "videoCell")

        // TODO: make it generic
        popTip.font = UIFont(name: "Avenir-Medium", size: UI_USER_INTERFACE_IDIOM() == .pad ? 20 : 14)!
        popTip.shouldDismissOnTap = true
        popTip.shouldDismissOnTapOutside = true
        popTip.shouldDismissOnSwipeOutside = true
        popTip.edgeMargin = 5
        popTip.offset = 2
        popTip.bubbleOffset = 0
        popTip.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10)
        
        let fetchRequest = NSFetchRequest<Workout> (entityName: "Workout")
        fetchRequest.sortDescriptors = [NSSortDescriptor (key: "position", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "musclegroupId.id = %d", muscleGroupId)
        
        self.fetchedResultsController = NSFetchedResultsController<Workout> (
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataManager.sharedInstance.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        self.fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
    }
    

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
    
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"videoCell", for: indexPath) as! VideoCell
        
        let workout = fetchedResultsController.object(at: indexPath)
        
        cell.buttonColor = (navigationController?.navigationBar.barTintColor)!
        cell.videoLabel.text = workout.name
        
        cell.videoImageView.image = UIImage(data:workout.icon! as Data, scale:1.0)
        cell.indexPath = indexPath
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showVideoSegue", sender: indexPath)
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        popTip.hide()
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

extension VideoTableViewController: VideoCellDelegate {
    
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
