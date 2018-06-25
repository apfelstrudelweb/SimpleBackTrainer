//
//  BaseViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    var menuWidth : CGFloat!
    var menuVC : SlideMenuViewController?
    var hamburgerButton:UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        

        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(red:0.82, green:0.82, blue:0.82, alpha:1.0)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.tabBarController?.tabBar.addSubview(separatorView)
        
        separatorView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(0.6)
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            //make.edges.equalTo((self.tabBarController?.tabBar)!)
        }
    }
    

    override func viewDidLayoutSubviews() {
        
        if (self.menuVC == nil) {
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.menuVC?.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);

        }, completion:nil)
    }
    
    func addSlideMenuButton(){
        hamburgerButton = UIButton(type: UIButtonType.system)
        hamburgerButton?.setImage(self.defaultMenuImage(), for: UIControlState())
        hamburgerButton?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        hamburgerButton?.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: hamburgerButton!)
        
        self.navigationItem.leftBarButtonItem = customBarItem;
    }

    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
        
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
       
        return defaultMenuImage;
    }
    
    @objc func onSlideMenuButtonPressed(_ sender : UIButton){
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
                }, completion: { (finished) -> Void in
                    viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
       // self.tabBarController?.hidesBottomBarWhenPushed = true
        if self.menuVC != nil {
            self.menuVC?.view.removeFromSuperview()
            self.menuVC?.removeFromParentViewController()
        }
        
        self.menuVC = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as? SlideMenuViewController
        menuVC?.btnMenu = sender
        menuVC?.delegate = self
        
        print(self)
        
        self.view.addSubview((menuVC?.view)!)
        self.addChildViewController((menuVC)!)
        menuVC?.view.layoutIfNeeded()
        //self.navigationController?.isNavigationBarHidden = true
        
        menuVC?.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.menuVC?.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
            }, completion:nil)
    }
}

extension BaseViewController: SlideMenuDelegate {

    func changeTitle(title: String) {
        self.tabBarItem.title = title
    }
    
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        switch(index){
        case 0:
            print("Home\n", terminator: "")
            self.openViewControllerBasedOnIdentifier(StoryboardId.home.rawValue)
            break
        case 1:
            print("Play\n", terminator: "")
            self.openViewControllerBasedOnIdentifier(StoryboardId.activity.rawValue)
            break
        case 2:
            self.openViewControllerBasedOnIdentifier(StoryboardId.sports.rawValue)
        case 3:
            self.openViewControllerBasedOnIdentifier(StoryboardId.exercise.rawValue)
        case 4:
            print("Settings\n", terminator:"")
            self.openViewControllerBasedOnIdentifier(StoryboardId.premium.rawValue)
        case 5:
            print("Settings\n", terminator:"")
            self.openViewControllerBasedOnIdentifier(StoryboardId.settings.rawValue)
        case 6:
            self.openViewControllerBasedOnIdentifier(StoryboardId.contact.rawValue)
        default:
            print("default\n", terminator: "")
        }
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        guard let topViewController:UIViewController = self.tabBarController?.selectedViewController?.childViewControllers.last else { return }
        guard let topControllerIdentifier = topViewController.restorationIdentifier else { return }
        print(topViewController)
        print(topControllerIdentifier)
        
        if (topControllerIdentifier != strIdentifier){
            if self.isControllerExistInTab(strIdentifier: strIdentifier) == false {
                guard let destViewController:UIViewController = self.storyboard?.instantiateViewController(withIdentifier: strIdentifier) else {
                    return
                }
                self.navigationController!.pushViewController(destViewController, animated: true)
                //self.addChild(child: destViewController)
                //self.addChildToParentController(child: destViewController, parent: topViewController)
            }
        }
    }
    
    func addChild(child: UIViewController) {
        if let parent = self.navigationController?.viewControllers.last {
            print(parent)
//            if let view = parent.childViewControllers.first {
//                let existingClass = NSStringFromClass(view.classForCoder).components(separatedBy: ".").last
//                switch existingClass! {
//                case storyboardId.menuController:
//                    break
//                default:
//                    self.removeChildFromViewController(child: view)
//                    let menuController = MenuRouter.createMenuModule()
//                    self.addChildToParentController(child: menuController, parent: parent)
//                    break
//                }
//            } else {
            
            self.addChildToParentController(child: child, parent: parent)
           // }
        }
    }
    
    
    func addChildToParentController(child:UIViewController, parent: UIViewController) {
        print(parent)
        parent.addChildViewController(child)
        parent.view.addSubview(child.view)
        //parent.view.insertSubview(child.view, at: 0)
        child.didMove(toParentViewController: parent)
    }
    
    func removeChildFromViewController(child:UIViewController) {
        child.willMove(toParentViewController: nil)
        child.view.removeFromSuperview()
        child.removeFromParentViewController()
    }
    
    
    
    func isControllerExistInTab(strIdentifier:String) -> Bool {
       // var navigationTile:String?
        switch strIdentifier {
        case StoryboardId.home.rawValue:
            self.tabBarController?.selectedIndex = 0
         //   navigationTile = StoryboardId.home.title()
            return true
        case StoryboardId.plan.rawValue:
            self.tabBarController?.selectedIndex = 1
           // navigationTile = StoryboardId.plan.title()
            return true
        case StoryboardId.premium.rawValue:
            self.tabBarController?.selectedIndex = 2
           // navigationTile = StoryboardId.premium.title()
            return true
        case StoryboardId.settings.rawValue:
            self.tabBarController?.selectedIndex = 3
           // navigationTile = StoryboardId.settings.title()
            return true
        default:
           // self.tabBarController?.selectedIndex = 0
          //  self.tabBarItem.title = StoryboardId.home.title()
            return false
        }
//        guard navigationTile == nil else {
//           // self.tabBarItem.title = navigationTile
//            return true
//        }

       // return false
    }
}
