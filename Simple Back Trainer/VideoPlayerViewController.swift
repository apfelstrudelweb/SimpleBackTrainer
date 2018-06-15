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

class VideoPlayerViewController: AVPlayerViewController, AVAssetResourceLoaderDelegate {
    
    var videoUrl: String?
    var subdir: String = "videos"
    
    var password = "dsafsd/1243kgsdfgsdf=41243#*#fadsfasd"
    
    var ENCRYPTED_DATA: Data?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileName = URL(fileURLWithPath: videoUrl!).lastPathComponent
       
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first!
        let videoPath = NSString(string: documentPath).appendingPathComponent(subdir) as String
        let destPath = NSString(string: videoPath).appendingPathComponent(fileName) as String
        
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
                    
//                    let encryptedData = RNCryptor.encrypt(data: urlData as Data, withPassword: self.password)
//                    self.ENCRYPTED_DATA = encryptedData
//
//                    do {
//                        try FileManager.default.createDirectory(at: URL(fileURLWithPath: videoPath), withIntermediateDirectories: true, attributes: [.protectionKey: FileProtectionType.complete])
//                    } catch let error as NSError  {
//                        print(error)
//                    }
//
//                    do {
//                        try encryptedData.write(to: NSURL(fileURLWithPath: destPath) as URL)
//                    } catch let error as NSError  {
//                        print(error)
//                    }

                    self.playVideo(localPath: NSURL(fileURLWithPath: destPath))
                }
            }
        }
    }
    
    private func playVideo(localPath:NSURL) {
        
//        var decryptedData: Data? = nil
//
//        do {
//            let encryptedData = try Data(contentsOf: localPath as URL)
//            decryptedData = try RNCryptor.decrypt(data: self.ENCRYPTED_DATA!, withPassword: self.password) as Data
//            //print(decryptedData)
//        } catch let error as NSError  {
//            print(error)
//        }
//
//        let asset = AVURLAsset(url: localPath as URL, options: nil)
//        asset.resourceLoader.setDelegate(self, queue: DispatchQueue.main)

        let playerItem = AVPlayerItem(url: localPath as URL)
        
        player = AVPlayer(playerItem: playerItem)
        player?.seek(to: CMTimeMakeWithSeconds(Float64(0), 1))
        player?.play()
    }
    
//    func resourceLoader(resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
//
//        NSLog("This method is never called in case of m3u8 url")
//
//        return true
//    }
}

extension AVPlayer {
    
    convenience init(data:Data!) {
        
        if  let urlString = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) {
            self.init(url: NSURL(string: urlString as String)! as URL)
            
        } else {
            self.init()
        }
        
    }
}

extension String {
    
    var data: Data {
        if let data = self.data(using: .utf8) {
            return data
        } else {
            return Data()
        }
    }
}
