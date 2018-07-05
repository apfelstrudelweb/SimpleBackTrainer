//
//  UIColor+Custom.swift
//  Trainingsplan
//
//  Created by Rakesh Kumar on 19/05/18.
//  Copyright © 2018 Ulrich Vormbrock. All rights reserved.
//

import UIKit

extension UIColor {
    convenience public init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
    open class var theme: UIColor {
        return UIColor.init(r: 206, g: 66, b: 93, a: 1)
    }
    
    
}
