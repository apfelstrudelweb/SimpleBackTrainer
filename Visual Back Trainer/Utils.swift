//
//  Utils.swift
//  Trainingsplan
//
//  Created by Ulrich Vormbrock on 14.04.18.
//  Copyright © 2018 Ulrich Vormbrock. All rights reserved.
//

import UIKit


public extension Bundle {
    
    func subspecURL(subspecName:String) -> URL {
        
        return self.bundleURL.appendingPathComponent(subspecName.appending(".bundle"))
    }
    
    
    func dataModelURL(modelName:String) -> URL {
        
        return self.url(forResource: modelName, withExtension: "momd")!
    }
}

// for localization
public extension String {
    
    // returns the localisation for language selected in the settings menue
    func localized() -> String {
        var appLocale = NSLocale(localeIdentifier: Locale.current.languageCode!)
        
        if let savedAppLanguage = UserDefaults.standard.object(forKey: "AppLanguage") as? String {
            appLocale = NSLocale(localeIdentifier: savedAppLanguage)
        }
        let appLanguage = appLocale.languageCode
        
        return self.localized(forLanguage: appLanguage)
    }
    
    func localized(forLanguage language: String = Locale.preferredLanguages.first!.components(separatedBy: "-").first!) -> String {
        
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj") else {
            
            let basePath = Bundle.main.path(forResource: "Base", ofType: "lproj")!
            
            return Bundle(path: basePath)!.localizedString(forKey: self, value: "", table: nil)
        }
        
        return Bundle(path: path)!.localizedString(forKey: self, value: "", table: nil)
    }
}
