//
//  TorsoBasicView.swift
//  sketchChanger
//
//  Created by Ulrich Vormbrock on 31.03.18.
//  Copyright © 2018 Ulrich Vormbrock. All rights reserved.
//

import UIKit

class TorsoBasicView: UIView {
    
    var tappedMuscleGroupName: String = ""
    var tappedMuscleGroupColor: UIColor = .lightGray
    var muscleGroupId: Int = -1
    
    var counter: Int = 0
    var timeInterval: Float = 2.0
    var timer: Timer = Timer()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setAlpha(collection: [UIImageView], alpha: CGFloat) {
        
        for imageView in collection {
            imageView.alpha = alpha
            //imageView.layer.shouldRasterize = true
        }
    }
}

class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 5.0
    @IBInspectable var rightInset: CGFloat = 5.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}
