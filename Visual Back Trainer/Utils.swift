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
    
    // TODO: make it generic with the aid of user defaults
    
    func localized(forLanguage language: String = Locale.preferredLanguages.first!.components(separatedBy: "-").first!) -> String {
        
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj") else {
            
            let basePath = Bundle.main.path(forResource: "Base", ofType: "lproj")!
            
            return Bundle(path: basePath)!.localizedString(forKey: self, value: "", table: nil)
        }
        
        return Bundle(path: path)!.localizedString(forKey: self, value: "", table: nil)
    }
}
