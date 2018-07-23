//
//  TrainingModel.swift
//  Trainingsplan
//
//  Created by Ulrich Vormbrock on 25/04/18.
//  Copyright © 2018 Ulrich Vormbrock. All rights reserved.
//

import UIKit
import CoreData

protocol TrainingModelDelegate {
    func didRetrieveWorkouts(workouts:[WorkoutData])
    func didRetrieveTrainingsplan(exercises:[TrainingsplanData])
    func showErrorMessage(message:String)
}

class TrainingModel: NSObject {
    var delegate:TrainingModelDelegate?
    
    typealias PrecheckCompletionHander = (Bool) -> ()
    
    // updates only for workouts, not for trainingsplan
    func hasUpdates(completionHandler : PrecheckCompletionHander?)  {
        
        ApiHandler.hasUpdates(apiName: API.Name.workout, params: [:], httpMethod: .GET) { (isSucceeded) in
            
            DispatchQueue.main.async {
                completionHandler?(isSucceeded)
            }
        }
    }
    
    typealias CompletionHander = () -> ()
    
    func getWorkouts(completionHandler : CompletionHander?) {
        ApiHandler.call(apiName: API.Name.workout, params: [:], httpMethod: .GET) { (isSucceeded, response, data) in
            DispatchQueue.main.async {
                print(response)
                if isSucceeded == true {
                    guard let data = data else {return}
                    do {
                        let decoder = JSONDecoder()
                        let workoutResponse = try decoder.decode(WorkoutResponse.self, from: data)

                        print(workoutResponse)
                        
                        DispatchQueue.main.async {
                            if let workouts = workoutResponse.workouts {
                                self.delegate?.didRetrieveWorkouts(workouts: workouts)
                                
                                completionHandler?()
                            }
                        }
                    } catch let err {
                        print(err)
                        self.delegate?.showErrorMessage(message: err.localizedDescription)
                    }
                } else {
                    
                    let context = CoreDataManager.sharedInstance.managedObjectContext
                    let fetchRequest : NSFetchRequest<Musclegroup> = Musclegroup.fetchRequest()
                    var count = 0
                    
                    do {
                        count = try context.count(for: fetchRequest)
                    } catch let error as NSError {
                        print("Error: \(error.localizedDescription)")
                    }
                    
                    if count == 0 {
                        if let message = response["message"] as? String {
                            self.delegate?.showErrorMessage(message: message)
                        }
                    }
                    
                    completionHandler?()
                }
            }
        }
    }
    
    func getTrainingsplan(completionHandler : CompletionHander?) {
        ApiHandler.call(apiName: API.Name.plan, params: [:], httpMethod: .GET) { (isSucceeded, response, data) in
            DispatchQueue.main.async {
                print(response)
                if isSucceeded == true {
                    guard let data = data else {return}
                    do {
                        let decoder = JSONDecoder()
                        let planResponse = try decoder.decode(TrainingsplanResponse.self, from: data)
                        
                        print(planResponse)
                        
                        DispatchQueue.main.async {
                            if let exercises = planResponse.exercises {
                                self.delegate?.didRetrieveTrainingsplan(exercises: exercises)
                                completionHandler?()
                            }
                        }
                    } catch let err {
                        print(err)
                        self.delegate?.showErrorMessage(message: err.localizedDescription)
                    }
                }
            }
        }
        
    }
    
}
