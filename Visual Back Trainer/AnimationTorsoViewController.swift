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
import CoreData

// Blender: export "obj" file and upload to Mixamo
// xmllint --format idle.dae > idleFixed.dae
// see https://blog.pusher.com/animating-3d-model-ar-arkit-mixamo/

class AnimationTorsoViewController: UIViewController, CAAnimationDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var sceneView: SCNView!
    var originalSceneView: SCNView!
    
    let popTip = PopTip()
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var animationButton: UIButton!
    @IBOutlet weak var infoButtonWidth: NSLayoutConstraint!
    
    

    
//    @IBOutlet weak var slider: UISlider! {
//        didSet {
//            slider.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
//            slider.setThumbImage(UIImage(named: "photolens"), for: .normal)
//            slider.tintColor = (navigationController?.navigationBar.barTintColor)!
//            slider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
//        }
//    }
    
    var cameraNode: SCNNode? = nil
    var cameraOrbit: SCNNode? = nil
    
    var yPos: CGFloat = 0.9
    var zPos: CGFloat = -5.2
    
    var animations = [String: CAAnimation]()
    var animationsMoveDict = [String: [CGFloat]]()
    
    var infoText: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        let fact:CGFloat = UI_USER_INTERFACE_IDIOM() == .pad ? 1.2 : 1.0
        infoButton.layer.cornerRadius = 0.5 * infoButtonWidth.constant * fact
        infoButton.backgroundColor = (navigationController?.navigationBar.barTintColor)!
        animationButton.tintColor = infoButton.backgroundColor

        self.setupSceneView()
 
        let move = SCNAction.moveBy(x: 0, y: yPos, z: zPos, duration: 1.4)
        let moveOnce = SCNAction.repeat(move, count: 1)
        cameraNode?.runAction(moveOnce)

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "ANIMATION_TITLE".localized()
        infoText = "ANIMATION_INFO_TEXT".localized()
        
        let backButton = UIBarButtonItem()
        backButton.title = "SYSTEM_BACK".localized()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    
    func setupSceneView() {
        let scene = SCNScene(named: "art.scnassets/Idle.dae")!
        sceneView.scene = scene
        sceneView.allowsCameraControl = true
        sceneView.antialiasingMode = .multisampling4X
        sceneView.isPlaying = true
        cameraNode = scene.rootNode.childNode(withName: "camera", recursively: true)
        cameraOrbit = SCNNode()
        cameraOrbit?.addChildNode(cameraNode!)
        sceneView.scene?.rootNode.addChildNode(cameraOrbit!)
        self.setColorsToMusclegroups()
    }
    
    func setColorsToMusclegroups() {
        
        var frontResult: [Musclegroup]!
        
        do {
            let fetchRequest = NSFetchRequest<Musclegroup>(entityName: "Musclegroup")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
            frontResult = try CoreDataManager.sharedInstance.managedObjectContext.fetch(fetchRequest)
            
        } catch let error {
            print ("fetch task failed", error)
        }
        
        for group in frontResult {
            let alias = group.alias
            let color = group.color?.colorFromString()
            let muscleNode = sceneView.scene?.rootNode.childNode(withName: alias!, recursively: true)
            muscleNode?.geometry?.firstMaterial?.diffuse.contents  = color
        }
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
        popTip.show(text: infoText!, direction: .down, maxWidth: 0.92*self.view.frame.size.width, in: self.view, from: sender.frame.offsetBy(dx: 40, dy: 100), duration: 10)
    }
    
    @IBAction func animationButtonTouched(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Action", message: "What should the model do?", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Pushups", style: .default) { (action:UIAlertAction) in
            let key = "pushups"
            self.loadAnimation(withKey: key, sceneName: "art.scnassets/\(key)", animationIdentifier: key, repeatCount: 6, autoreverses: false)
            self.animationsMoveDict[key] = [0.0, -0.7, 1.0]
            self.playAnimation(key: key)
        }
        
        let action2 = UIAlertAction(title: "Situps", style: .default) { (action:UIAlertAction) in
            let key = "situps"
            self.loadAnimation(withKey: key, sceneName: "art.scnassets/\(key)", animationIdentifier: key, repeatCount: 4, autoreverses: false)
            self.animationsMoveDict[key] = [0.0, -0.7, 1.0]
            self.playAnimation(key: key)
        }
        
        let action3 = UIAlertAction(title: "Burpee", style: .default) { (action:UIAlertAction) in
            let key = "burpee"
            self.loadAnimation(withKey: key, sceneName: "art.scnassets/\(key)", animationIdentifier: key, repeatCount: 3, autoreverses: false)
            self.animationsMoveDict[key] = [0.0, -0.3, 1.0]
            self.playAnimation(key: key)
        }
        
        let action4 = UIAlertAction(title: "Bicycle Crunch", style: .default) { (action:UIAlertAction) in
            let key = "bicycle"
            self.loadAnimation(withKey: key, sceneName: "art.scnassets/\(key)", animationIdentifier: key, repeatCount: 10, autoreverses: false)
            self.animationsMoveDict[key] = [0.0, -0.7, 1.0]
            self.playAnimation(key: key)
        }
        
        let action5 = UIAlertAction(title: "Running", style: .default) { (action:UIAlertAction) in
            let key = "running"
            self.loadAnimation(withKey: key, sceneName: "art.scnassets/\(key)", animationIdentifier: key, repeatCount: 14, autoreverses: false)
            self.animationsMoveDict[key] = [0.0, -0.3, 1.0]
            self.playAnimation(key: key)
        }
        
        let action6 = UIAlertAction(title: "Samba Dancing", style: .default) { (action:UIAlertAction) in
            let key = "samba"
            self.loadAnimation(withKey: key, sceneName: "art.scnassets/\(key)", animationIdentifier: key, repeatCount: 1, autoreverses: false)
            self.animationsMoveDict[key] = [0.0, -0.3, 1.0]
            self.playAnimation(key: key)
        }

 
        let cancelAction = UIAlertAction(title: "Abbrechen", style: .destructive) { (action:UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
        }

        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        alertController.addAction(action4)
        alertController.addAction(action5)
        alertController.addAction(action6)

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
        animation.setValue(key, forKey: "name")
        animation.delegate = self
        
        self.setupSceneView()
        
        let move = SCNAction.moveBy(x: 0, y: yPos, z: zPos, duration: 0.5)
        let moveOnce = SCNAction.repeat(move, count: 1)
        cameraNode?.runAction(moveOnce)

        sceneView.scene?.rootNode.addAnimation(animation, forKey: key)
    }
    
    func stopAnimation(key: String) {
        sceneView.scene?.rootNode.removeAnimation(forKey: key, blendOutDuration: CGFloat(0.5))
    }
    
    func animationDidStart(_ anim: CAAnimation) {
 
        sceneView.allowsCameraControl = false
        
        let key = anim.value(forKey: "name") as! String
        let x = animationsMoveDict[key]![0]
        let y = animationsMoveDict[key]![1]
        let z = animationsMoveDict[key]![2]
        
        let moveY = SCNAction.moveBy(x: x, y: y, z: z, duration: 1.4)
        let rotate = SCNAction.rotateBy(x: 0, y: CGFloat(2.0*Double.pi), z: 0, duration: TimeInterval(Float(anim.duration)*anim.repeatCount))
        let moveOnce = SCNAction.repeat(moveY, count: 1)
        let rotateOnce = SCNAction.repeat(rotate, count: 1)
        cameraNode?.runAction(moveOnce)
        cameraOrbit?.runAction(rotateOnce)
        animationButton.isEnabled = false
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        sceneView.allowsCameraControl = true
        
        let key = anim.value(forKey: "name") as! String
        let x = animationsMoveDict[key]![0]
        let y = animationsMoveDict[key]![1]
        let z = animationsMoveDict[key]![2]
        
        let moveY = SCNAction.moveBy(x: -x, y: -y, z: -z, duration: 1.4)
        let moveOnce = SCNAction.repeat(moveY, count: 1)
        cameraNode?.runAction(moveOnce)
        animationButton.isEnabled = true
    }
}
