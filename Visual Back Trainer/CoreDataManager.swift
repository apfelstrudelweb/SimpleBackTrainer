//
//  CoreDataManager.swift
//  
//
//  Created by Ulrich Vormbrock on 16/04/18.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {

    static let sharedInstance = CoreDataManager()
    
    typealias CompletionHander = () -> ()
    
    fileprivate override init() {
    
    }
    
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.andrewcbancroft.Zootastic" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Trainingsplan", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        //        let url = self.applicationDocumentsDirectory.appendingPathComponent("Trainingsplan.sqlite")
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let storeURL = url?.appendingPathComponent("Trainingsplan.sqlite")
        
        print("SQLite in \(String(describing: storeURL))")
        
        
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    fileprivate func clearDB() {
        // Override point for customization after application launch.
        
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let storeURL = url?.appendingPathComponent("Trainingsplan.sqlite")
        
        let fm = FileManager.default
        do {
            try fm.removeItem(at:storeURL!)
        } catch {
            NSLog("Error deleting file: \(String(describing: storeURL))")
        }
    }
    

    func insertWorkout(id:Int16, imgName: String?, isFavorite: Bool, isLive: Bool, isPremium: Bool, alias: String?, videoUrl: String?, isDumbbell: Bool, isMat: Bool, isBall: Bool, isTheraband: Bool, isMachine: Bool, intensity: Int16, musclegroupIds: [Int]) -> Workout {
        
        let workout = NSEntityDescription.insertNewObject(forEntityName: "Workout", into: self.managedObjectContext) as! Workout
        
        workout.id = id
        workout.imgName = imgName
        workout.isFavorite = isFavorite
        workout.isLive = isLive
        workout.isPremium = isPremium
        workout.alias = alias
        workout.videoUrl = videoUrl
        workout.isDumbbell = isDumbbell
        workout.isMat = isMat
        workout.isBall = isBall
        workout.isTheraband = isTheraband
        workout.isMachine = isMachine
        workout.intensity = intensity
        
        var predicates = [NSPredicate]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Musclegroup")

        for musclegroupId in musclegroupIds {
            predicates.append(NSPredicate(format: "id = %d", musclegroupId))
        }
        
        let compound:NSCompoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        fetchRequest.predicate = compound
        
        do {
            let musclegroups = try self.managedObjectContext.fetch(fetchRequest)
            
            let set = NSSet(array : musclegroups)
 
            
            workout.musclegroupId = set
            print (musclegroups)
            
        } catch {
            NSLog("Musclegroup with ids=\(musclegroupIds) not found")
        }
        
        if let url = URL(string: (workout.imgName)!) {
            
            do {
                let data:NSData = try NSData(contentsOf: url)
                workout.icon = data
            } catch {
                NSLog("Error fetching file: \(String(describing: url))")
            }
        }
        return workout
    }

    
    func insertTrainingsPlan(id:Int16, workouts:NSSet?) -> Plan {
        let trainingsplan = NSEntityDescription.insertNewObject(forEntityName: "Plan", into: self.managedObjectContext) as! Plan
        trainingsplan.id = id
        trainingsplan.workouts = workouts
       
        do {
            try self.managedObjectContext.save()
        } catch let error {
            print("Failure to save context: \(error.localizedDescription)")
        }
        return trainingsplan
    }
    
    func updateWorkouts(serverWorkoutsData:[WorkoutData]?, completionHandler: CompletionHander?) {
        if let workouts = serverWorkoutsData {
  
            // first save all favorites
            let favoriteSet = NSMutableSet()
            
            do {
                let fetchRequest = NSFetchRequest<Workout>(entityName: "Workout")
                fetchRequest.predicate = NSPredicate(format: "isFavorite = true")
                let results = try CoreDataManager.sharedInstance.managedObjectContext.fetch(fetchRequest)
                
                for result in results {
                    favoriteSet.add(result.id)
                }
  
            } catch let error {
                print ("fetch task failed", error)
            }
            
            // delete old data
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Workout")
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            do {
                try managedObjectContext.execute(request)
            } catch let error {
                NSLog("Failure to delete context: \(error.localizedDescription)")
            }
            
            for workout in workouts {
                
                let isFavorite = favoriteSet.contains(workout.id!)
                
                let _ = CoreDataManager.sharedInstance.insertWorkout(id: Int16(workout.id!), imgName: workout.imageName, isFavorite: isFavorite, isLive: workout.isLive==1, isPremium: workout.isPremium==1, alias: workout.alias, videoUrl: workout.videoUrl!, isDumbbell: workout.isDumbbell==1, isMat: workout.isMat==1, isBall: workout.isBall==1, isTheraband: workout.isTheraband==1, isMachine: workout.isMachine==1, intensity: Int16(workout.intensity!), musclegroupIds: workout.musclegroups!)
            }
            
            do {
                try self.managedObjectContext.save()
            } catch let error {
                NSLog("Failure to save context: \(error.localizedDescription)")
            }
        }

        completionHandler?()
    }
}
