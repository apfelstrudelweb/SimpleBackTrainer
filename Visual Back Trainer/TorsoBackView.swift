//
//  TorsoBackView.swift
//
//
//  Created by Ulrich Vormbrock on 12.03.18.
//

import UIKit
import SnapKit

protocol TorsoBackViewDelegate: class {
    func updateBackButton(index: Int, sender: TorsoBackView)
    func resetBackButton(sender: TorsoBackView)
    func redirectBack(sender: TorsoBackView)
}

@IBDesignable
class TorsoBackView: TorsoBasicView, UIScrollViewDelegate {
    
    weak var delegate:TorsoBackViewDelegate?
    
    @IBInspectable var nibName:String?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet public weak var basicImageView: UIImageView!
    @IBOutlet var imageViewCollection: [MuscleGroupImageView]!
    @IBOutlet var labelCollection: [UILabel]!
    
    var backView: BackView = BackView()
    
    
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
        let images = imageViewCollection.sorted { $0.tag < $1.tag }
        
        for (index, imageView) in images.enumerated() {
            imageView.tintColor = backView.dict[index].color
            imageView.muscleGroupId = backView.dict[index].index
            
            labels[index].alpha = 0
            labels[index].backgroundColor = backView.dict[index].color
            labels[index].text = backView.dict[index].muscleName
            labels[index].layer.cornerRadius = 5
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
            self.delegate?.resetBackButton(sender: self)
        }
        
        timer.invalidate()
        counter = 0
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector: (#selector(TorsoBackView.updateView)), userInfo: nil, repeats: true)
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
                    self.delegate?.updateBackButton(index: index, sender: self)
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
        print(relativePoint)
        
        backView.dict.forEach {
            let torso = $0
            if torso.tapArea.contains(relativePoint) {
                tappedMuscleGroupName = torso.muscleName
                tappedMuscleGroupColor = torso.color
                muscleGroupId = torso.index
                
                self.delegate?.redirectBack(sender: self)
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
