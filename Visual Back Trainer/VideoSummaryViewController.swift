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
    
    
    // TODO: localize labels also
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBarAppearace = UINavigationBar.appearance()
        
        cancelButton.tintColor = navigationBarAppearace.barTintColor
        
        var locale = NSLocale(localeIdentifier: Locale.current.languageCode!)
        
        if let savedAppLanguage = UserDefaults.standard.object(forKey: "AppLanguage") as? String {
            locale = NSLocale(localeIdentifier: savedAppLanguage)
        }
        
        let predicate = NSPredicate(format: "language == %@", locale.languageCode)
        
//        guard let titles = workout?.titles?.filtered(using: predicate), titles.count > 0, let instructions = workout?.instructions?.filtered(using: predicate), instructions.count > 0, let remarks = workout?.remarks?.filtered(using: predicate), remarks.count > 0 else {
//            return
//        }
        
        if let titles = workout?.titles?.filtered(using: predicate), titles.count > 0 {
            let title = titles.first as! Title
            videoTitleLabel.text = title.text
        }
        
        if let instructions = workout?.instructions?.filtered(using: predicate), instructions.count > 0 {
            var instructionList = [String]()
            for instruction in instructions {
                instructionList.append((instruction as! Instruction).text ?? "")
            }
            guidelineText.attributedText = add(stringList: instructionList, font: guidelineText.font)
        }
        
        if let remarks = workout?.remarks?.filtered(using: predicate), remarks.count > 0 {
            var remarkList = [String]()
            for remark in remarks {
                remarkList.append((remark as! Remark).text ?? "")
            }
            changeIntensityText.attributedText = add(stringList: remarkList, font: guidelineText.font)
        }
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
