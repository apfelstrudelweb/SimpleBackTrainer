//
//  GenericTableViewController.swift
//  Visual Back Trainer
//
//  Created by Ulrich Vormbrock on 28.06.18.
//  Copyright © 2018 Rookie. All rights reserved.
//

import UIKit
import AMPopTip
import CoreData

class GenericTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var muscleGroupId: Int = 1
    var popTip = PopTip()
    var fetchedResultsController: NSFetchedResultsController<Workout>!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        popTip.font = UIFont(name: "Avenir-Medium", size: UI_USER_INTERFACE_IDIOM() == .pad ? 22 : 18)!
        popTip.shouldDismissOnTap = true
        popTip.shouldDismissOnTapOutside = true
        popTip.shouldDismissOnSwipeOutside = true
        popTip.edgeMargin = 5
        popTip.offset = 2
        popTip.bubbleOffset = 0
        popTip.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10)
        
        self.tableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: "videoCell")
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 10
 

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
        
        if workout.isPremium {
            cell.premiumImageView.isHidden = false
            cell.favoriteButton.isHidden = true
            cell.favoriteDelimter.isHidden = true
            cell.videoImageView?.alpha = 0.5
        } else {
            cell.premiumImageView.isHidden = true
            cell.favoriteButton.isHidden = false
            cell.favoriteDelimter.isHidden = false
            cell.videoImageView?.alpha = 1.0
        }
        
        
        let favoriteImage = workout.isFavorite ? UIImage(named: "favoriteAdded") : UIImage(named: "favorite")
        
        cell.favoriteButton.setImage(favoriteImage, for: .normal)
        
        // Test
        if workout.isFavorite {
            cell.favoriteButton.tintColor = UIColor(red: 0.302, green: 0.698, blue: 0, alpha: 1.0)
        } else {
            cell.favoriteButton.tintColor = .lightGray
        }
        
        
        cell.buttonColor = (navigationController?.navigationBar.barTintColor)!
        cell.videoLabel.text = workout.alias // TODO: localize
        
        cell.videoImageView.image = UIImage(data:workout.icon! as Data, scale:1.0)
        cell.indexPath = indexPath
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let workout = fetchedResultsController.object(at: indexPath)
        
        if workout.isPremium {
            performSegue(withIdentifier: "showUpgradeSegue", sender: indexPath)
        } else {
            performSegue(withIdentifier: "showVideoSegue", sender: indexPath)
        }
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        popTip.hide()
        

        coordinator.animate(alongsideTransition: nil, completion: { _ in
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            self.tableView.layoutIfNeeded()
            //self.tableView.reloadData()
        })
    }
    

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVideoSegue" {
            
            if let viewController = segue.destination as? VideoPlayerViewController {
                
                let workout = fetchedResultsController.object(at: sender as! IndexPath)
                viewController.videoUrl = workout.videoUrl
            }
        } else if segue.identifier == "showUpgradeSegue" {
            if let viewController = segue.destination as? PremiumViewController {
                viewController.calledFromVideolist = true
            }
        }
    }
}

extension GenericTableViewController: VideoCellDelegate {
    
    func favoriteButtonTouched(_ sender: UIButton, indexPath: IndexPath, x: Int) {
        
        DispatchQueue.main.async {
            let rect = self.tableView.rectForRow(at: indexPath)
            
            let frame = sender.frame.offsetBy(dx: 0, dy: rect.origin.y)
            let tooltipWidth = frame.origin.x - CGFloat(x)
            
            self.popTip.bubbleColor = (self.navigationController?.navigationBar.barTintColor)!
            
            let workout = self.fetchedResultsController.object(at: indexPath)
            
            let infoText = workout.isFavorite ? "Diese Übung wurde vom Trainingsplan entfernt." : "Diese Übung wurde als Favorit markiert und erscheint nun im Trainingsplan."
            
            self.popTip.show(text: infoText, direction: .left, maxWidth: tooltipWidth, in: self.view, from: frame, duration: 3)
            
            workout.isFavorite = !workout.isFavorite
            
            do {
                try CoreDataManager.sharedInstance.managedObjectContext.save()
            } catch let error {
                print("Failure to save context: \(error.localizedDescription)")
            }
            self.tableView.reloadData()
            
        }
        
    }
}
