//
//  MenuViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
    func changeTitle(title:String)
}



class SlideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var backgroundColor: UIColor = .blue
    
    
    /**
    *  Array to display menu options
    */
    @IBOutlet var tblMenuOptions : UITableView!
    
    /**
    *  Transparent button to hide menu
    */
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    /**
    *  Array containing menu options
    */
    var arrayMenuOptions = [Dictionary<String,String>]()
    
    /**
    *  Menu button which was tapped to display the menu
    */
    var btnMenu : UIButton!
    
    /**
    *  Delegate of the MenuVC
    */
    var delegate : SlideMenuDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tblMenuOptions.tableFooterView = UIView()
        self.view.backgroundColor = .clear
        UITableView.appearance().separatorColor = .white
        tblMenuOptions.backgroundColor = backgroundColor //UIColor(red: 0.2706, green: 0.4314, blue: 0.7569, alpha: 1.0)
        updateArrayMenuOptions()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //updateArrayMenuOptions()
    }
    
    func updateArrayMenuOptions(){
        
        arrayMenuOptions.append(["title":"SIDEMENU_HOME".localized(), "icon":"side_home"])
        arrayMenuOptions.append(["title":"SIDEMENU_ACTIVITIES".localized(), "icon":"side_berufe"])
        arrayMenuOptions.append(["title":"SIDEMENU_SPORTS".localized(), "icon":"side_sportarten"])
        arrayMenuOptions.append(["title":"SIDEMENU_EXERCISES".localized(), "icon":"side_uebungen"])
        arrayMenuOptions.append(["title":"SIDEMENU_PREMIUM".localized(), "icon":"side_premium"])
        arrayMenuOptions.append(["title":"SIDEMENU_SETTINGS".localized(), "icon":"side_settings"])
        arrayMenuOptions.append(["title":"SIDEMENU_TELLAFRIEND".localized(), "icon":"side_tellafriend"])
        arrayMenuOptions.append(["title":"SIDEMENU_CONTACT".localized(), "icon":"side_contact"])
        
        
        tblMenuOptions.reloadData()
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!){
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        // self.navigationController?.isNavigationBarHidden = false
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
               //self.delegate?.changeTitle(title: "Rocky")
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = .clear//self.tblMenuOptions.backgroundColor

        
        let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let fontSize = min(20, self.view.frame.size.width / 25)
        
        lblTitle.font = UIFont.boldSystemFont(ofSize: fontSize)
        
        
        let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        
        imgIcon.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        lblTitle.text = arrayMenuOptions[indexPath.row]["title"]!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
        self.onCloseMenuClick(btn)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
}
