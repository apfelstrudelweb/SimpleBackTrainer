//
//  PremiumController.swift
//  Simple Back Trainer
//
//  Created by Rakesh Kumar on 03/06/18.
//  Copyright © 2018 Kode. All rights reserved.
//

import UIKit

class PremiumController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var premiumButton: UIButton!
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        
        premiumButton.layer.cornerRadius = 10
        premiumButton.titleEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
        premiumButton.sizeToFit()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.menuVC != nil {
            self.hamburgerButton?.tag = 0
            self.menuVC?.view.removeFromSuperview()
            self.menuVC?.removeFromParentViewController()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "premiumCell", for: indexPath) as! PremiumTableViewCell
        cell.iconView.image = UIImage(named: "premiumNoAds")
        cell.titleLabel.text = "Komplett ohne Werbung"
        cell.explanationLabel.text = "Keine Webebanner mehr in der Premium-Version. Und alles und so ..."
        
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
