//
//  GradientView.swift
//  Simple Back Trainer
//
//  Created by Ulrich Vormbrock on 13.02.18.
//  Copyright © 2018 Kode. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    var gradientLayer: CAGradientLayer!
    
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.cornerRadius = 20
    }
    
    public func setColors(for colors: NSArray) {
        gradientLayer.colors = colors as? [Any]
    }
}
