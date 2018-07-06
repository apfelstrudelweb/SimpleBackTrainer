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
