//
//  String+Custom.swift
//  Trainingsplan
//
//  Created by Rakesh Kumar on 19/05/18.
//  Copyright © 2018 Ulrich Vormbrock. All rights reserved.
//

import UIKit

extension String {
    
    public func colorFromString() -> UIColor {
        let rgbValues = self.components(separatedBy: ",")
        if rgbValues.count == 3 {
            let r = rgbValues[0].toCGFloat()
            let g = rgbValues[1].toCGFloat()
            let b = rgbValues[2].toCGFloat()
            return UIColor.init(r: r, g: g, b: b, a: 1)
        }
        return UIColor.white
    }
    
    
    func toCGFloat() -> CGFloat {
        return CGFloat(exactly: self.toNumber()) ?? 0.0
    }
    
    func toNumber() -> NSNumber {
        guard let number = NumberFormatter().number(from: self) else {
            return 0
        }
        return number
    }
}
