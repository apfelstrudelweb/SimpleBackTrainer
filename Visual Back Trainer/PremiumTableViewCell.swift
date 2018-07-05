//
//  PremiumTableViewCell.swift
//  Simple Back Trainer
//
//  Created by Ulrich Vormbrock on 05.06.18.
//  Copyright © 2018 Kode. All rights reserved.
//

import UIKit

class PremiumTableViewCell: UITableViewCell {


    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
