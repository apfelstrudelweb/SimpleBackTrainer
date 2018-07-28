//
//  HomeVC.swift
//  AKSwiftSlideMenu
//
//  Created by MAC-186 on 4/8/16.
//  Copyright © 2016 Kode. All rights reserved.
//

import UIKit
import CoreData
import SwiftSpinner
import Reachability

class MainMenuViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cellWidth : CGFloat!
    var flowLayout : UICollectionViewFlowLayout!
    
    var trainingModel = TrainingModel()
    
    let network = NetworkManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        
        self.trainingModel.delegate = self
        
        // for ADs
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: adsBottomSpace, right: 0)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Home"
        self.navigationController?.tabBarItem.title = "Home"
        
        self.tabBarController?.tabBar.isHidden = false
        
        do {
            let fetchRequest = NSFetchRequest<Trainingsplan>(entityName: "Trainingsplan")
            let count = try CoreDataManager.sharedInstance.managedObjectContext.count(for: fetchRequest)
            self.tabBarController?.tabBar.items![1].badgeColor = .red
            self.tabBarController?.tabBar.items![1].badgeValue = String(count)
            
        } catch let error {
            print ("fetch task failed", error)
        }
        
        let jsonLoaded = UserDefaults.standard.object(forKey: "jsonLoaded") as? Bool
        
        // TODO: handle interruption of network connection
        NetworkManager.isUnreachable { networkManagerInstance in
           
            if jsonLoaded == false {
                SwiftSpinner.hide()
                self.performSegue(withIdentifier: "NetworkUnavailableSegue", sender: self)
            }

        }
        
        NetworkManager.isReachable { networkManagerInstance in
            self.populateModel()
        }
    
    }
    
    func populateModel() {

        self.trainingModel.hasUpdates() { (success)  in
            
            if success == true {
                SwiftSpinner.setTitleFont(UIFont(name: "System", size: 16.0))
                SwiftSpinner.show("Übungs-Liste wird aktualisiert ...")
                
                self.trainingModel.getWorkouts { () in
                    SwiftSpinner.hide()
                    UserDefaults.standard.set(true, forKey: "jsonLoaded")
                }
                
                SwiftSpinner.setTitleFont(UIFont(name: "System", size: 16.0))
                SwiftSpinner.show("Trainingsplan wird erstellt ...")
                
                self.trainingModel.getTrainingsplan { () in
                    SwiftSpinner.hide()
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        if self.menuVC != nil {
            self.hamburgerButton?.tag = 0
            self.menuVC?.view.removeFromSuperview()
            self.menuVC?.removeFromParentViewController()
        }
    }
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = [
        ["title":NSLocalizedString("MAINMENU_BACK_FOR_ACTIVITIES", comment: ""), "icon":"gardener", "id":StoryboardId.activity.rawValue],
        ["title":NSLocalizedString("MAINMENU_BACK_FOR_SPORTS", comment: ""), "icon":"biker", "id":StoryboardId.sports.rawValue],
        ["title":NSLocalizedString("MAINMENU_BACK_MUSCLE_ANATOMY", comment: ""), "icon":"anatomy", "id":StoryboardId.anatomy.rawValue],
        ["title":NSLocalizedString("MAINMENU_BACK_TRAININGSPLAN", comment: ""), "icon":"trainingsplan", "id":StoryboardId.plan.rawValue],
        ["title":NSLocalizedString("MAINMENU_BACK_FOR_EXERCISES", comment: ""), "icon":"romanChair", "id":StoryboardId.exercise.rawValue],
        ["title":NSLocalizedString("MAINMENU_BACK_FOR_MOBILISATION", comment: ""), "icon":"cobra", "id":StoryboardId.mobilisation.rawValue],
        ["title":NSLocalizedString("MAINMENU_BACK_FOR_THERAPY", comment: ""), "icon":"sitting", "id":StoryboardId.backTherapy.rawValue],
        ["title":NSLocalizedString("MAINMENU_PREMIUM_VERSION", comment: ""), "icon":"pokal", "id":StoryboardId.premium.rawValue]
    ]
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numberOfItemsPerRow = UIScreen.main.bounds.height > UIScreen.main.bounds.width ? 2 : 3
        if UIDevice.current.userInterfaceIdiom == .pad {
            numberOfItemsPerRow *= 2
        }
        
        let margin = 0.08*UIScreen.main.bounds.width
        flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.minimumLineSpacing = 20
        flowLayout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin)
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
        let size = CGFloat((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
        
        let fact: CGFloat = 1//UIScreen.main.bounds.width > UIScreen.main.bounds.height ? 1.1 : 1.3
        
        return CGSize(width: size, height: fact*size)
    }
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ItemsCollectionViewCell
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            cell.label.font = cell.label.font.withSize(18)
        }
        
        cell.label.text = items[indexPath.row]["title"]!
        cell.imageView.image = UIImage(named: items[indexPath.row]["icon"]!)
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth = 1
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 25.0
        
        return cell
    }
    
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        let strIdentifier = self.items[indexPath.item]["id"]
        if strIdentifier == StoryboardId.premium.rawValue {
            self.tabBarController?.selectedIndex = 2
        } else if strIdentifier == StoryboardId.plan.rawValue {
            self.tabBarController?.selectedIndex = 1
        } else {
            guard let destViewController:UIViewController = self.storyboard?.instantiateViewController(withIdentifier: strIdentifier!) else {
                return
            }
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
        // self.navigationController?.present(destViewController, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as! CollectionHeaderView
        header.titleLabel.text = NSLocalizedString("MAINMENU_TITLE", comment: "")
        
        return header
    }
}


extension MainMenuViewController:TrainingModelDelegate {
    
    func didRetrieveTrainingsplan(exercises: [TrainingsplanData]) {
        CoreDataManager.sharedInstance.managedObjectContext.automaticallyMergesChangesFromParent = true
        
        CoreDataManager.sharedInstance.addToTrainingsplan(serverTrainingsplanData: exercises) { () in
            // View aktualisieren nachdem die Daten geladen wurden
            SwiftSpinner.hide()

            self.tabBarController?.tabBar.items![1].badgeValue = String(exercises.count)  
        }
    }
    
    func didRetrieveWorkouts(workouts: [WorkoutData]) {
        CoreDataManager.sharedInstance.managedObjectContext.automaticallyMergesChangesFromParent = true
        
        CoreDataManager.sharedInstance.updateWorkouts(serverWorkoutsData: workouts) { () in
            // View aktualisieren nachdem die Daten geladen wurden
            SwiftSpinner.hide()

            UserDefaults.standard.set(true, forKey: "jsonLoaded")
            UserDefaults.standard.synchronize()
        }
    }
    
    func showErrorMessage(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
