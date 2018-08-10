//
//  PremiumController.swift
//  Simple Back Trainer
//
//  Created by Ulrich Vormbrock on 03/06/18.
//  Copyright © 2018 Kode. All rights reserved.
//

import UIKit

class PremiumViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var premiumButton: UIButton!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var buttonWidth: NSLayoutConstraint!
    
    var calledFromVideolist: Bool! = false
    

    let items = [
        ["premiumNoAds", NSLocalizedString("PREMIUM_NOADS_TITLE", comment: ""), NSLocalizedString("PREMIUM_NOADS_DESCR", comment: "")],
        ["premiumChart", NSLocalizedString("PREMIUM_CHART_TITLE", comment: ""), NSLocalizedString("PREMIUM_CHART_DESCR", comment: "")],
        ["premiumVideo", NSLocalizedString("PREMIUM_VIDEO_TITLE", comment: ""), NSLocalizedString("PREMIUM_VIDEO_DESCR", comment: "")],
        ["premiumMobilisation", NSLocalizedString("PREMIUM_MOBIL_TITLE", comment: ""), NSLocalizedString("PREMIUM_MOBIL_DESCR", comment: "")]];
    let buttonTitle = NSLocalizedString("PREMIUM_BUTTON_TEXT", comment: "") + " $ 4,99" // TODO: get price from Store
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if calledFromVideolist == false {
            addSlideMenuButton()
        }
        
        titleLabel.text = NSLocalizedString("PREMIUM_TITLE", comment: "")
        
        premiumButton.setTitle(buttonTitle, for: .normal)
        premiumButton.layer.cornerRadius = 10
        premiumButton.titleEdgeInsets = UIEdgeInsets(top: 4, left: 20, bottom: 4, right: 20)
        premiumButton.backgroundColor = UIColor.withAlphaComponent((navigationController?.navigationBar.barTintColor)!)(0.9)
        
        let textWidth = (buttonTitle as NSString).size(withAttributes:[kCTFontAttributeName as NSAttributedStringKey:premiumButton.titleLabel!.font!]).width
        let width = textWidth + premiumButton.titleEdgeInsets.left + premiumButton.titleEdgeInsets.right
        buttonWidth.constant = width + 10
        
        premiumButton.layoutIfNeeded()
        // Do any additional setup after loading the view.
        
        // for ADs
        self.tableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: adsBottomSpace, right: 0)
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
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 100
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
