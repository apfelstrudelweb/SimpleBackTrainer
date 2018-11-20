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
    
    var idealFontSize: CGFloat?
    
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
        super.viewWillAppear(animated)
        self.title = "TABBAR_HOME".localized()
        
        self.tabBarController?.tabBar.items![0].title = "TABBAR_HOME".localized()
        self.tabBarController?.tabBar.items![1].title = "TABBAR_PLAN".localized()
        self.tabBarController?.tabBar.items![2].title = "TABBAR_PREMIUM".localized()
        self.tabBarController?.tabBar.items![3].title = "TABBAR_SETTINGS".localized()
        
        items = [
            ["title":"MAINMENU_BACK_FOR_ACTIVITIES".localized(), "icon":"gardener", "id":StoryboardId.activity.rawValue],
            ["title":"MAINMENU_BACK_FOR_SPORTS".localized(), "icon":"biker", "id":StoryboardId.sports.rawValue],
            ["title":"MAINMENU_BACK_MUSCLE_ANATOMY".localized(), "icon":"anatomy", "id":StoryboardId.anatomy.rawValue],
            ["title":"MAINMENU_BACK_TRAININGSPLAN".localized(), "icon":"trainingsplan", "id":StoryboardId.plan.rawValue],
            ["title":"MAINMENU_BACK_FOR_EXERCISES".localized(), "icon":"romanChair", "id":StoryboardId.exercise.rawValue],
            ["title":"MAINMENU_BACK_FOR_MOBILISATION".localized(), "icon":"cobra", "id":StoryboardId.mobilisation.rawValue],
            ["title":"MAINMENU_BACK_FOR_THERAPY".localized(), "icon":"sitting", "id":StoryboardId.backTherapy.rawValue],
            ["title":"MAINMENU_PREMIUM_VERSION".localized(), "icon":"pokal", "id":StoryboardId.premium.rawValue]
        ]

        var numberOfItemsPerRow = UIScreen.main.bounds.height > UIScreen.main.bounds.width ? 2 : 3
        if UIDevice.current.userInterfaceIdiom == .pad {
            numberOfItemsPerRow *= 2
        }
        
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
        
        self.collectionView.reloadData()
    
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.reloadData()
    }
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items: [[String : String]] = []

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numberOfItemsPerRow = UIScreen.main.bounds.height > UIScreen.main.bounds.width ? 2 : 3
        if UIDevice.current.userInterfaceIdiom == .pad {
            numberOfItemsPerRow = UIScreen.main.bounds.height > UIScreen.main.bounds.width ? 3 : 4
        }

        let margin: CGFloat = 0.06*UIScreen.main.bounds.width
        flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin)
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))

        let size = floor(CGFloat((collectionView.bounds.size.width - totalSpace) / CGFloat(numberOfItemsPerRow)))

        // do the calculation only once
        if indexPath.row == 0 {
            let representativeCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: IndexPath(item: 0, section: indexPath.section)) as! ItemsCollectionViewCell
            let margins = representativeCell.labelLeadingSpace.constant + representativeCell.labelTrailingSpace.constant
            
            let labelMaxWidth = size - margins
            let labelMaxHeight = floor(0.25 * size)
            print(labelMaxHeight)

            if let maxCharLen = items[0].max(by: {$1.value.count > $0.value.count}) {
                representativeCell.label.text = maxCharLen.value
                idealFontSize = representativeCell.label.getFittingFontSize(maxWidth: labelMaxWidth, maxHeight: labelMaxHeight)
            }
        }

        return CGSize(width: size, height: size)
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

        cell.label.text = items[indexPath.row]["title"]!
        
        if let fontSize = idealFontSize {
            DispatchQueue.main.async {
                cell.label.font = cell.label.font.withSize(fontSize)
            }
        }

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
        header.titleLabel.text = "MAINMENU_TITLE".localized()
        
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

extension UILabel {
    
    func getFittingFontSize(maxWidth: CGFloat, maxHeight: CGFloat) -> CGFloat {

        // we need it for device rotation
        self.frame = CGRect(x: 0, y: 0, width: 1.5*maxWidth, height: 1.5*maxHeight)
        
        var size: CGFloat = 20

        while self.frame.size.height > maxHeight{
            self.font = self.font.withSize(size)
            self.sizeToFit()
            size -= 0.5
        }
        
//        let spaceCount = CGFloat(self.text!.filter{$0 == " "}.count)
//        let charCount = CGFloat(self.text!.count)
//        let ratio = CGFloat((charCount - spaceCount) / charCount)
//
//        while self.frame.size.width > maxWidth  {
//            self.font = self.font.withSize(size)
//            self.sizeToFit()
//            size -= 0.5
//        }

        print(self.intrinsicContentSize.width )
        print(maxWidth)
        print(size)
        
        return size
    }
}
