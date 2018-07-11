//
//  DecorationCollectionViewFlowLayout.swift
//  Trainingsplan
//
//  Created by Ulrich Vormbrock on 09.04.18.
//  Copyright © 2018 Ulrich Vormbrock. All rights reserved.
//

import UIKit

class DecorationCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: Properties
    
    var decorationAttributes: [NSIndexPath: UICollectionViewLayoutAttributes]
    var sectionsWidthOrHeight: [NSIndexPath: CGFloat]
    
    // MARK: Initialization
    
    override init() {
        self.decorationAttributes = [:]
        self.sectionsWidthOrHeight = [:]
        
        super.init()
        
        self.register(ApplicationBackgroundCollectionReusableView.self, forDecorationViewOfKind: ApplicationBackgroundCollectionReusableView.kind())
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.decorationAttributes = [:]
        self.sectionsWidthOrHeight = [:]
        
        super.init(coder: aDecoder)
        
        self.register(ApplicationBackgroundCollectionReusableView.self, forDecorationViewOfKind: ApplicationBackgroundCollectionReusableView.kind())
    }
    
    // MARK: Providing Layout Attributes
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.decorationAttributes[indexPath as NSIndexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = super.layoutAttributesForElements(in: rect)
        let numberOfSections = self.collectionView!.numberOfSections
        var xOrYOffset = 0 as CGFloat
        
        for sectionNumber in 0 ..< numberOfSections {
            let indexPath = IndexPath(row: 0, section: sectionNumber)
            let sectionWidthOrHeight = self.sectionsWidthOrHeight[indexPath as NSIndexPath]!
            let decorationAttribute = UICollectionViewLayoutAttributes(forDecorationViewOfKind: ApplicationBackgroundCollectionReusableView.kind(), with: indexPath)
            decorationAttribute.zIndex = -1
            
            if self.scrollDirection == .vertical {
                decorationAttribute.frame = CGRect(x: 0, y: xOrYOffset, width: self.collectionViewContentSize.width, height: sectionWidthOrHeight)
            } else {
                decorationAttribute.frame = CGRect(x: xOrYOffset, y: 0, width: sectionWidthOrHeight, height: self.collectionViewContentSize.height)
            }
            
            xOrYOffset += sectionWidthOrHeight
            
            attributes?.append(decorationAttribute)
            self.decorationAttributes[indexPath as NSIndexPath] = decorationAttribute
        }
        
        return attributes
    }
    
    override func prepare() {
        super.prepare()
        
        guard self.collectionView != nil else { return }
        
        if self.scrollDirection == .vertical {
            let collectionViewWidthAvailableForCells = self.collectionViewContentSize.width - self.sectionInset.left - self.sectionInset.right
            let numberMaxOfCellsPerRow = floorf(Float((collectionViewWidthAvailableForCells + self.minimumInteritemSpacing) / (self.itemSize.width + self.minimumInteritemSpacing)))
            let numberOfSections = self.collectionView!.numberOfSections
            
            for sectionNumber in 0 ..< numberOfSections {
                let numberOfCells = Float(self.collectionView!.numberOfItems(inSection: sectionNumber))
                let numberOfRows = CGFloat(ceilf(numberOfCells / numberMaxOfCellsPerRow))
                let sectionHeight = (numberOfRows * self.itemSize.height) + ((numberOfRows - 1) * self.minimumLineSpacing) + self.headerReferenceSize.height + self.footerReferenceSize.height + self.sectionInset.bottom + self.sectionInset.top
                
                self.sectionsWidthOrHeight[NSIndexPath(row: 0, section: sectionNumber)] = sectionHeight
            }
        } else {
            let collectionViewHeightAvailableForCells = self.collectionViewContentSize.height - self.sectionInset.top - self.sectionInset.bottom
            let numberMaxOfCellsPerColumn = floorf(Float((collectionViewHeightAvailableForCells + self.minimumInteritemSpacing) / (self.itemSize.height + self.minimumInteritemSpacing)))
            let numberOfSections = self.collectionView!.numberOfSections
            
            for sectionNumber in 0 ..< numberOfSections {
                let numberOfCells = Float(self.collectionView!.numberOfItems(inSection: sectionNumber))
                let numberOfColumns = CGFloat(ceilf(numberOfCells / numberMaxOfCellsPerColumn))
                let sectionWidth = (numberOfColumns * self.itemSize.width) + ((numberOfColumns - 1) * self.minimumLineSpacing) + self.headerReferenceSize.width + self.footerReferenceSize.width + self.sectionInset.left + self.sectionInset.right
                
                self.sectionsWidthOrHeight[NSIndexPath(row: 0, section: sectionNumber)] = sectionWidth
            }
        }
    }
}
