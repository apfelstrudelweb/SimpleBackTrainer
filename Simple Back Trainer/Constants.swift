//
//  Constants.swift
//  Simple Back Trainer
//
//  Created by Rakesh Kumar on 03/06/18.
//  Copyright © 2018 Kode. All rights reserved.
//

import UIKit

enum StoryboardId:String {
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
