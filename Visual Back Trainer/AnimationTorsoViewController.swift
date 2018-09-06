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

class AnimationTorsoViewController: UIViewController {

    @IBOutlet weak var sceneView: SCNView!
    
    let popTip = PopTip()
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var animationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Muskelgruppen entdecken"
        
        infoButton.layer.cornerRadius = 0.5*infoButton.frame.size.width
        infoButton.backgroundColor = (navigationController?.navigationBar.barTintColor)!
        animationButton.tintColor = infoButton.backgroundColor

        let scene = SCNScene(named: "art.scnassets/Idle.dae")!
        sceneView.scene = scene
        sceneView.allowsCameraControl = true
        sceneView.antialiasingMode = .multisampling4X
        
        //let camera = sceneView.scene?.rootNode.camera
        //camera?.fieldOfView = (camera?.fieldOfView)! - 200
        
//        let move = CABasicAnimation(keyPath: "position.z")
//        move.byValue  = 0.9
//        move.duration = 1.0
//        self.sceneView.pointOfView?.addAnimation(move, forKey: "slide right")
        
//        self.sceneView.pointOfView?.position.y = 1.2
//        self.sceneView.pointOfView?.position.z = 0.9

        
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
        
        let alertController = UIAlertController(title: "Action", message: "Welche Bewegung soll das Model ausführen?", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Capoeira", style: .default) { (action:UIAlertAction) in
            
        }
        
        let action2 = UIAlertAction(title: "Samba", style: .default) { (action:UIAlertAction) in
          
        }
        
        let action3 = UIAlertAction(title: "Liegestützen", style: .default) { (action:UIAlertAction) in
            
        }
        
        let action4 = UIAlertAction(title: "Situps", style: .default) { (action:UIAlertAction) in
       
        }
        
        let action5 = UIAlertAction(title: "Burpees", style: .default) { (action:UIAlertAction) in
         
        }
        
        let action6 = UIAlertAction(title: "Abbrechen", style: .destructive) { (action:UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        alertController.addAction(action4)
        alertController.addAction(action5)
        alertController.addAction(action6)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
}
