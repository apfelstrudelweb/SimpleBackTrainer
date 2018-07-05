//
//  sutitleView.swift
//  Simple Back Trainer
//
//  Created by Ulrich Vormbrock on 17.06.18.
//  Copyright © 2018 Rookie. All rights reserved.
//

import UIKit

class InfoView: UIView {
    
    @IBInspectable var nibName:String?

    @IBOutlet weak var subtitleLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }
    
    func xibSetup() {
        
    }

}
