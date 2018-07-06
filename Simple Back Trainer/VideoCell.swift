//
//  VideoCell.swift
//  sketchChanger
//
//  Created by Ulrich Vormbrock on 03.04.18.
//  Copyright © 2018 Ulrich Vormbrock. All rights reserved.
//

import UIKit

protocol VideoCellDelegate: class {
    func favoriteButtonTouched(_ sender: UIButton, indexPath: IndexPath, x: Int)
}

class VideoCell: UITableViewCell {
    
    weak var delegate:VideoCellDelegate?
    
    var buttonColor: UIColor = UIColor()
    var premiumImage = UIImage.init(named: "upgrade")?.withRenderingMode(.alwaysTemplate)
    var favoriteImage = UIImage.init(named: "favorite")?.withRenderingMode(.alwaysTemplate)

    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var videoLabel: UILabel!
   
    @IBOutlet weak var premiumImageView: UIImageView!
    
    @IBOutlet weak var favoriteDelimter: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var infoText: String = ""
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    var imageViewTrailing: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()

            premiumImageView.tintColor = .lightGray
        favoriteDelimter.tintColor = .lightGray
 favoriteButton.setImage(favoriteImage, for: .normal)
        favoriteButton.tintColor = .lightGray
    }
    
    @IBAction func favoriteButtonTouched(_ sender: UIButton) {
        
        imageViewTrailing = Int(videoImageView.frame.size.width - videoImageView.frame.origin.x)
        self.delegate?.favoriteButtonTouched(sender, indexPath: indexPath, x: imageViewTrailing)

    }
    
}
