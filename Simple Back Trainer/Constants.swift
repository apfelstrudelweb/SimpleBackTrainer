//
//  Constants.swift
//  Simple Back Trainer
//
//  Created by Rakesh Kumar on 03/06/18.
//  Copyright © 2018 Kode. All rights reserved.
//

import UIKit

let adsBottomSpace:CGFloat = 44.0

struct Color {
    
    // TODO: get from JSON and CoreData
    struct Torso {
        static let yellow = UIColor(red:0.99, green:0.80, blue:0.27, alpha:1.0)
        static let orange = UIColor(red:0.89, green:0.38, blue:0.16, alpha:1.0)
        static let red = UIColor(red:0.93, green:0.06, blue:0.11, alpha:1.0)
        static let lightBlue = UIColor(red:0.18, green:0.57, blue:0.89, alpha:1.0)
        static let beige = UIColor(red:0.97, green:0.57, blue:0.16, alpha:1.0)
        static let green = UIColor(red:0.51, green:0.73, blue:0.23, alpha:1.0)
        static let purple = UIColor(red:0.84, green:0.17, blue:0.67, alpha:1.0)
    }
    
    struct Button {
        static let inactive = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.1)
    }
    
    
}

enum StoryboardId: String {
    case plan = "PlanController"
    case home = "Home"
    case premium = "PremiumController"
    case settings = "SettingsController"
    case activity = "ActivitiesController"
    case sports = "SportsController"
    case exercise = "ExercisesController"
    case contact = "ContactController"
    case mobilisation = "MobilisationsController"
    case backTherapy = "BackTherapyController"
    case anatomy = "AnatomyController"
    
    func title() -> String {
        switch self {
        case .plan:
            return "Plan"
        case .home:
            return "Home"
        case .premium:
            return "Premium"
        case .settings:
            return "Settings"
        default:
            return "Home"
        }
    }
}
