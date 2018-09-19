//
//  AnimationTorsoViewController.swift
//  Visual Back Trainer
//
//  Created by Ulrich Vormbrock on 03.09.18.
//  Copyright © 2018 Rookie. All rights reserved.
//

import UIKit
import SceneKit
import AMPopTip

// Blender: export "obj" file and upload to Mixamo
// xmllint --format idle.dae > idleFixed.dae
// see https://blog.pusher.com/animating-3d-model-ar-arkit-mixamo/

class AnimationTorsoViewController: UIViewController, CAAnimationDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var sceneView: SCNView!
    
    let popTip = PopTip()
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var animationButton: UIButton!
//    @IBOutlet weak var slider: UISlider! {
//        didSet {
//            slider.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
//            slider.setThumbImage(UIImage(named: "photolens"), for: .normal)
//            slider.tintColor = (navigationController?.navigationBar.barTintColor)!
//            slider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
//        }
//    }
    
    var cameraNode: SCNNode? = nil
    var posY: Float = 0
    
    var animations = [String: CAAnimation]()
    
    let SCALE = 0.5

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Muskegruppen entdecken"
        
        infoButton.layer.cornerRadius = 0.5*infoButton.frame.size.width
        infoButton.backgroundColor = (navigationController?.navigationBar.barTintColor)!
        animationButton.tintColor = infoButton.backgroundColor
        
        let scene = SCNScene(named: "art.scnassets/Idle.dae")!

        sceneView.scene = scene
        sceneView.allowsCameraControl = true
        sceneView.antialiasingMode = .multisampling4X
        sceneView.isPlaying = true
        
        cameraNode = scene.rootNode.childNode(withName: "camera", recursively: true)
        cameraNode?.camera?.orthographicScale = SCALE
        posY = (sceneView.pointOfView?.position.y)!

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
     

        // Popup
        popTip.font = UIFont(name: "Avenir-Medium", size: UI_USER_INTERFACE_IDIOM() == .pad ? 22 : 18)!
        popTip.textAlignment = .center
        popTip.shouldDismissOnTap = true
        popTip.shouldDismissOnTapOutside = true
        popTip.shouldDismissOnSwipeOutside = true
        popTip.edgeMargin = 5
        popTip.offset = 2
        popTip.bubbleOffset = 0
        popTip.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10)
    }
    

    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: sceneView)
        let hitResults = sceneView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            
            for result in hitResults {
                if result.node.name != "Torso" {
                    
                    let dir:PopTipDirection = p.x < 0.5*sceneView.frame.size.width ? .right : .left
                    
                    let name = result.node.name
                    let infoText = NSLocalizedString(name!, comment: "")
                    popTip.bubbleColor = (navigationController?.navigationBar.barTintColor)!
                    popTip.show(text: infoText, direction: dir, maxWidth: 0.9*sceneView.frame.size.width, in: sceneView, from: CGRect(x: p.x, y: p.y, width: 0, height: 0), duration: 4)
                    
                    break
                }
            }
        }
    }
    
    @IBAction func infoButtonTouched(_ sender: UIButton) {
        popTip.bubbleColor = (navigationController?.navigationBar.barTintColor)!
        popTip.textAlignment = .left
        popTip.font = UIFont(name: "Avenir-Medium", size: UI_USER_INTERFACE_IDIOM() == .pad ? 20 : 16)!
        popTip.show(text: "Tipps:\n1) Pan with one finger to rotate the camera around the model.\n2) Pan with two fingers to move the camera.\n3) Pinch to zoom in or zoom out", direction: .down, maxWidth: 0.92*self.view.frame.size.width, in: self.view, from: sender.frame.offsetBy(dx: 40, dy: 100), duration: 8)
    }
    
    @IBAction func animationButtonTouched(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Action", message: "What should the model do?", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Pushups", style: .default) { (action:UIAlertAction) in
            self.loadAnimation(withKey: "pushups", sceneName: "art.scnassets/Pushups", animationIdentifier: "pushups", repeatCount: 4, autoreverses: true)
            self.playAnimation(key: "pushups")
        }
        
        let action2 = UIAlertAction(title: "Situps", style: .default) { (action:UIAlertAction) in
            self.loadAnimation(withKey: "situps", sceneName: "art.scnassets/Situps", animationIdentifier: "situps", repeatCount: 3, autoreverses: true)
            self.playAnimation(key: "situps")
        }
        
        let action3 = UIAlertAction(title: "Burpee", style: .default) { (action:UIAlertAction) in
            self.loadAnimation(withKey: "burpee", sceneName: "art.scnassets/Burpee", animationIdentifier: "burpee", repeatCount: 3, autoreverses: true)
            self.playAnimation(key: "burpee")
        }
 
        let cancelAction = UIAlertAction(title: "Abbrechen", style: .destructive) { (action:UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)

        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func loadAnimation(withKey: String, sceneName:String, animationIdentifier:String, repeatCount:Int, autoreverses:Bool) {
        let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: "dae")
        let sceneSource = SCNSceneSource(url: sceneURL!, options: nil)
        
        if let animationObject = sceneSource?.entryWithIdentifier(animationIdentifier, withClass: CAAnimation.self) {
            // The animation will only play once
            animationObject.repeatCount = Float(repeatCount)
            animationObject.autoreverses = autoreverses
            
            //animationObject.autoreverses = true
            // To create smooth transitions between animations
            animationObject.fadeInDuration = CGFloat(1)
            animationObject.fadeOutDuration = CGFloat(0.5)
            
            //animationObject.isRemovedOnCompletion = false
            
            // Store the animation for later use
            animations[withKey] = animationObject
        }
    }
    
    func playAnimation(key: String) {
        sceneView.scene?.rootNode.removeAllAnimations()
        let animation = self.animations[key]!
        animation.delegate = self
        sceneView.scene?.rootNode.addAnimation(animation, forKey: key)
    }
    
    func stopAnimation(key: String) {
        sceneView.scene?.rootNode.removeAnimation(forKey: key, blendOutDuration: CGFloat(0.5))
    }
    
    func animationDidStart(_ anim: CAAnimation) {
//        sceneView.allowsCameraControl = false
//        cameraNode?.camera?.orthographicScale = 1.0
//        sceneView.pointOfView?.position.y = posY - 0.5
        animationButton.isEnabled = false
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        sceneView.allowsCameraControl = true
//        cameraNode?.camera?.orthographicScale = SCALE
//        sceneView.pointOfView?.position.y = posY
        animationButton.isEnabled = true
    }
}
