//
//  TrainingModel.swift
//  Trainingsplan
//
//  Created by Rakesh Kumar on 25/04/18.
//  Copyright © 2018 Ulrich Vormbrock. All rights reserved.
//

import UIKit
import CoreData

protocol TrainingModelDelegate {
    func didRetrieveWorkouts(groups:[Group])
    func showErrorMessage(message:String)
}

class TrainingModel: NSObject {
    var delegate:TrainingModelDelegate?
    func getWorkouts() {
        ApiHandler.call(apiName: API.Name.workout, params: [:], httpMethod: .GET) { (isSucceeded, response, data) in
            DispatchQueue.main.async {
                print(response)
                if isSucceeded == true {
                    guard let data = data else {return}
                    do {
                        let decoder = JSONDecoder()
                        let groupResponse = try decoder.decode(GroupResponse.self, from: data)
                        DispatchQueue.main.async {
                            if let groups = groupResponse.groups {
                                self.delegate?.didRetrieveWorkouts(groups: groups)
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
                }
            }
        }
    }
    
}