//
//  VideoPlayerViewController.swift
//  Simple Back Trainer
//
//  Created by Ulrich Vormbrock on 14.06.18.
//  Copyright © 2018 Rookie. All rights reserved.
//

import UIKit
import AVKit
import RNCryptor

class VideoPlayerViewController: AVPlayerViewController {
    
    var playerItem: AVPlayerItem?

    let requiredAssetKeys = [
        "playable",
        "hasProtectedContent"
    ]
    
    var videoUrl: String?
    var subdir: String = "videos"


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileName = URL(fileURLWithPath: videoUrl!).lastPathComponent
       
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first!
        let videoPath = NSString(string: documentPath).appendingPathComponent(subdir) as String
        let destPath = NSString(string: videoPath).appendingPathComponent(fileName) as String
        
        
        do {
            try FileManager.default.createDirectory(atPath: videoPath, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
        
        if FileManager.default.fileExists(atPath: destPath) {
            print("file already exist at \(destPath)")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.playVideo(localPath: NSURL(fileURLWithPath: destPath))
            }
            
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: self.videoUrl!),
                let urlData = NSData(contentsOf: url) {

                DispatchQueue.main.async {
                    
                    urlData.write(to: NSURL(fileURLWithPath: destPath) as URL, atomically: true)
                    self.playVideo(localPath: NSURL(fileURLWithPath: destPath))
                }
            }
        }
    }
    
    @objc func finishVideo() {
//        print("Video Finished")
//        self.dismiss(animated: true) {
//            ReviewHandler.checkAndAskForReview()
//        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func playVideo(localPath:NSURL) {
        
        let asset = AVAsset(url: localPath as URL)
        
        playerItem = AVPlayerItem(asset: asset,
                                  automaticallyLoadedAssetKeys: requiredAssetKeys)

        player = AVPlayer(playerItem: playerItem)
        player?.seek(to: CMTimeMakeWithSeconds(Float64(0), 1))
        
        NotificationCenter.default.addObserver(self, selector: #selector(VideoPlayerViewController.finishVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        //self.showsPlaybackControls = false

//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            self.player?.play()
//            self.updateSubtitle()
//        }
   }
    

    
    func updateSubtitle() {
        
        // TODO: download srt files
        guard let subtitleURL = URL(string: "http://www.freiwasser.blog/spielwiese/peter/test1.srt") else {
            return
        }
        //self.addSubtitles(subtitlePosition: .bottom).open(file: subtitleURL, encoding: .utf8)
    }
}


