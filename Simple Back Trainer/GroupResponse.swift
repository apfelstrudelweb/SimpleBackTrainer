//
//  GroupResponse.swift
//  Trainingsplan
//
//  Created by Ulrich Vormbrock on 25/04/18.
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
    let isFront:Bool?
    let workouts:[WorkoutData]?
}

struct WorkoutData:Codable {
    let descr:String?
    let id:Int?
    let image:String?
    let isPremium:Int?
    let isLive: Int?
    let name:String?
    let videoUrl:String?
}
