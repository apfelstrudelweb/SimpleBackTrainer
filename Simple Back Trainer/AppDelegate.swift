//
//  AppDelegate.swift
//  Trainingsplan
//
//  Created by Ulrich Vormbrock on 06.04.18.
//  Copyright © 2018 Ulrich Vormbrock. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var db = CoreDataManager.sharedInstance
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.149, green: 0.3373, blue: 0.7216, alpha: 1.0)
        
        UITabBar.appearance().barTintColor = UIColor(red: 0.9176, green: 0.9176, blue: 0.9176, alpha: 1.0)
        UITabBar.appearance().tintColor = UINavigationBar.appearance().barTintColor
        
        //clearDB()
//        let navigationController = window?.rootViewController as! UINavigationController
//        let firstVC = navigationController.viewControllers[0] as! BaseViewController
//        firstVC.context = db.managedObjectContext
        db.managedObjectContext.automaticallyMergesChangesFromParent = true
        let _ =  db.insertTrainingsPlan(id: 1, workouts: [])
        
        if  UserDefaults.standard.object(forKey: "jsonLoaded") == nil {
            UserDefaults.standard.set(false, forKey: "jsonLoaded")
            UserDefaults.standard.synchronize()
        }
        
        // TODO: check if already populated
        self.populateMusclegroups()
       
        
        Thread.sleep(forTimeInterval: 3.0)
        
        return true
    }
    
    func populateMusclegroups() {
        
        var muscleGroup: Musclegroup
        var tapPath: UIBezierPath
        
        // front muscles
        muscleGroup = NSEntityDescription.insertNewObject(forEntityName: "Musclegroup", into: db.managedObjectContext) as! Musclegroup
        muscleGroup.id = 1
        muscleGroup.alias = "straight_abdominal"
        muscleGroup.color = "242,12,13"
        muscleGroup.isFront = true
        tapPath = UIBezierPath()
        tapPath.move(to: CGPoint(x:0.402542372881356, y:0.804702495201535))
        tapPath.addLine(to: CGPoint(x:0.406779661016949, y:0.562859884836852))
        tapPath.addLine(to: CGPoint(x:0.617231638418079, y:0.566698656429942))
        tapPath.addLine(to: CGPoint(x:0.616525423728814, y:0.804702495201535))
        muscleGroup.bezierPath = NSKeyedArchiver.archivedData(withRootObject: tapPath) as NSData
        
        muscleGroup = NSEntityDescription.insertNewObject(forEntityName: "Musclegroup", into: db.managedObjectContext) as! Musclegroup
        muscleGroup.id = 2
        muscleGroup.alias = "ext_oblique_abdominal"
        muscleGroup.color = "230,97,25"
        muscleGroup.isFront = true
        tapPath = UIBezierPath()
        tapPath.move(to: CGPoint(x:0.274889854397543, y:0.58886894075404))
        tapPath.addLine(to: CGPoint(x:0.385903070256573, y:0.561938958707361))
        tapPath.addLine(to: CGPoint(x:0.362995567825922, y:0.680430879712747))
        tapPath.addLine(to: CGPoint(x:0.298678400653049, y:0.66546976031264))
        tapPath.close()
        tapPath.move(to: CGPoint(x:0.637004391842477, y:0.563135828535261))
        tapPath.addLine(to: CGPoint(x:0.746255479720195, y:0.585876711395099))
        tapPath.addLine(to: CGPoint(x:0.729515405058336, y:0.666666657535135))
        tapPath.addLine(to: CGPoint(x:0.661673981922839, y:0.678635547576302))
        tapPath.close()
        muscleGroup.bezierPath = NSKeyedArchiver.archivedData(withRootObject: tapPath) as NSData
        
        muscleGroup = NSEntityDescription.insertNewObject(forEntityName: "Musclegroup", into: db.managedObjectContext) as! Musclegroup
        muscleGroup.id = 3
        muscleGroup.alias = "in_oblique_abdominal"
        muscleGroup.color = "249,159,44"
        muscleGroup.isFront = true
        tapPath = UIBezierPath()
        tapPath.move(to: CGPoint(x:0.303964744265384, y:0.679832417404202))
        tapPath.addLine(to: CGPoint(x:0.362995567825922, y:0.692998204667864))
        tapPath.addLine(to: CGPoint(x:0.383259898450406, y:0.804308797127469))
        tapPath.addLine(to: CGPoint(x:0.301321572459217, y:0.793536804308797))
        tapPath.close()
        tapPath.move(to: CGPoint(x:0.726872233252168, y:0.676840215439856))
        tapPath.addLine(to: CGPoint(x:0.659911894273128, y:0.691801307445369))
        tapPath.addLine(to: CGPoint(x:0.638766519823789, y:0.803111899904974))
        tapPath.addLine(to: CGPoint(x:0.727753277077024, y:0.791143009863807))
        tapPath.close()
        muscleGroup.bezierPath = NSKeyedArchiver.archivedData(withRootObject: tapPath) as NSData
        
        muscleGroup = NSEntityDescription.insertNewObject(forEntityName: "Musclegroup", into: db.managedObjectContext) as! Musclegroup
        muscleGroup.id = 5
        muscleGroup.alias = "head_turners"
        muscleGroup.color = "255,204,50"
        muscleGroup.isFront = true
        tapPath = UIBezierPath()
        tapPath.move(to: CGPoint(x:0.437853107344633, y:0.36852207293666))
        tapPath.addLine(to: CGPoint(x:0.430084745762712, y:0.272552783109405))
        tapPath.addLine(to: CGPoint(x:0.509180790960452, y:0.295585412667946))
        tapPath.addLine(to: CGPoint(x:0.589689265536723, y:0.273512476007678))
        tapPath.addLine(to: CGPoint(x:0.57909604519774, y:0.367562380038388))
        tapPath.close()
        muscleGroup.bezierPath = NSKeyedArchiver.archivedData(withRootObject: tapPath) as NSData
        
        muscleGroup = NSEntityDescription.insertNewObject(forEntityName: "Musclegroup", into: db.managedObjectContext) as! Musclegroup
        muscleGroup.id = 6
        muscleGroup.alias = "upper_trapezius"
        muscleGroup.color = "143,39,217"
        muscleGroup.isFront = true
        tapPath = UIBezierPath()
        tapPath.move(to: CGPoint(x:0.305726872246696, y:0.359066427289048))
        tapPath.addLine(to: CGPoint(x:0.41585900394927, y:0.324356654388044))
        tapPath.addLine(to: CGPoint(x:0.418502175755438, y:0.36744462566273))
        tapPath.close()
        tapPath.move(to: CGPoint(x:0.597356814749966, y:0.366247755834829))
        tapPath.addLine(to: CGPoint(x:0.609691629955947, y:0.328545780969479))
        tapPath.addLine(to: CGPoint(x:0.726872233252168, y:0.361460194339444))
        tapPath.close()
        muscleGroup.bezierPath = NSKeyedArchiver.archivedData(withRootObject: tapPath) as NSData
        
        // back muscles
        muscleGroup = NSEntityDescription.insertNewObject(forEntityName: "Musclegroup", into: db.managedObjectContext) as! Musclegroup
        muscleGroup.id = 5
        muscleGroup.alias = "upper_trapezius"
        muscleGroup.color = "143,39,217"
        muscleGroup.isFront = true

        
        do {
            try db.managedObjectContext.save()
        } catch let error {
            print("Failure to save context: \(error.localizedDescription)")
        }
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

