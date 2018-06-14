//
//  Torso.swift
//  sketchChanger
//
//  Created by Ulrich Vormbrock on 01.04.18.
//  Copyright © 2018 Ulrich Vormbrock. All rights reserved.
//

import UIKit
import CoreData

class Torso: NSObject {
    
    var index: Int
    var color: UIColor
    var muscleName: String
    var tapArea: UIBezierPath

    init(withIndex index: Int, color: UIColor, muscleName: String, tapArea: UIBezierPath) {
        self.index = index
        self.color = color
        self.muscleName = muscleName
        self.tapArea = tapArea
    }

}


class FrontView: NSObject {
    
    var dict: [Int: Torso]
    
    var fetchedResultsController: NSFetchedResultsController<Workout>!
    
    init(dict: [Int: Torso]) {
        self.dict = dict
    }
    
    convenience override init() {
        
        var frontResult: [Musclegroup]!
  
        do {
            let fetchRequest = NSFetchRequest<Musclegroup>(entityName: "Musclegroup")
            fetchRequest.predicate = NSPredicate(format: "isFront=1")
            frontResult = try CoreDataManager.sharedInstance.managedObjectContext.fetch(fetchRequest)

        } catch let error {
            print ("fetch task failed", error)
        }
        
        let tapPath_0 = UIBezierPath()
        tapPath_0.move(to: CGPoint(x:0.402542372881356, y:0.804702495201535))
        tapPath_0.addLine(to: CGPoint(x:0.406779661016949, y:0.562859884836852))
        tapPath_0.addLine(to: CGPoint(x:0.617231638418079, y:0.566698656429942))
        tapPath_0.addLine(to: CGPoint(x:0.616525423728814, y:0.804702495201535))
        tapPath_0.close()
        
        let tapPath_1 = UIBezierPath()
        tapPath_1.move(to: CGPoint(x:0.298728813559322, y:0.79126679462572))
        tapPath_1.addLine(to: CGPoint(x:0.282485875706215, y:0.59021113243762))
        tapPath_1.addLine(to: CGPoint(x:0.379943502824859, y:0.56190019193858))
        tapPath_1.addLine(to: CGPoint(x:0.375706214689266, y:0.80278310940499))
        tapPath_1.close()
        tapPath_1.move(to: CGPoint(x:0.725282485875706, y:0.789827255278311))
        tapPath_1.addLine(to: CGPoint(x:0.741525423728814, y:0.589251439539347))
        tapPath_1.addLine(to: CGPoint(x:0.644067796610169, y:0.566218809980806))
        tapPath_1.addLine(to: CGPoint(x:0.639830508474576, y:0.800383877159309))
        tapPath_1.close()
        
        let tapPath_2 = UIBezierPath()
        tapPath_2.move(to: CGPoint(x:0.437853107344633, y:0.36852207293666))
        tapPath_2.addLine(to: CGPoint(x:0.430084745762712, y:0.272552783109405))
        tapPath_2.addLine(to: CGPoint(x:0.509180790960452, y:0.295585412667946))
        tapPath_2.addLine(to: CGPoint(x:0.589689265536723, y:0.273512476007678))
        tapPath_2.addLine(to: CGPoint(x:0.57909604519774, y:0.367562380038388))
        tapPath_2.close()
        
        let tapPaths = [tapPath_0, tapPath_1, tapPath_2]
        
        var dict : [Int:Torso] = [:]
        
        var index: Int = 0
        
        for group in frontResult {
            dict[index] = Torso(withIndex: Int(group.id), color: (group.color?.colorFromString())!, muscleName: group.name!, tapArea: tapPaths[index])
            index+=1
        }

        self.init(dict: dict)
    }

}

class BackView: NSObject {
    
    var dict: [Int: Torso]
    
    init(dict: [Int: Torso]) {
        self.dict = dict
    }
    
    convenience override init() {
        
        var backResult: [Musclegroup]!
        
        do {
            let fetchRequest = NSFetchRequest<Musclegroup>(entityName: "Musclegroup")
            fetchRequest.predicate = NSPredicate(format: "isFront=0")
            backResult = try CoreDataManager.sharedInstance.managedObjectContext.fetch(fetchRequest)
            
        } catch let error {
            print ("fetch task failed", error)
        }

        let tapPath_0 = UIBezierPath()
        tapPath_0.move(to: CGPoint(x:0.365509761388286, y:0.792772861356932))
        tapPath_0.addLine(to: CGPoint(x:0.643167028199566, y:0.794985250737463))
        tapPath_0.addLine(to: CGPoint(x:0.505422993492408, y:0.553834808259587))
        tapPath_0.close()
        
        let tapPath_1 = UIBezierPath()
        tapPath_1.move(to: CGPoint(x:0.301518438177874, y:0.792035398230089))
        tapPath_1.addLine(to: CGPoint(x:0.303687635574837, y:0.751474926253687))
        tapPath_1.addLine(to: CGPoint(x:0.337310195227766, y:0.791297935103245))
        tapPath_1.close()
        tapPath_1.move(to: CGPoint(x:0.669197396963124, y:0.793510324483776))
        tapPath_1.addLine(to: CGPoint(x:0.710412147505423, y:0.794985250737463))
        tapPath_1.addLine(to: CGPoint(x:0.704989154013015, y:0.75))
        tapPath_1.close()
        
        let tapPath_2 = UIBezierPath()
        tapPath_2.move(to: CGPoint(x:0.426247288503254, y:0.297935103244838))
        tapPath_2.addLine(to: CGPoint(x:0.466377440347072, y:0.233038348082596))
        tapPath_2.addLine(to: CGPoint(x:0.546637744034707, y:0.23377581120944))
        tapPath_2.addLine(to: CGPoint(x:0.584598698481562, y:0.297197640117994))
        tapPath_2.close()
        
        let tapPath_3 = UIBezierPath()
        tapPath_3.move(to: CGPoint(x:0.336225596529284, y:0.38716814159292))
        tapPath_3.addLine(to: CGPoint(x:0.490238611713666, y:0.368731563421829))
        tapPath_3.addLine(to: CGPoint(x:0.52060737527115, y:0.367256637168142))
        tapPath_3.addLine(to: CGPoint(x:0.668112798264642, y:0.388643067846608))
        tapPath_3.addLine(to: CGPoint(x:0.546637744034707, y:0.541297935103245))
        tapPath_3.addLine(to: CGPoint(x:0.458785249457701, y:0.539085545722714))
        tapPath_3.close()
        
        let tapPath_4 = UIBezierPath()
        tapPath_4.move(to: CGPoint(x:0.206073752711497, y:0.452064896755162))
        tapPath_4.addLine(to: CGPoint(x:0.325379609544469, y:0.415191740412979))
        tapPath_4.addLine(to: CGPoint(x:0.378524945770065, y:0.482300884955752))
        tapPath_4.addLine(to: CGPoint(x:0.314533622559653, y:0.493362831858407))
        tapPath_4.addLine(to: CGPoint(x:0.223427331887202, y:0.48598820058997))
        tapPath_4.close()
        tapPath_4.move(to: CGPoint(x:0.626412429378531, y:0.47936660268714))
        tapPath_4.addLine(to: CGPoint(x:0.730225988700565, y:0.495681381957774))
        tapPath_4.addLine(to: CGPoint(x:0.778954802259887, y:0.486084452975048))
        tapPath_4.addLine(to: CGPoint(x:0.80225988700565, y:0.448656429942418))
        tapPath_4.addLine(to: CGPoint(x:0.675847457627119, y:0.412188099808061))
        tapPath_4.close()
        
        let tapPath_5 = UIBezierPath()
        tapPath_5.move(to: CGPoint(x:0.282485875706215, y:0.352207293666027))
        tapPath_5.addLine(to: CGPoint(x:0.411723163841808, y:0.313819577735125))
        tapPath_5.addLine(to: CGPoint(x:0.487994350282486, y:0.314299424184261))
        tapPath_5.addLine(to: CGPoint(x:0.514830508474576, y:0.314779270633397))
        tapPath_5.addLine(to: CGPoint(x:0.56638418079096, y:0.316698656429942))
        tapPath_5.addLine(to: CGPoint(x:0.593926553672316, y:0.312859884836852))
        tapPath_5.addLine(to: CGPoint(x:0.722457627118644, y:0.348848368522073))
        tapPath_5.addLine(to: CGPoint(x:0.694209039548023, y:0.371401151631478))
        tapPath_5.addLine(to: CGPoint(x:0.613700564971751, y:0.35700575815739))
        tapPath_5.addLine(to: CGPoint(x:0.516242937853107, y:0.351247600767754))
        tapPath_5.addLine(to: CGPoint(x:0.426553672316384, y:0.353646833013436))
        tapPath_5.addLine(to: CGPoint(x:0.314971751412429, y:0.374280230326296))
        tapPath_5.close()
        
        let tapPath_6 = UIBezierPath()
        tapPath_6.move(to: CGPoint(x:0.109463276836158, y:0.467850287907869))
        tapPath_6.addLine(to: CGPoint(x:0.150423728813559, y:0.399232245681382))
        tapPath_6.addLine(to: CGPoint(x:0.221045197740113, y:0.366122840690979))
        tapPath_6.addLine(to: CGPoint(x:0.257062146892655, y:0.357965451055662))
        tapPath_6.addLine(to: CGPoint(x:0.311440677966102, y:0.397792706333973))
        tapPath_6.addLine(to: CGPoint(x:0.221751412429379, y:0.428982725527831))
        tapPath_6.addLine(to: CGPoint(x:0.120762711864407, y:0.468330134357006))
        tapPath_6.close()
        tapPath_6.move(to: CGPoint(x:0.753531073446328, y:0.356525911708253))
        tapPath_6.addLine(to: CGPoint(x:0.833333333333333, y:0.384357005758157))
        tapPath_6.addLine(to: CGPoint(x:0.90183615819209, y:0.462092130518234))
        tapPath_6.addLine(to: CGPoint(x:0.887005649717514, y:0.468330134357006))
        tapPath_6.addLine(to: CGPoint(x:0.819209039548023, y:0.437619961612284))
        tapPath_6.addLine(to: CGPoint(x:0.690677966101695, y:0.400191938579655))
        tapPath_6.close()
        
        let tapPath_7 = UIBezierPath()
        tapPath_7.move(to: CGPoint(x:0.301553672316384, y:0.736084452975048))
        tapPath_7.addLine(to: CGPoint(x:0.29590395480226, y:0.68042226487524))
        tapPath_7.addLine(to: CGPoint(x:0.253531073446328, y:0.60700575815739))
        tapPath_7.addLine(to: CGPoint(x:0.229519774011299, y:0.506238003838772))
        tapPath_7.addLine(to: CGPoint(x:0.31638418079096, y:0.511516314779271))
        tapPath_7.addLine(to: CGPoint(x:0.391949152542373, y:0.497600767754319))
        tapPath_7.addLine(to: CGPoint(x:0.452683615819209, y:0.581094049904031))
        tapPath_7.addLine(to: CGPoint(x:0.444915254237288, y:0.627159309021113))
        tapPath_7.addLine(to: CGPoint(x:0.349576271186441, y:0.78214971209213))
        tapPath_7.addLine(to: CGPoint(x:0.331214689265537, y:0.760076775431862))
        tapPath_7.close()
        tapPath_7.move(to: CGPoint(x:0.656073446327684, y:0.776391554702495))
        tapPath_7.addLine(to: CGPoint(x:0.553672316384181, y:0.617562380038388))
        tapPath_7.addLine(to: CGPoint(x:0.55861581920904, y:0.575335892514395))
        tapPath_7.addLine(to: CGPoint(x:0.608050847457627, y:0.494241842610365))
        tapPath_7.addLine(to: CGPoint(x:0.689971751412429, y:0.510076775431862))
        tapPath_7.addLine(to: CGPoint(x:0.781779661016949, y:0.507197696737044))
        tapPath_7.addLine(to: CGPoint(x:0.754943502824859, y:0.606525911708253))
        tapPath_7.addLine(to: CGPoint(x:0.719632768361582, y:0.664107485604607))
        tapPath_7.addLine(to: CGPoint(x:0.703389830508475, y:0.731285988483685))
        tapPath_7.addLine(to: CGPoint(x:0.665960451977401, y:0.763915547024952))
        tapPath_7.close()
        
        let tapPaths = [tapPath_0, tapPath_1, tapPath_2, tapPath_3, tapPath_4, tapPath_5, tapPath_6, tapPath_7]
        
        var dict : [Int:Torso] = [:]
        
        var index: Int = 0
        
        for group in backResult {
            dict[index] = Torso(withIndex: Int(group.id), color: (group.color?.colorFromString())!, muscleName: group.name!, tapArea: tapPaths[index])
            index+=1
        }
        
        self.init(dict: dict)
    }
}
