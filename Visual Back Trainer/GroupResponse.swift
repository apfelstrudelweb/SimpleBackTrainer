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
}

class TrainingsplanResponse: Codable {
    let exercises: [TrainingsplanData]?
}

struct TrainingsplanData: Codable {
    
    let id: Int?
    let position: Int?
}
