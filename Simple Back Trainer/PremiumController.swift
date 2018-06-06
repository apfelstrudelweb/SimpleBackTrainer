//
//  PremiumController.swift
//  Simple Back Trainer
//
//  Created by Ulrich Vormbrock on 03/06/18.
//  Copyright © 2018 Kode. All rights reserved.
//

import UIKit

class PremiumController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var premiumButton: UIButton!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var buttonWidth: NSLayoutConstraint!
    
    let items = [
        ["premiumNoAds", "Komplett ohne Werbung", "Keine Webebanner mehr in der Premium-Version."],
        ["premiumPlan", "Individuelle Trainingspläne", "Stelle deine eigenen Trainingspläne zusammen und verfolge deinen Fortschritt im Training."],
        ["premiumVideo", "Mehr Trainingsvideos", "Mehr Trainingsvideos mit Hanteln, Körpergewicht, Widerstandsbändern und Kleingeräten."],
        ["premiumMobilisation", "Mobilisierungsübungen", "Finde heraus, wie du zusätzlich zur Stärkung des Rückens deine Flexibilität erhöhst und beweglich bleibst."]];
    let buttonTitle = "Premium App kaufen $ 4,99"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        
        premiumButton.setTitle(buttonTitle, for: .normal)
        premiumButton.layer.cornerRadius = 10
        premiumButton.titleEdgeInsets = UIEdgeInsets(top: 4, left: 20, bottom: 4, right: 20)
        
        let textWidth = (buttonTitle as NSString).size(withAttributes:[kCTFontAttributeName as NSAttributedStringKey:premiumButton.titleLabel!.font!]).width
        let width = textWidth + premiumButton.titleEdgeInsets.left + premiumButton.titleEdgeInsets.right
        buttonWidth.constant = width + 10
        
        premiumButton.layoutIfNeeded()
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
        cell.iconView.image = UIImage(named: items[indexPath.row][0])
        cell.titleLabel.text = items[indexPath.row][1]
        cell.explanationLabel.text = items[indexPath.row][2]
        
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
