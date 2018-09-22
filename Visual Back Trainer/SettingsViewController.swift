//
//  SettingsViewController.swift
//  Visual Back Trainer
//
//  Created by Ulrich Vormbrock on 22.09.18.
//  Copyright © 2018 Rookie. All rights reserved.
//

import UIKit
import DropDown

class SettingsViewController: BaseViewController {

    @IBOutlet weak var flagButton: UIButton!
    @IBOutlet weak var languageButton: UIButton!
    let dropDown = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.dropDown
        ]
    }()
    
    // TODO: get languages from localization
    var countries: [String: String] = ["English": "gb", "Français": "fr", "Deutsch": "de", "Español": "es", "Português": "pt", "Italiano": "it"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        
        let sorted = countries.sorted { $0.key < $1.key }
        let keysArraySorted = Array(sorted.map({ $0.key }))

        dropDown.anchorView = languageButton
        dropDown.dataSource = keysArraySorted
        dropDown.dismissMode = .onTap
        
//        languageButton.setTitle(keysArraySorted.first, for: .normal)
//        flagButton.setImage(UIImage(named: self.countries[keysArraySorted.first!]!), for: .normal)
        
        languageButton.setTitle("English", for: .normal)
        flagButton.setImage(UIImage(named: self.countries["English"]!), for: .normal)
        
        dropDown.cellNib = UINib(nibName: "LanguageCell", bundle: nil)

        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? LanguageCell else { return }
            
            // Setup your custom UI components
            cell.languageLabel.text = item
            cell.flagImageView?.image = UIImage(named: self.countries[item]!)
        }
        
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.languageButton.setTitle(item, for: .normal)
            self?.flagButton.setImage(UIImage(named: (self?.countries[item]!)!), for: .normal)
        }
    }
    
    
    @IBAction func flagButtonTouched(_ sender: Any) {
        dropDown.show()
    }
    
    @IBAction func languageButtonTouched(_ sender: Any) {
        dropDown.show()
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        if self.menuVC != nil {
            self.hamburgerButton?.tag = 0
            self.menuVC?.view.removeFromSuperview()
            self.menuVC?.removeFromParentViewController()
        }
    }

}
