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
        let numberOfItemsPerRow = UIScreen.main.bounds.height > UIScreen.main.bounds.width ? 2 : 3

        let margin = 0.1*UIScreen.main.bounds.width
        flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin)
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
        var size = CGFloat((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
        
        if size > 200.0 {
            size = 200.0
        }
        
        var fact : CGFloat = 1.4
        
        if UIScreen.main.bounds.height < 800.0 {
            fact += (812.0 / UIScreen.main.bounds.height)
            fact -= 1.0
        }
        
        flowLayout.itemSize = CGSize(width: size, height: fact*size)
        
        return flowLayout.itemSize
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
        
        let cellSize = self.flowLayout.itemSize
        cell.label.text = items[indexPath.row]["title"]!
        
        //cell.label.fitTextToBounds(for: CGRect(x: 0, y: 0, width: cellSize.width, height: cellSize.width / 1.8))


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

        gradientLayer.frame = CGRect(x: 0, y: 0, width: cellSize.width, height: cellSize.width)

        return cell
    }
    
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }

}

extension UIFont {
    
    /**
     Will return the best approximated font size which will fit in the bounds.
     If no font with name `fontName` could be found, nil is returned.
     */
    static func bestFitFontSize(for text: String, in bounds: CGRect, fontName: String) -> CGFloat? {
        var maxFontSize: CGFloat = 32.0 // UIKit best renders with factors of 2
        guard let maxFont = UIFont(name: fontName, size: maxFontSize) else {
            return nil
        }
        
        let textWidth = text.width(withConstraintedHeight: bounds.height, font: maxFont)
        let textHeight = text.height(withConstrainedWidth: bounds.width, font: maxFont)
        
        // Determine the font scaling factor that should allow the string to fit in the given rect
        let scalingFactor = min(bounds.width / textWidth, bounds.height / textHeight)
        
        // Adjust font size
        maxFontSize *= scalingFactor
        
        return floor(maxFontSize)
    }
}

extension UILabel {
    
    /// Will auto resize the contained text to a font size which fits the frames bounds
    /// Uses the pre-set font to dynamicly determine the proper sizing
    func fitTextToBounds(for rect: CGRect) {
        guard let text = text, let currentFont = font else { return }
        
        if let dynamicFontSize = UIFont.bestFitFontSize(for: text, in: rect, fontName: currentFont.fontName) {
            font = UIFont(name: currentFont.fontName, size: dynamicFontSize)
        }
    }
    
}

fileprivate extension String {
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
