//
//  VideoSummaryViewController.swift
//  Visual Back Trainer
//
//  Created by Ulrich Vormbrock on 14.09.18.
//  Copyright © 2018 Rookie. All rights reserved.
//

import UIKit

class VideoSummaryViewController: UIViewController {
    
    var workout: Workout?
    
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var devicesLabel: UILabel!
    @IBOutlet weak var intensityText: UILabel!
    @IBOutlet weak var devicesText: UILabel!
    @IBOutlet weak var guidelineLabel: UILabel!
    @IBOutlet weak var guidelineText: UILabel!
    @IBOutlet weak var changeIntensityLabel: UILabel!
    @IBOutlet weak var changeIntensityText: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBarAppearace = UINavigationBar.appearance()
        
        cancelButton.tintColor = navigationBarAppearace.barTintColor
  
        videoTitleLabel.text = workout?.alias  // TODO: change later
        
        let guidelineList = [
            "Unteren Rücken flach auf der Matte halten.",
            "Ausgangsposition: Beine auf 90° anwinkeln und Füße hüftbreit positionieren.",
            "Oberkörper fast bis zur Senkrechten anheben und dabei ausatmen.",
            "In der Endposition Spannung 2 Sekunden lang halten.",
            "Anschließend den oberkörper langsam aber nicht ganz absenken und dabei einatmen.",
            "Weitere Wiederholungen bis zur Muskelerschöpfung durchführen."
        ]
        
        guidelineText.attributedText = add(stringList: guidelineList, font: guidelineText.font)
        
        let changeInensityList = [
            "Sind keine 8 Wiederholungen möglich, so kann man die Arme seitlich am Rumpf halten.",
            "Bei mehr als 12 Wiederholungen kann man die Übung intensivieren, indem man Gewichtsscheiben auf die Brust legt."
        ]
        
        changeIntensityText.attributedText = add(stringList: changeInensityList, font: guidelineText.font)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let viewController = segue.destination as? VideoPlayerViewController {
            viewController.videoUrl = workout?.videoUrl
        }
    }
    
    func add(stringList: [String],
             font: UIFont,
             bullet: String = "\u{2022}",
             indentation: CGFloat = 20,
             lineSpacing: CGFloat = 1,
             paragraphSpacing: CGFloat = 8,
             textColor: UIColor = .darkGray,
             bulletColor: UIColor = .darkGray) -> NSAttributedString {
        
        let textAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: textColor]
        let bulletAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: bulletColor]
        
        let paragraphStyle = NSMutableParagraphStyle()
        let nonOptions = [NSTextTab.OptionKey: Any]()
        paragraphStyle.tabStops = [
            NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
        paragraphStyle.defaultTabInterval = indentation
        //paragraphStyle.firstLineHeadIndent = 0
        //paragraphStyle.headIndent = 20
        //paragraphStyle.tailIndent = 1
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.headIndent = indentation
        
        let bulletList = NSMutableAttributedString()
        for string in stringList {
            let formattedString = "\(bullet)\t\(string)\n"
            let attributedString = NSMutableAttributedString(string: formattedString)
            
            attributedString.addAttributes(
                [NSAttributedStringKey.paragraphStyle : paragraphStyle],
                range: NSMakeRange(0, attributedString.length))
            
            attributedString.addAttributes(
                textAttributes,
                range: NSMakeRange(0, attributedString.length))
            
            let string:NSString = NSString(string: formattedString)
            let rangeForBullet:NSRange = string.range(of: bullet)
            attributedString.addAttributes(bulletAttributes, range: rangeForBullet)
            bulletList.append(attributedString)
        }
        
        return bulletList
    }

    @IBAction func cancelButtonTouched(_ sender: UIButton) {
        self.dismiss(animated: true) {
            // TODO: make sure it's only called once!
            ReviewHandler.checkAndAskForReview()
        }
    }
    
}
