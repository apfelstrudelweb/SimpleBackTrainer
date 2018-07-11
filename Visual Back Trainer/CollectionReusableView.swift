//
//  CollectionReusableView.swift
//  Trainingsplan
//
//  Created by Ulrich Vormbrock on 09.04.18.
//  Copyright © 2018 Ulrich Vormbrock. All rights reserved.
//

import UIKit

class CollectionReusableView: UICollectionReusableView {
        
}

class ApplicationHeaderCollectionReusableView: CollectionReusableView {
    
    // MARK: Properties
    
    @IBOutlet var titleLabel: UILabel!
     
}


class ApplicationBackgroundCollectionReusableView: CollectionReusableView {
    
    // MARK: Class Methods
    
    class func kind() -> String {
        return "ApplicationBackgroundCollectionReusableView"
    }
    
    // MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    // MARK: Setup
    
    func setup() {
        self.backgroundColor = UIColor.clear
    }

}
