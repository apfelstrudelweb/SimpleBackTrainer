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
    
    func insertWorkout(id:Int16, position:Int16, traininsgplanId:Plan?, name:String, descr:String,musclegroup:String?, imgName:String?, isFavorite:Bool) -> Workout {
        let workout = NSEntityDescription.insertNewObject(forEntityName: "Workout", into: self.managedObjectContext) as! Workout
        workout.id = id
        workout.position = position
        workout.traininsgplanId = traininsgplanId
        workout.name = name
        workout.descr = descr
        workout.musclegroup = musclegroup
        workout.imgName = imgName
        workout.isFavorite = isFavorite
        
        if let url = URL(string: (workout.imgName)!) {
            
            do {
                let data:NSData = try NSData(contentsOf: url)
                workout.icon = data
            } catch {
                NSLog("Error fetching file: \(String(describing: url))")
            }
            
        }

        do {
            try self.managedObjectContext.save()
        } catch let error {
            print("Failure to save context: \(error.localizedDescription)")
        }
        return workout
    }

    func insertMusclegroup(name:String?, color:String?, id:Int16, isFront:Bool, workouts:NSSet?){
        let muscleGroup = NSEntityDescription.insertNewObject(forEntityName: "Musclegroup", into: self.managedObjectContext) as! Musclegroup
        muscleGroup.name = name
        muscleGroup.color = color
        muscleGroup.id = id
        muscleGroup.isFront = isFront
        muscleGroup.workouts = workouts
    
        do {
            try self.managedObjectContext.save()
        } catch let error {
            print("Failure to save context: \(error.localizedDescription)")
        }
    }
    
    func updateMusclegroup(muscleGroup:Musclegroup, name:String?, color:String?, workouts:NSSet?) -> Musclegroup {
        muscleGroup.name = name
        muscleGroup.workouts = workouts
        muscleGroup.color = color
        do {
            try self.managedObjectContext.save()
        } catch let error {
            print("Failure to save context: \(error.localizedDescription)")
        }
        return muscleGroup
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
    
    func updateMusclegroup(serverGroupsData:[Group]?) {
        if let groups = serverGroupsData {
            for group in groups {
                let id = group.id
                if let muscleGroup = self.fetchMuscleGroup(id: id!) {
                    let workoutArray = NSMutableSet()
                    if let workouts = group.workouts {
                        for workout in workouts {
                            let localWorkout = self.fetchWorkout(workoutId:workout.id!, groupId: Int(muscleGroup.id))
                            if let localWorkout = localWorkout {
                                let updatedWorkout = self.updateWorkout(workout: localWorkout, data: workout, group: group.name!)
                                workoutArray.add(updatedWorkout)
                            } else {
                                let workout11 =  CoreDataManager.sharedInstance.insertWorkout(id: Int16(workout.id!), position: -1, traininsgplanId: nil, name: workout.name!, descr: workout.descr!, musclegroup: group.name, imgName: workout.image, isFavorite: false)
                                workoutArray.add(workout11)
                            }
                        }
                        
                        self.deleteWorkoutIfNotExistAnymore(muscleGroup: muscleGroup, workoutArray: workoutArray)

                        
                        let _ = self.updateMusclegroup(muscleGroup: muscleGroup, name: group.name, color:group.color, workouts: workoutArray)
                    }
                } else {
                    let workoutArray = NSMutableSet()
                    if let workouts = group.workouts {
                        for workout in workouts {
                            let workout11 =  CoreDataManager.sharedInstance.insertWorkout(id: Int16(workout.id!), position: -1, traininsgplanId: nil, name: workout.name!, descr: workout.descr!, musclegroup: group.name, imgName: workout.image, isFavorite: false)
                            workoutArray.add(workout11)
                        }
                        print(workoutArray.count)
                        
                        let _ = self.insertMusclegroup(name: group.name, color: group.color, id: Int16(group.id!), isFront: group.isFront!, workouts: workoutArray)
                    }
                }
                
            }
        }
        self.deleteGroupIfNotExistAnymore(serverGroupsData: serverGroupsData)
    }
    
    func deleteWorkoutIfNotExistAnymore(muscleGroup:Musclegroup, workoutArray:NSMutableSet) {
        if let existingWorkouts = muscleGroup.workouts {
            for exWorkout in existingWorkouts {
                let exWorkout = exWorkout as? Workout
                var isAvailable = false
                for currWorkout in workoutArray {
                    let currWorkout = currWorkout as? Workout
                    if (exWorkout?.id)! == (currWorkout?.id)! {
                        isAvailable = true
                        break
                    }
                }
                if isAvailable == false {
                    self.managedObjectContext.delete(exWorkout!)
                    
                    do {
                        try self.managedObjectContext.save() // <- remember to put this :)
                    } catch let error {
                        print("Cannot delete = ",error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func deleteGroupIfNotExistAnymore(serverGroupsData:[Group]?) {
        do {
            let fetchRequest = NSFetchRequest<Musclegroup>(entityName: "Musclegroup")
            let result = try self.managedObjectContext.fetch(fetchRequest)
            for group in result {
                var isAvailable = false
                if let newGroups = serverGroupsData {
                    for newGroup in newGroups {
                        if Int16(newGroup.id!) == group.id {
                            isAvailable = true
                            break
                        }
                    }
                }
                if isAvailable == false {
                    self.deleteWorkouts(workouts: group.workouts)
                    self.managedObjectContext.delete(group)
                    do {
                        try self.managedObjectContext.save() // <- remember to put this :)
                    } catch let error {
                        print("Cannot delete = ",error.localizedDescription)
                    }
                }
            }
            
        } catch let error {
            print ("fetch task failed", error)
        }
    }
    
    func deleteWorkouts(workouts:NSSet?) {
        if let existingWorkouts = workouts {
            for exWorkout in existingWorkouts {
                let exWorkout = exWorkout as? Workout
                self.managedObjectContext.delete(exWorkout!)
                do {
                    try self.managedObjectContext.save() // <- remember to put this :)
                } catch let error {
                    print("Cannot delete = ",error.localizedDescription)
                }
            }
        }
    }
    
    func updateWorkout(workout:Workout, data:WorkoutData, group: String) -> Workout {
        workout.name = data.name
        workout.descr = data.descr
        workout.imgName = data.image
        workout.musclegroup = group
        
        if let url = URL(string: (workout.imgName)!) {
            
            do {
                let data:NSData = try NSData(contentsOf: url)
                workout.icon = data
            } catch {
                NSLog("Error fetching file: \(String(describing: url))")
            }
            
        }
        
        do {
            try self.managedObjectContext.save()
        } catch let error {
            print("Failure to save context: \(error.localizedDescription)")
        }
        return workout
    }
    
    func fetchMuscleGroup(id:Int) -> Musclegroup? {
        do {
            let fetchRequest = NSFetchRequest<Musclegroup>(entityName: "Musclegroup")
            fetchRequest.predicate = NSPredicate(format: "id=%i", id)
            let result = try self.managedObjectContext.fetch(fetchRequest)
            return result.first
        } catch let error {
            print ("fetch task failed", error)
            return nil
        }
        
    }
    
    func fetchWorkout(workoutId:Int, groupId:Int) -> Workout? {
        do {
            let fetchRequest = NSFetchRequest<Workout>(entityName: "Workout")
            fetchRequest.predicate = NSPredicate(format: "id=%i and musclegroupId.id = %i", workoutId, groupId)
            let result = try self.managedObjectContext.fetch(fetchRequest)
            return result.first
        } catch let error {
            print ("fetch task failed", error)
            return nil
        }
        
    }
}
