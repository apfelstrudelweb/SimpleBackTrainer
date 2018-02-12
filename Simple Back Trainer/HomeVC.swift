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
    var gradientLayerArray = [CAGradientLayer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()

        let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout // If you create collectionView programmatically then just create this flow by UICollectionViewFlowLayout() and init a collectionView by this flow.
        
        let itemSpacing: CGFloat = 40
        let itemsInOneLine: CGFloat = 2
        flow.sectionInset = UIEdgeInsetsMake(0, 40, 0, 40)
        cellWidth = self.collectionView.bounds.width - itemSpacing * CGFloat(itemsInOneLine - 1) - flow.sectionInset.left - flow.sectionInset.right //
        flow.itemSize = CGSize(width: floor(cellWidth/itemsInOneLine), height: 1.4*cellWidth/itemsInOneLine)
        flow.minimumInteritemSpacing = 40
        flow.minimumLineSpacing = 20
    }
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = [["title":"Starker Rücken für Berufe", "icon":"pictogramm"],["title":"Rückenmuskeln für Sportler", "icon":"pictogramm"],["title":"Trainings-Übungen", "icon":"pictogramm"],["title":"Mobilisierungs-Übungen", "icon":"pictogramm"],["title":"Trainingsplan", "icon":"pictogramm"],["title":"Rückenschule", "icon":"pictogramm"]]
    
    
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
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        cell.gradientView.layer.addSublayer(gradientLayer)

        //gradientLayer.frame = CGRect(x: 0, y: 0, width: 0.8*cellWidth, height: 0.5*cellWidth)
        gradientLayer.zPosition = -1
        gradientLayer.masksToBounds = true
        gradientLayer.cornerRadius = 20
        cell.gradientView.layer.cornerRadius = 20
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 0.5*cellWidth, height: 0.5*cellWidth)
        //gradientLayerArray.append(gradientLayer)

        return cell
    }
    
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
//    override func viewDidLayoutSubviews() {
//        for layer in gradientLayerArray {
//            layer.frame = CGRect(x: 0, y: 0, width: 0.5*cellWidth, height: 0.5*cellWidth)
//
//        }
//    }


}
