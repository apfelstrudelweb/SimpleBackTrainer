//
//  VideoPlayerViewController.swift
//  Simple Back Trainer
//
//  Created by Ulrich Vormbrock on 14.06.18.
//  Copyright © 2018 Rookie. All rights reserved.
//

import UIKit
import AVKit

class VideoPlayerViewController: AVPlayerViewController {
    
    var videoUrl: String?
    
    var playerItem:AVPlayerItem?
    //var player:AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: videoUrl!)
        playerItem = AVPlayerItem(url: url!)
        player=AVPlayer(playerItem: playerItem!)
        player?.play()
    }

}
