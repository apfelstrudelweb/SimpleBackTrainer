//
//  DragDropCollectionViewCell.swift
//
//  Created by rafael on 7/18/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class DragDropCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "musclegroupCell"
    
    @IBOutlet weak var imageView:UIImageView!
    
    var model:Workout!
    
    override func awakeFromNib() {
//        backgroundColor = UIColor.white
//        layer.borderColor = UIColor.gray.cgColor
//        layer.borderWidth = 0.5
    }
    
    
    func updateData(_ model:Workout){
        self.model = model
        if model.musclegroupId != nil {
            selectedStatus()
            imageView.image = UIImage(named: model.imgName!)
            imageView.layer.borderColor = UIColor.darkGray.cgColor
            imageView.layer.borderWidth = 1
        }else{
            nomoralStatus()
            
            imageView.image = nil
        }
    }
    
    func hasContent() -> Bool {
        //return model.musclegroupId != nil
        return true
    }
    
    func moveOverStatus(){
        //backgroundColor = UIColor.orange.withAlphaComponent(0.5)
    }
    
    func nomoralStatus(){
        //backgroundColor = UIColor.white
    }
    
    func selectedStatus(){
        //backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        //self.transform = CGAffineTransform(scaleX: 2, y: 2)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
//    }
    

}
