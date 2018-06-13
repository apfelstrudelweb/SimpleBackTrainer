//
//  GroupResponse.swift
//  Trainingsplan
//
//  Created by Rakesh Kumar on 25/04/18.
//  Copyright © 2018 Ulrich Vormbrock. All rights reserved.
//

import UIKit

class GroupResponse: Codable {
    let groups:[Group]?
}

struct Group:Codable {
    let descr:String?
    let id:Int?
    let name:String?
    let color:String?
    let workouts:[WorkoutData]?
}

struct WorkoutData:Codable {
    let descr:String?
    let id:Int?
    let image:String?
    let isPremium:Int?
    let name:String?
}
