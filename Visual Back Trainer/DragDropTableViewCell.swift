//
//  DragDropTableViewCell.swift
//  DragDropiOS-Example
//
//  Created by yuhan on 01/08/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import UIKit

class DragDropTableViewCell: UITableViewCell {

    static let cellIdentifier = "trainingsplanCell"
    
    @IBOutlet weak var contentImageView:UIImageView!
    @IBOutlet weak var contentLabel:UILabel!
    @IBOutlet weak var colorStripeView: UIView!
    
    var model:Workout!
    
    override func awakeFromNib() {
        backgroundColor = UIColor.white
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        self.selectionStyle = .none
    }

    
    func updateData(_ model:Workout){
        self.model = model
        if (model.membership?.count)! > 0 {
            selectedStatus()
            contentImageView.image = UIImage(named: model.imgName!)
            contentLabel.text = model.alias
        }else{
            nomoralStatus()
            contentImageView.image = nil
        }
    }
    
    func hasContent() -> Bool {
        return model != nil
    }
    
    func moveOverStatus(){
        backgroundColor = UIColor(red:0.52, green:0.66, blue:0.87, alpha:1.0)
    }
    
    func nomoralStatus(){
        backgroundColor = UIColor.white
    }
    
    func selectedStatus(){
        backgroundColor = UIColor(red:0.20, green:0.42, blue:0.73, alpha:1.0)
    }
    
}
