//
//  Constants.swift
//  Simple Back Trainer
//
//  Created by Ulrich Vormbrock on 03/06/18.
//  Copyright © 2018 Kode. All rights reserved.
//

import UIKit

let adsBottomSpace:CGFloat = 44.0

struct Color {
    
    struct Button {
        static let inactive = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.1)
    }
    
    
}

enum StoryboardId: String {
    case plan = "ViewController"
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
    case tellafriend = "TellafriendController"
    
    func title() -> String {
        switch self {
        case .plan:
            return "TABBAR_PLAN".localized()
        case .home:
            return "TABBAR_HOME".localized()
        case .premium:
            return "TABBAR_PREMIUM".localized()
        case .settings:
            return "TABBAR_SETTINGS".localized()
        default:
            return "TABBAR_HOME".localized()
        }
    }
}
