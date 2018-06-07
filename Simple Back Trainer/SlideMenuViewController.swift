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
        updateArrayMenuOptions()
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //updateArrayMenuOptions()
    }
    
    func updateArrayMenuOptions(){
        
        arrayMenuOptions.append(["title":NSLocalizedString("SIDEMENU_HOME", comment: ""), "icon":"home"])
        arrayMenuOptions.append(["title":NSLocalizedString("SIDEMENU_ACTIVITIES", comment: ""), "icon":"berufe"])
        arrayMenuOptions.append(["title":NSLocalizedString("SIDEMENU_SPORTS", comment: ""), "icon":"sportarten"])
        arrayMenuOptions.append(["title":NSLocalizedString("SIDEMENU_EXERCISES", comment: ""), "icon":"uebungen"])
        arrayMenuOptions.append(["title":NSLocalizedString("SIDEMENU_PREMIUM", comment: ""), "icon":"premium"])
        arrayMenuOptions.append(["title":NSLocalizedString("SIDEMENU_SETTINGS", comment: ""), "icon":"settings"])
        arrayMenuOptions.append(["title":NSLocalizedString("SIDEMENU_CONTACT", comment: ""), "icon":"contact"])
        
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
        cell.backgroundColor = self.tblMenuOptions.backgroundColor

        
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
