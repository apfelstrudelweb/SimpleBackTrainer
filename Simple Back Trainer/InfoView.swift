//
//  InfoView.swift
//  Simple Back Trainer
//
//  Created by Ulrich Vormbrock on 17.06.18.
//  Copyright © 2018 Rookie. All rights reserved.
//

import UIKit

class InfoView: UIView {

    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var watermark: UIImageView!
    
    @IBOutlet weak var stripeView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }
    
    func xibSetup() {
        
        stripeView.backgroundColor = UIColor(patternImage: UIImage(named: "stripe.png")!)
        watermark.layer.cornerRadius = 0.15*watermark.frame.size.width
        
    }

}
