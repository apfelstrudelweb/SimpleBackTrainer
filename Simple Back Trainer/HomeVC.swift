//
//  HomeVC.swift
//  AKSwiftSlideMenu
//
//  Created by MAC-186 on 4/8/16.
//  Copyright © 2016 Kode. All rights reserved.
//

import UIKit

class HomeVC: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var cellWidth : CGFloat!
    var flowLayout : UICollectionViewFlowLayout!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.reloadData()
    }
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = [["title":"Starker Rücken für Berufe", "icon":"pictogramm"],["title":"Rückenmuskeln für Sportler", "icon":"pictogramm"],["title":"Trainings-Übungen", "icon":"pictogramm"],["title":"Mobilisierungs-Übungen", "icon":"pictogramm"],["title":"Trainingsplan", "icon":"pictogramm"],["title":"Rückenschule", "icon":"pictogramm"]]
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow = UIScreen.main.bounds.height > UIScreen.main.bounds.width ? 2 : 4

        flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20)
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
        var size = CGFloat((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
        
        if size > 200.0 {
            size = CGFloat(200)
        }
        
        flowLayout.itemSize = CGSize(width: size, height: 1.4*size)
        
        return CGSize(width: size, height: 1.4*size)
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
        cell.imageView.image = UIImage(named: items[indexPath.row]["icon"]!)
        
        var gradientColors: [CGColor]!
        
        switch indexPath.row {
        case 0: gradientColors = [UIColor.green.withAlphaComponent(1).cgColor, UIColor.green.withAlphaComponent(0.5).cgColor]
            break
        case 1: gradientColors = [UIColor.yellow.withAlphaComponent(1).cgColor, UIColor.yellow.withAlphaComponent(0.5).cgColor]
            break
        case 2: gradientColors = [UIColor.red.withAlphaComponent(1).cgColor, UIColor.red.withAlphaComponent(0.5).cgColor]
            break
        case 3: gradientColors = [UIColor.blue.withAlphaComponent(1).cgColor, UIColor.blue.withAlphaComponent(0.5).cgColor]
            break
        case 4: gradientColors = [UIColor.orange.withAlphaComponent(1).cgColor, UIColor.orange.withAlphaComponent(0.5).cgColor]
            break
        case 5: gradientColors = [UIColor.cyan.withAlphaComponent(1).cgColor, UIColor.cyan.withAlphaComponent(0.5).cgColor]
            break
        default:
            gradientColors = [UIColor.red.withAlphaComponent(1).cgColor, UIColor.red.withAlphaComponent(0.7).cgColor]
        }
        
        // remove previous layer after device rotation
        for layer in cell.gradientView.layer.sublayers! {
            if layer.isKind(of: CAGradientLayer.self) {
                layer.removeFromSuperlayer()
            }
        }
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        cell.gradientView.layer.addSublayer(gradientLayer)

        gradientLayer.zPosition = -1
        gradientLayer.cornerRadius = 20
        cell.gradientView.layer.cornerRadius = 20
        
        let cellSize = self.flowLayout.itemSize

        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: cellSize.width, height: cellSize.height/1.4)

        return cell
    }
    
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }

}
