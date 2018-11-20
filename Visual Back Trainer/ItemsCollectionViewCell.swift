//
//  ItemsCollectionViewCell.swift
//  AKSwiftSlideMenu
//
//  Created by Ulrich Vormbrock on 12.02.18.
//

import UIKit

class ItemsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var labelLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var labelTrailingSpace: NSLayoutConstraint!
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        //label.font = UIFont(name: "System", size: 20)
//    }
}
