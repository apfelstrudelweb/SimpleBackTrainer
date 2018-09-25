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
    
    @IBOutlet weak var languageLabel: UILabel!
    
    
    let dropDown = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.dropDown
        ]
    }()
    

    
    var locale = NSLocale(localeIdentifier: Locale.current.languageCode!)
    var countries = [String: String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        
        self.title = "TABBAR_SETTINGS".localized()
        
        if let savedAppLanguage = UserDefaults.standard.object(forKey: "AppLanguage") as? String {
            locale = NSLocale(localeIdentifier: savedAppLanguage)
        }
        
        self.updateCountries()
        
        let language = locale.localizedString(forLanguageCode: locale.languageCode)?.capitalized
  

        dropDown.anchorView = languageButton
        dropDown.dismissMode = .onTap
        
        languageLabel.text = "SETTINGS_LANGUAGE_LABEL".localized()
        
        languageButton.setTitle(language, for: .normal)
        flagButton.setImage(UIImage(named: locale.languageCode), for: .normal)
        
        dropDown.cellNib = UINib(nibName: "LanguageCell", bundle: nil)

        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? LanguageCell else { return }
            
            // Setup your custom UI components
            cell.languageLabel.text = self.countries[item]!
            cell.flagImageView?.image = UIImage(named: item)
        }
        
        dropDown.selectionAction = { [weak self] (index, item) in
            
            // TODO: store in user defaults
            self?.locale = NSLocale(localeIdentifier: item)
            
            self?.languageButton.setTitle(self?.locale.localizedString(forLanguageCode: item)?.capitalized, for: .normal)
            self?.flagButton.setImage(UIImage(named: item), for: .normal)
            self?.updateCountries()
            
            self?.languageLabel.text = "SETTINGS_LANGUAGE_LABEL".localized(forLanguage: item)
            UserDefaults.standard.set(item, forKey: "AppLanguage")
            
            self?.title = "TABBAR_SETTINGS".localized()
            self?.tabBarController?.tabBar.items![0].title = "TABBAR_HOME".localized()
            self?.tabBarController?.tabBar.items![1].title = "TABBAR_PLAN".localized()
            self?.tabBarController?.tabBar.items![2].title = "TABBAR_PREMIUM".localized()
            self?.tabBarController?.tabBar.items![3].title = "TABBAR_SETTINGS".localized()
            
            let animationController = self?.tabBarController?.viewControllers?.first as! UINavigationController
            let backButton = UIBarButtonItem()
            backButton.title = "SYSTEM_BACK".localized()
            animationController.navigationBar.backItem?.backBarButtonItem = backButton
        }
    }
    
    func updateCountries() {
        for code in Bundle.main.localizations {
            if let language = locale.localizedString(forLanguageCode: code) {
                countries[code.components(separatedBy: "-").first!] = language.capitalized
            }
        }
        dropDown.dataSource = Array(countries.map({ $0.key }))
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

