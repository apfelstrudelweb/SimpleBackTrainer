//
//  VideoCell.swift
//  sketchChanger
//
//  Created by Ulrich Vormbrock on 03.04.18.
//  Copyright © 2018 Ulrich Vormbrock. All rights reserved.
//

import UIKit

protocol VideoCellDelegate: class {
    func infoButtonTouched(_ sender: UIButton, indexPath: IndexPath, x: Int)
}

class VideoCell: UITableViewCell {
    
    weak var delegate:VideoCellDelegate?
    
    var buttonColor: UIColor = UIColor()

    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var videoLabel: UILabel!
    @IBOutlet weak var videoInfoButton: UIButton!
    
    var infoText: String = ""
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    var imageViewTrailing: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        videoInfoButton.layer.cornerRadius = 0.5*videoInfoButton.frame.size.width
    }
    
    @IBAction func infoButtonTouched(_ sender: UIButton) {
        
        sender.backgroundColor = videoInfoButton.backgroundColor
        imageViewTrailing = Int(videoImageView.frame.size.width - videoImageView.frame.origin.x)
        self.delegate?.infoButtonTouched(sender, indexPath: indexPath, x: imageViewTrailing)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        videoInfoButton.backgroundColor = buttonColor
    }
    
}
