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
        //let _ =  db.insertTrainingsPlan(position: 0, workouts: [])
        
        if  UserDefaults.standard.object(forKey: "jsonLoaded") == nil {
            UserDefaults.standard.set(false, forKey: "jsonLoaded")
            UserDefaults.standard.synchronize()
        }
        
        do {
            let fetchRequest = NSFetchRequest<Musclegroup>(entityName: "Musclegroup")
            let count = try CoreDataManager.sharedInstance.managedObjectContext.count(for: fetchRequest)
            
            if count == 0 {
                self.populateMusclegroups()
            }
            
        } catch let error {
            print ("fetch task failed", error)
            self.populateMusclegroups()
        }
        
        //Thread.sleep(forTimeInterval: 2.0)

        return true
    }
    
    
    func populateMusclegroups() {
        
        var muscleGroup: Musclegroup
        var tapPath: UIBezierPath
        
        // Front muscles
        muscleGroup = NSEntityDescription.insertNewObject(forEntityName: "Musclegroup", into: db.managedObjectContext) as! Musclegroup
        muscleGroup.id = 1
        muscleGroup.alias = "straight_abdominal"
        muscleGroup.color = "242,14,13"
        muscleGroup.isFront = true
        tapPath = UIBezierPath()
        tapPath.move(to: CGPoint(x:0.402542372881356, y:0.804702495201535))
        tapPath.addLine(to: CGPoint(x:0.406779661016949, y:0.562859884836852))
        tapPath.addLine(to: CGPoint(x:0.617231638418079, y:0.566698656429942))
        tapPath.addLine(to: CGPoint(x:0.616525423728814, y:0.804702495201535))
        tapPath.close()
        muscleGroup.bezierPath = NSKeyedArchiver.archivedData(withRootObject: tapPath) as NSData
        let groupWorkoutMembership1 = NSEntityDescription.insertNewObject(forEntityName: "GroupWorkoutMembership", into: db.managedObjectContext) as! GroupWorkoutMembership
        muscleGroup.addToMembership(groupWorkoutMembership1)
        
        muscleGroup = NSEntityDescription.insertNewObject(forEntityName: "Musclegroup", into: db.managedObjectContext) as! Musclegroup
        muscleGroup.id = 2
        muscleGroup.alias = "in_oblique_abdominal"
        muscleGroup.color = "242,163,8"
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
        let groupWorkoutMembership2 = NSEntityDescription.insertNewObject(forEntityName: "GroupWorkoutMembership", into: db.managedObjectContext) as! GroupWorkoutMembership
        muscleGroup.addToMembership(groupWorkoutMembership2)
        
        muscleGroup = NSEntityDescription.insertNewObject(forEntityName: "Musclegroup", into: db.managedObjectContext) as! Musclegroup
        muscleGroup.id = 3
        muscleGroup.alias = "ext_oblique_abdominal"
        muscleGroup.color = "230,97,27"
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
        let groupWorkoutMembership3 = NSEntityDescription.insertNewObject(forEntityName: "GroupWorkoutMembership", into: db.managedObjectContext) as! GroupWorkoutMembership
        muscleGroup.addToMembership(groupWorkoutMembership3)
        
        muscleGroup = NSEntityDescription.insertNewObject(forEntityName: "Musclegroup", into: db.managedObjectContext) as! Musclegroup
        muscleGroup.id = 4
        muscleGroup.alias = "upper_trapezius"
        muscleGroup.color = "137,21,195"
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
        let groupWorkoutMembership4 = NSEntityDescription.insertNewObject(forEntityName: "GroupWorkoutMembership", into: db.managedObjectContext) as! GroupWorkoutMembership
        muscleGroup.addToMembership(groupWorkoutMembership4)
        
        muscleGroup = NSEntityDescription.insertNewObject(forEntityName: "Musclegroup", into: db.managedObjectContext) as! Musclegroup
        muscleGroup.id = 5
        muscleGroup.alias = "head_turners"
        muscleGroup.color = "255,210,0"
        muscleGroup.isFront = true
        tapPath = UIBezierPath()
        tapPath.move(to: CGPoint(x:0.437853107344633, y:0.36852207293666))
        tapPath.addLine(to: CGPoint(x:0.430084745762712, y:0.272552783109405))
        tapPath.addLine(to: CGPoint(x:0.509180790960452, y:0.295585412667946))
        tapPath.addLine(to: CGPoint(x:0.589689265536723, y:0.273512476007678))
        tapPath.addLine(to: CGPoint(x:0.57909604519774, y:0.367562380038388))
        tapPath.close()
        muscleGroup.bezierPath = NSKeyedArchiver.archivedData(withRootObject: tapPath) as NSData
        let groupWorkoutMembership5 = NSEntityDescription.insertNewObject(forEntityName: "GroupWorkoutMembership", into: db.managedObjectContext) as! GroupWorkoutMembership
        muscleGroup.addToMembership(groupWorkoutMembership5)

        // Back muscles
        muscleGroup = NSEntityDescription.insertNewObject(forEntityName: "Musclegroup", into: db.managedObjectContext) as! Musclegroup
        muscleGroup.id = 10
        muscleGroup.alias = "in_oblique_abdominal"
        muscleGroup.color = "242,181,10"
        muscleGroup.isFront = false
        tapPath = UIBezierPath()
        tapPath.move(to: CGPoint(x:0.301518438177874, y:0.792035398230089))
        tapPath.addLine(to: CGPoint(x:0.303687635574837, y:0.751474926253687))
        tapPath.addLine(to: CGPoint(x:0.337310195227766, y:0.791297935103245))
        tapPath.close()
        tapPath.move(to: CGPoint(x:0.669197396963124, y:0.793510324483776))
        tapPath.addLine(to: CGPoint(x:0.710412147505423, y:0.794985250737463))
        tapPath.addLine(to: CGPoint(x:0.704989154013015, y:0.75))
        tapPath.close()
        muscleGroup.bezierPath = NSKeyedArchiver.archivedData(withRootObject: tapPath) as NSData
        let groupWorkoutMembership10 = NSEntityDescription.insertNewObject(forEntityName: "GroupWorkoutMembership", into: db.managedObjectContext) as! GroupWorkoutMembership
        muscleGroup.addToMembership(groupWorkoutMembership10)
        
        muscleGroup = NSEntityDescription.insertNewObject(forEntityName: "Musclegroup", into: db.managedObjectContext) as! Musclegroup
        muscleGroup.id = 11
        muscleGroup.alias = "back_extensors"
        muscleGroup.color = "220,18,20"
        muscleGroup.isFront = false
        tapPath = UIBezierPath()
        tapPath.move(to: CGPoint(x:0.365509761388286, y:0.792772861356932))
        tapPath.addLine(to: CGPoint(x:0.643167028199566, y:0.794985250737463))
        tapPath.addLine(to: CGPoint(x:0.505422993492408, y:0.553834808259587))
        tapPath.close()
        muscleGroup.bezierPath = NSKeyedArchiver.archivedData(withRootObject: tapPath) as NSData
        let groupWorkoutMembership11 = NSEntityDescription.insertNewObject(forEntityName: "GroupWorkoutMembership", into: db.managedObjectContext) as! GroupWorkoutMembership
        muscleGroup.addToMembership(groupWorkoutMembership11)
        
        muscleGroup = NSEntityDescription.insertNewObject(forEntityName: "Musclegroup", into: db.managedObjectContext) as! Musclegroup
        muscleGroup.id = 12
        muscleGroup.alias = "wide_back"
        muscleGroup.color = "255,135,33"
        muscleGroup.isFront = false
        tapPath = UIBezierPath()
        tapPath.move(to: CGPoint(x:0.301553672316384, y:0.736084452975048))
        tapPath.addLine(to: CGPoint(x:0.29590395480226, y:0.68042226487524))
        tapPath.addLine(to: CGPoint(x:0.253531073446328, y:0.60700575815739))
        tapPath.addLine(to: CGPoint(x:0.229519774011299, y:0.506238003838772))
        tapPath.addLine(to: CGPoint(x:0.31638418079096, y:0.511516314779271))
        tapPath.addLine(to: CGPoint(x:0.391949152542373, y:0.497600767754319))
        tapPath.addLine(to: CGPoint(x:0.452683615819209, y:0.581094049904031))
        tapPath.addLine(to: CGPoint(x:0.444915254237288, y:0.627159309021113))
        tapPath.addLine(to: CGPoint(x:0.349576271186441, y:0.78214971209213))
        tapPath.addLine(to: CGPoint(x:0.331214689265537, y:0.760076775431862))
        tapPath.close()
        tapPath.move(to: CGPoint(x:0.656073446327684, y:0.776391554702495))
        tapPath.addLine(to: CGPoint(x:0.553672316384181, y:0.617562380038388))
        tapPath.addLine(to: CGPoint(x:0.55861581920904, y:0.575335892514395))
        tapPath.addLine(to: CGPoint(x:0.608050847457627, y:0.494241842610365))
        tapPath.addLine(to: CGPoint(x:0.689971751412429, y:0.510076775431862))
        tapPath.addLine(to: CGPoint(x:0.781779661016949, y:0.507197696737044))
        tapPath.addLine(to: CGPoint(x:0.754943502824859, y:0.606525911708253))
        tapPath.addLine(to: CGPoint(x:0.719632768361582, y:0.664107485604607))
        tapPath.addLine(to: CGPoint(x:0.703389830508475, y:0.731285988483685))
        tapPath.addLine(to: CGPoint(x:0.665960451977401, y:0.763915547024952))
        tapPath.close()
        muscleGroup.bezierPath = NSKeyedArchiver.archivedData(withRootObject: tapPath) as NSData
        let groupWorkoutMembership12 = NSEntityDescription.insertNewObject(forEntityName: "GroupWorkoutMembership", into: db.managedObjectContext) as! GroupWorkoutMembership
        muscleGroup.addToMembership(groupWorkoutMembership12)
        
        muscleGroup = NSEntityDescription.insertNewObject(forEntityName: "Musclegroup", into: db.managedObjectContext) as! Musclegroup
        muscleGroup.id = 13
        muscleGroup.alias = "middle_lower_trapezius"
        muscleGroup.color = "27,145,230"
        muscleGroup.isFront = false
        tapPath = UIBezierPath()
        tapPath.move(to: CGPoint(x:0.329515418502203, y:0.384799512113232))
        tapPath.addLine(to: CGPoint(x:0.503964757709251, y:0.360263297116949))
        tapPath.addLine(to: CGPoint(x:0.68017618456601, y:0.379413515703896))
        tapPath.addLine(to: CGPoint(x:0.658149766291816, y:0.412926391382406))
        tapPath.addLine(to: CGPoint(x:0.508370017165129, y:0.375822851431006))
        tapPath.addLine(to: CGPoint(x:0.356828180388732, y:0.415320158432801))
        tapPath.close()
        tapPath.move(to: CGPoint(x:0.413215832143103, y:0.485936546668116))
        tapPath.addLine(to: CGPoint(x:0.504845801534107, y:0.467384790389713))
        tapPath.addLine(to: CGPoint(x:0.595594686768654, y:0.487731878804561))
        tapPath.addLine(to: CGPoint(x:0.528634347789613, y:0.584679814172604))
        tapPath.addLine(to: CGPoint(x:0.514537444933921, y:0.538001178625028))
        tapPath.addLine(to: CGPoint(x:0.49779732994046, y:0.537402743711078))
        tapPath.addLine(to: CGPoint(x:0.482819383259912, y:0.583482944344704))
        tapPath.close()
        muscleGroup.bezierPath = NSKeyedArchiver.archivedData(withRootObject: tapPath) as NSData
        let groupWorkoutMembership13 = NSEntityDescription.insertNewObject(forEntityName: "GroupWorkoutMembership", into: db.managedObjectContext) as! GroupWorkoutMembership
        muscleGroup.addToMembership(groupWorkoutMembership13)
        
        muscleGroup = NSEntityDescription.insertNewObject(forEntityName: "Musclegroup", into: db.managedObjectContext) as! Musclegroup
        muscleGroup.id = 14
        muscleGroup.alias = "rhomb"
        muscleGroup.color = "27,194,230"
        muscleGroup.isFront = false
        tapPath = UIBezierPath()
        tapPath.move(to: CGPoint(x:0.364757695807234, y:0.421304589756087))
        tapPath.addLine(to: CGPoint(x:0.504845801534107, y:0.383602614890737))
        tapPath.addLine(to: CGPoint(x:0.648458122892002, y:0.422501486978582))
        tapPath.addLine(to: CGPoint(x:0.604405286343612, y:0.48055055025878))
        tapPath.addLine(to: CGPoint(x:0.502202629727939, y:0.460203461843932))
        tapPath.addLine(to: CGPoint(x:0.402643144918433, y:0.48055055025878))
        tapPath.close()
        muscleGroup.bezierPath = NSKeyedArchiver.archivedData(withRootObject: tapPath) as NSData
        let groupWorkoutMembership14 = NSEntityDescription.insertNewObject(forEntityName: "GroupWorkoutMembership", into: db.managedObjectContext) as! GroupWorkoutMembership
        muscleGroup.addToMembership(groupWorkoutMembership14)
        
        muscleGroup = NSEntityDescription.insertNewObject(forEntityName: "Musclegroup", into: db.managedObjectContext) as! Musclegroup
        muscleGroup.id = 15
        muscleGroup.alias = "scapula"
        muscleGroup.color = "0,153,102"
        muscleGroup.isFront = false
        tapPath = UIBezierPath()
        tapPath.move(to: CGPoint(x:0.206073752711497, y:0.452064896755162))
        tapPath.addLine(to: CGPoint(x:0.325379609544469, y:0.415191740412979))
        tapPath.addLine(to: CGPoint(x:0.378524945770065, y:0.482300884955752))
        tapPath.addLine(to: CGPoint(x:0.314533622559653, y:0.493362831858407))
        tapPath.addLine(to: CGPoint(x:0.223427331887202, y:0.48598820058997))
        tapPath.close()
        tapPath.move(to: CGPoint(x:0.626412429378531, y:0.47936660268714))
        tapPath.addLine(to: CGPoint(x:0.730225988700565, y:0.495681381957774))
        tapPath.addLine(to: CGPoint(x:0.778954802259887, y:0.486084452975048))
        tapPath.addLine(to: CGPoint(x:0.80225988700565, y:0.448656429942418))
        tapPath.addLine(to: CGPoint(x:0.675847457627119, y:0.412188099808061))
        tapPath.close()
        muscleGroup.bezierPath = NSKeyedArchiver.archivedData(withRootObject: tapPath) as NSData
        let groupWorkoutMembership15 = NSEntityDescription.insertNewObject(forEntityName: "GroupWorkoutMembership", into: db.managedObjectContext) as! GroupWorkoutMembership
        muscleGroup.addToMembership(groupWorkoutMembership15)
        
        muscleGroup = NSEntityDescription.insertNewObject(forEntityName: "Musclegroup", into: db.managedObjectContext) as! Musclegroup
        muscleGroup.id = 16
        muscleGroup.alias = "deltoid"
        muscleGroup.color = "217,63,131"
        muscleGroup.isFront = false
        tapPath = UIBezierPath()
        tapPath.move(to: CGPoint(x:0.109463276836158, y:0.467850287907869))
        tapPath.addLine(to: CGPoint(x:0.150423728813559, y:0.399232245681382))
        tapPath.addLine(to: CGPoint(x:0.221045197740113, y:0.366122840690979))
        tapPath.addLine(to: CGPoint(x:0.257062146892655, y:0.357965451055662))
        tapPath.addLine(to: CGPoint(x:0.311440677966102, y:0.397792706333973))
        tapPath.addLine(to: CGPoint(x:0.221751412429379, y:0.428982725527831))
        tapPath.addLine(to: CGPoint(x:0.120762711864407, y:0.468330134357006))
        tapPath.close()
        tapPath.move(to: CGPoint(x:0.753531073446328, y:0.356525911708253))
        tapPath.addLine(to: CGPoint(x:0.833333333333333, y:0.384357005758157))
        tapPath.addLine(to: CGPoint(x:0.90183615819209, y:0.462092130518234))
        tapPath.addLine(to: CGPoint(x:0.887005649717514, y:0.468330134357006))
        tapPath.addLine(to: CGPoint(x:0.819209039548023, y:0.437619961612284))
        tapPath.addLine(to: CGPoint(x:0.690677966101695, y:0.400191938579655))
        tapPath.close()
        muscleGroup.bezierPath = NSKeyedArchiver.archivedData(withRootObject: tapPath) as NSData
        let groupWorkoutMembership16 = NSEntityDescription.insertNewObject(forEntityName: "GroupWorkoutMembership", into: db.managedObjectContext) as! GroupWorkoutMembership
        muscleGroup.addToMembership(groupWorkoutMembership16)
        
        muscleGroup = NSEntityDescription.insertNewObject(forEntityName: "Musclegroup", into: db.managedObjectContext) as! Musclegroup
        muscleGroup.id = 17
        muscleGroup.alias = "upper_trapezius"
        muscleGroup.color = "137,21,195"
        muscleGroup.isFront = false
        tapPath = UIBezierPath()
        tapPath.move(to: CGPoint(x:0.282485875706215, y:0.352207293666027))
        tapPath.addLine(to: CGPoint(x:0.411723163841808, y:0.313819577735125))
        tapPath.addLine(to: CGPoint(x:0.487994350282486, y:0.314299424184261))
        tapPath.addLine(to: CGPoint(x:0.514830508474576, y:0.314779270633397))
        tapPath.addLine(to: CGPoint(x:0.56638418079096, y:0.316698656429942))
        tapPath.addLine(to: CGPoint(x:0.593926553672316, y:0.312859884836852))
        tapPath.addLine(to: CGPoint(x:0.722457627118644, y:0.348848368522073))
        tapPath.addLine(to: CGPoint(x:0.694209039548023, y:0.371401151631478))
        tapPath.addLine(to: CGPoint(x:0.613700564971751, y:0.35700575815739))
        tapPath.addLine(to: CGPoint(x:0.516242937853107, y:0.351247600767754))
        tapPath.addLine(to: CGPoint(x:0.426553672316384, y:0.353646833013436))
        tapPath.addLine(to: CGPoint(x:0.314971751412429, y:0.374280230326296))
        tapPath.close()
        muscleGroup.bezierPath = NSKeyedArchiver.archivedData(withRootObject: tapPath) as NSData
        let groupWorkoutMembership17 = NSEntityDescription.insertNewObject(forEntityName: "GroupWorkoutMembership", into: db.managedObjectContext) as! GroupWorkoutMembership
        muscleGroup.addToMembership(groupWorkoutMembership17)
        
        muscleGroup = NSEntityDescription.insertNewObject(forEntityName: "Musclegroup", into: db.managedObjectContext) as! Musclegroup
        muscleGroup.id = 18
        muscleGroup.alias = "neck"
        muscleGroup.color = "255,210,0"
        muscleGroup.isFront = false
        tapPath = UIBezierPath()
        tapPath.move(to: CGPoint(x:0.426247288503254, y:0.297935103244838))
        tapPath.addLine(to: CGPoint(x:0.466377440347072, y:0.233038348082596))
        tapPath.addLine(to: CGPoint(x:0.546637744034707, y:0.23377581120944))
        tapPath.addLine(to: CGPoint(x:0.584598698481562, y:0.297197640117994))
        tapPath.close()
        muscleGroup.bezierPath = NSKeyedArchiver.archivedData(withRootObject: tapPath) as NSData
        let groupWorkoutMembership18 = NSEntityDescription.insertNewObject(forEntityName: "GroupWorkoutMembership", into: db.managedObjectContext) as! GroupWorkoutMembership
        muscleGroup.addToMembership(groupWorkoutMembership18)
        
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

