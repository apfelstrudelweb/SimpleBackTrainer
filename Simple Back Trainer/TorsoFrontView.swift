//
//  TorsoFrontView.swift
//  sketchChanger
//
//  Created by Ulrich Vormbrock on 12.03.18.
//  Copyright © 2018 Ulrich Vormbrock. All rights reserved.
//

import UIKit
import SnapKit

protocol TorsoFrontViewDelegate: class {
    func updateFrontButton(index: Int, sender: TorsoFrontView)
    func resetFrontButton(sender: TorsoFrontView)
    func redirectFront(sender: TorsoFrontView)
}

@IBDesignable
class TorsoFrontView: TorsoBasicView, UIScrollViewDelegate {
    
    weak var delegate:TorsoFrontViewDelegate?
    
    var contentView:UIView?
    @IBInspectable var nibName:String?
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var basicImageView: UIImageView!
    @IBOutlet var imageViewCollection: [UIImageView]!
    @IBOutlet var labelCollection: [UILabel]!
    
    var frontView: FrontView = FrontView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }
    
    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        addSubview(view)
        
        // SnapKit
        view.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
        setAlpha(collection: imageViewCollection, alpha: 0)
        animationSetup(resetViews: true)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        basicImageView.isUserInteractionEnabled = true
        basicImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let labels = labelCollection.sorted { $0.tag < $1.tag }
        
        for (index, label) in labels.enumerated() {
            label.alpha = 0
            label.backgroundColor = frontView.dict[index]?.color
            label.text = frontView.dict[index]?.muscleName
            label.layer.cornerRadius = 5
        }
    }
    
    func loadViewFromNib() -> UIView? {
        guard let nibName = nibName else { return nil }
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }
    
    func switchChanged(animationActive: Bool) {
        let alpha: CGFloat = animationActive ? 0 : 1
        setAlpha(collection: imageViewCollection, alpha: alpha)
        
        if animationActive {
            animationSetup(resetViews: true)
        } else {
            timer.invalidate()
        }
    }
    
    
    public func stepperChanged(value: Float) {
        timeInterval = 6.0 - value
        animationSetup(resetViews: true)
    }
    
    public func animationSetup(resetViews: Bool) {
        
        resetZoomFactor()
        
        if resetViews {
            setAlpha(collection: imageViewCollection, alpha: 0)
            self.delegate?.resetFrontButton(sender: self)
        }
        
        timer.invalidate()
        counter = 0
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector: (#selector(TorsoFrontView.updateView)), userInfo: nil, repeats: true)
    }
    
    public func resetZoomFactor() {
        scrollView.zoomScale = 1
    }
    
    @objc func updateView() {
        
        let imageViews = imageViewCollection.sorted { $0.tag < $1.tag }
        
        let numImageViews = imageViews.count
        counter = counter % numImageViews
        
        for index in 0...numImageViews-1 {
            
            if (counter == index) {
                UIView.animate(withDuration: TimeInterval(0.5*timeInterval), animations: {
                    imageViews[index].alpha = 1
                    self.delegate?.updateFrontButton(index: index, sender: self)
                }, completion: { (finished: Bool) in
                })
                UIView.animate(withDuration: TimeInterval(timeInterval), animations: {
                    let secondIndex = (index + numImageViews-1) % numImageViews
                    imageViews[secondIndex].alpha = 0
                })
                break
            }
        }
        counter += 1
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let point = tapGestureRecognizer.location(in: tapGestureRecognizer.view)
        let w = tapGestureRecognizer.view?.frame.size.width
        let h = tapGestureRecognizer.view?.frame.size.height
        
        let relativePoint = CGPoint(x: point.x/w!, y: point.y/h!)
        //print(relativePoint)
        
        frontView.dict.forEach {
            let torso = $0.value
            if torso.tapArea.contains(relativePoint) {
                tappedMuscleGroupName = torso.muscleName
                tappedMuscleGroupColor = torso.color
                self.delegate?.redirectFront(sender: self)
            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return containerView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        labelCollection.forEach {
            $0.alpha = scrollView.zoomScale > 2 ? 1 : 0
        }
    }
    
}
