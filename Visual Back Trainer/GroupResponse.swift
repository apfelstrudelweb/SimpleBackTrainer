//
//  GroupResponse.swift
//  Trainingsplan
//
//  Created by Ulrich Vormbrock on 25/04/18.
//  Copyright © 2018 Ulrich Vormbrock. All rights reserved.
//

import UIKit

class WorkoutResponse: Codable {
    let workouts: [WorkoutData]?
}

typealias LanguageValues = [String: String]
typealias LanguageArray = [String: [String]]

struct Info : Codable {
    var title: LanguageValues
    var instructions: LanguageArray
    var remarks: LanguageArray
}

struct WorkoutData: Codable {
    
    let alias: String?
    let id: Int?
    let imageName: String?
    let intensity: Int?
    let isBall: Int?
    let isDumbbell: Int?
    let isLive: Int?
    let isMachine: Int?
    let isMat: Int?
    let isPremium: Int?
    let isTheraband: Int?
    let videoUrl: String?
    let musclegroups: [Int]?
    let info: Info?
}

class TrainingsplanResponse: Codable {
    let exercises: [TrainingsplanData]?
}

struct TrainingsplanData: Codable {
    
    let id: Int?
    let position: Int?
}

extension WorkoutData {

    var title: LanguageValues  {
        return info!.title
    }

    var instructions: LanguageArray {
        return info!.instructions
    }

    var remarks: LanguageArray {
        return info!.remarks
    }
}
