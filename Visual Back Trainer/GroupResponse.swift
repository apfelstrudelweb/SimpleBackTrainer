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

/*
 @NSManaged public var id: Int16
 @NSManaged public var imgName: String?
 @NSManaged public var isFavorite: Bool
 @NSManaged public var isLive: Bool
 @NSManaged public var isPremium: Bool
 @NSManaged public var musclegroup: String?
 @NSManaged public var alias: String?
 @NSManaged public var videoUrl: String?
 @NSManaged public var isDumbbell: Bool
 @NSManaged public var isMat: Bool
 @NSManaged public var isBall: Bool
 @NSManaged public var isTheraband: NSObject?
 @NSManaged public var isMachine: Bool
 @NSManaged public var intensity: Int16
 @NSManaged public var icon: NSData?
 @NSManaged public var musclegroupId: Musclegroup?
 @NSManaged public var traininsgplanId: Plan?
*/
struct WorkoutData:Codable {
    let id:Int?
    let imageName:String?
    let isFavorite:Int?
    let isLive: Int?
    let isPremium:Int?
    let alias:String?
    let videoUrl:String?
    let isDumbbell:Int?
    let isMat:Int?
    let isBall:Int?
    let isTheraband:Int?
    let isMachine:Int?
    let intensity:Int?
    let musclegroupId: Int?
}
