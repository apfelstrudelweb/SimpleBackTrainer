//
//  MasterViewController.swift
//
//
//  Created by Ulrich Vormbrock on 12.03.18.
//

import UIKit
import AMPopTip


enum DisplayMode {
    case regularBack
    case regularFront
    case largeBack
    case largeFront
    case regularTwo
}

class AnatomyViewController: UIViewController {
    
    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var torsoBackView: TorsoBackView!
    @IBOutlet weak var torsoFrontView: TorsoFrontView!
    @IBOutlet weak var backViewButton: UIButton!
    @IBOutlet weak var frontViewButton: UIButton!
    
    @IBOutlet weak var torsoBackViewLarge: TorsoBackView!
    @IBOutlet weak var torsoFrontViewLarge: TorsoFrontView!
    
    @IBOutlet weak var frontViewButtonLarge: UIButton!
    @IBOutlet weak var backViewButtonLarge: UIButton!
    
    @IBOutlet weak var switchShowBothSides: UISwitch!
    @IBOutlet weak var switchBodySideControl: UISegmentedControl!
    
    @IBOutlet weak var switchAnimation: UISwitch!
    @IBOutlet weak var controlViewTop: NSLayoutConstraint!
    
    
    @IBOutlet weak var controlView: UIView!
    
    @IBOutlet weak var animationTopSpace: NSLayoutConstraint!
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    @IBOutlet weak var largeButtonHeight: NSLayoutConstraint!
    
    let popTip = PopTip()
    
    var displayMode: DisplayMode = .regularBack
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .white
        
        handleDeviceOrientation()
        
        frontViewButton.layer.cornerRadius = 10
        backViewButton.layer.cornerRadius = 10
        frontViewButtonLarge.layer.cornerRadius = 10
        backViewButtonLarge.layer.cornerRadius = 10
        
        torsoFrontView.delegate = self
        torsoBackView.delegate = self
        torsoFrontViewLarge.delegate = self
        torsoBackViewLarge.delegate = self
        
        infoButton.layer.cornerRadius = 0.5*infoButton.frame.size.width
        
        popTip.font = UIFont(name: "Avenir-Medium", size: UI_USER_INTERFACE_IDIOM() == .pad ? 20 : 14)!
        popTip.shouldDismissOnTap = true
        popTip.shouldDismissOnTapOutside = true
        popTip.shouldDismissOnSwipeOutside = true
        popTip.edgeMargin = 5
        popTip.offset = 2
        popTip.bubbleOffset = 0
        popTip.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10)
        
    }
    
    @IBAction func infoButtonTouched(_ sender: UIButton) {
        popTip.bubbleColor = infoButton.backgroundColor!
        popTip.show(text: "Tipp:\nSie können in das Bild hineinzoomen, indem Sie es mit zwei Fingern 'auseinanderziehen'. Wenn Sie weit genug hineinzoomen, erscheinen außerdem die Bezeichnungen zu den einzelnen Muskelgruppen.", direction: .left, maxWidth: 0.7*torsoFrontView.frame.size.width, in: self.view, from: sender.frame, duration: 6)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        popTip.hide()
        handleDeviceOrientation()
    }
    
    @IBAction func switchAnimationChanged(_ sender: UISwitch) {
        
        weak var weakself = self
        
        DispatchQueue.global().async {
            DispatchQueue.main.async(execute: {
                weakself?.buttonHeight.constant = sender.isOn ? 44 : 0
                weakself?.largeButtonHeight.constant = sender.isOn ? 50 : 0
                
                weakself?.torsoBackView.switchChanged(animationActive: sender.isOn)
                weakself?.torsoFrontView.switchChanged(animationActive: sender.isOn)
                
                weakself?.torsoBackViewLarge.switchChanged(animationActive: sender.isOn)
                weakself?.torsoFrontViewLarge.switchChanged(animationActive: sender.isOn)
            })
        }
    }
    
    
    
    @IBAction func switchBothSidesChanged(_ sender: UISwitch) {
        
        weak var weakself = self
        
        DispatchQueue.global().async {
            DispatchQueue.main.async(execute: {
                if sender.isOn {
                    weakself?.displayMode = .regularTwo
                } else {
                    weakself?.displayMode = weakself?.switchBodySideControl.selectedSegmentIndex == 0 ? .largeBack : .largeFront
                }
                
                weakself?.setDisplayMode(mode: (weakself?.displayMode)!)
            })
        }
    }
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        torsoBackView.stepperChanged(value: Float(sender.value))
        torsoFrontView.stepperChanged(value: Float(sender.value))
        torsoBackViewLarge.stepperChanged(value: Float(sender.value))
        torsoFrontViewLarge.stepperChanged(value: Float(sender.value))
    }
    
    @IBAction func switchBodySideControlTouched(_ sender: UISegmentedControl) {
        
        
        if sender.selectedSegmentIndex == 0 {
            // back side
            if displayMode == .regularFront {
                displayMode = .regularBack
            } else if displayMode == .largeFront {
                displayMode = .largeBack
            }
        } else {
            // front side
            if displayMode == .regularBack {
                displayMode = .regularFront
            } else if displayMode == .largeBack {
                displayMode = .largeFront
            }
        }
        
        setDisplayMode(mode: displayMode)
    }
    
    func handleDeviceOrientation() {
        
        let isIPadPortrait = UIDevice.current.orientation.isPortrait && UI_USER_INTERFACE_IDIOM() == .pad
        let isIPadLandscape = UIDevice.current.orientation.isLandscape && UI_USER_INTERFACE_IDIOM() == .pad
        
        if UIDevice.current.orientation.isLandscape {
            displayMode = .regularTwo
        } else if isIPadPortrait {
            // iPad in Portrait
            if switchBodySideControl.selectedSegmentIndex == 0  {
                displayMode = switchShowBothSides.isOn ? .regularTwo : .largeBack
            } else {
                displayMode = switchShowBothSides.isOn ? .regularTwo : .largeFront
            }
        } else {
            // iPhone in Portrait
            displayMode = switchBodySideControl.selectedSegmentIndex == 0 ? .regularBack : .regularFront
        }
        
        let h = self.view.frame.size.height
        let w = self.view.frame.size.width
        let screenHeight = h > w ? h : w
        
        if isIPadLandscape {
            animationTopSpace.constant = 0.02 * screenHeight
            controlView.isHidden = true
        } else if isIPadPortrait {
            animationTopSpace.constant = 0.15 * screenHeight
            controlView.isHidden = false
        }
        
        setDisplayMode(mode: displayMode)
        
        torsoFrontView.resetZoomFactor()
        torsoFrontViewLarge.resetZoomFactor()
        torsoBackView.resetZoomFactor()
        torsoBackViewLarge.resetZoomFactor()
    }
    
    func setDisplayMode(mode: DisplayMode) {
        
        infoButton.isEnabled = true
        infoButton.alpha = 1
        torsoBackView.alpha = 0
        backViewButton.alpha = 0
        torsoFrontView.alpha = 0
        frontViewButton.alpha = 0
        torsoBackViewLarge.alpha = 0
        torsoFrontViewLarge.alpha = 0
        backViewButtonLarge.alpha = 0
        frontViewButtonLarge.alpha = 0
        switchBodySideControl.isEnabled = true
        
        if mode == .regularBack {
            torsoBackView.alpha = 1
            backViewButton.alpha = 1
            torsoFrontView.alpha = 0
            frontViewButton.alpha = 0
        } else if mode == .regularFront {
            torsoBackView.alpha = 0
            backViewButton.alpha = 0
            torsoFrontView.alpha = 1
            frontViewButton.alpha = 1
        } else if mode == .regularTwo {
            torsoBackView.alpha = 1
            torsoFrontView.alpha = 1
            frontViewButton.alpha = 1
            backViewButton.alpha = 1
            switchBodySideControl.isEnabled = false
        } else if mode == .largeBack {
            torsoBackViewLarge.alpha = 1
            backViewButtonLarge.alpha = 1
            infoButton.isEnabled = false
            infoButton.alpha = 0
        } else if mode == .largeFront {
            torsoFrontViewLarge.alpha = 1
            frontViewButtonLarge.alpha = 1
            infoButton.isEnabled = false
            infoButton.alpha = 0
        }
        
        frontViewButton.setTitle("Info", for: .normal)
        frontViewButton.backgroundColor = Color.Button.inactive
        backViewButton.setTitle("Info", for: .normal)
        backViewButton.backgroundColor = Color.Button.inactive
        frontViewButtonLarge.setTitle("Info", for: .normal)
        frontViewButtonLarge.backgroundColor = Color.Button.inactive
        backViewButtonLarge.setTitle("Info", for: .normal)
        backViewButtonLarge.backgroundColor = Color.Button.inactive
        
        if (switchAnimation.isOn) {
            torsoFrontView.animationSetup(resetViews: true)
            torsoBackView.animationSetup(resetViews: true)
            torsoFrontViewLarge.animationSetup(resetViews: true)
            torsoBackViewLarge.animationSetup(resetViews: true)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showMuscleGroupSegue" {
//            if let viewController = segue.destination as? VideoTableViewController{
//
//                if let button = sender as? UIButton {
//                    viewController.title = button.titleLabel?.text
//                    viewController.muscleGroupColor = button.backgroundColor!
//                }
//
//                if let view = sender as? TorsoBasicView {
//                    viewController.title = view.tappedMuscleGroupName
//                    viewController.muscleGroupColor = view.tappedMuscleGroupColor
//                }
//            }
//        }
    }
}


extension AnatomyViewController: TorsoFrontViewDelegate {
    func updateFrontButton(index: Int, sender: TorsoFrontView) {
        
        let frontViewItem = FrontView().dict[index]
        
        frontViewButton.backgroundColor = frontViewItem?.color
        frontViewButton.setTitle(frontViewItem?.muscleName, for: .normal)
        
        frontViewButtonLarge.backgroundColor = frontViewButton.backgroundColor
        frontViewButtonLarge.setTitle(frontViewButton.titleLabel?.text, for: .normal)
    }
    
    func resetFrontButton(sender: TorsoFrontView) {
        frontViewButton.backgroundColor = Color.Button.inactive
        frontViewButtonLarge.backgroundColor = frontViewButton.backgroundColor
    }
    
    func redirectFront(sender: TorsoFrontView) {
        self.performSegue(withIdentifier: "showMuscleGroupSegue", sender: sender)
    }
}

extension AnatomyViewController: TorsoBackViewDelegate {
    func updateBackButton(index: Int, sender: TorsoBackView) {
        
        let backViewItem = BackView().dict[index]
        
        backViewButton.backgroundColor = backViewItem?.color
        backViewButton.setTitle(backViewItem?.muscleName, for: .normal)
        
        backViewButtonLarge.backgroundColor = backViewButton.backgroundColor
        backViewButtonLarge.setTitle(backViewButton.titleLabel?.text, for: .normal)
    }
    
    func resetBackButton(sender: TorsoBackView) {
        backViewButton.backgroundColor = Color.Button.inactive
        backViewButtonLarge.backgroundColor = backViewButton.backgroundColor
    }
    
    func redirectBack(sender: TorsoBackView) {
        self.performSegue(withIdentifier: "showMuscleGroupSegue", sender: sender)
    }
}

