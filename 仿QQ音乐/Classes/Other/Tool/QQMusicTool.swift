//
//  QQMusicTool.swift
//  仿QQ音乐
//
//  Created by huangbiyong on 2018/1/3.
//  Copyright © 2018年 com.chase. All rights reserved.
//

import UIKit
import AVFoundation

let kPlayFinishNotification = "playFinish"

class QQMusicTool: NSObject {

    override init() {
        super.init()
        
        // 获取音频会话
        let session = AVAudioSession.sharedInstance()
        
        do {
            
            // 2. 设置会话类别
            try session.setCategory(AVAudioSessionCategoryPlayback)
            
            // 3. 激活会话
            try session.setActive(true)
            
        } catch {
            print(error)
        }
    }
    
    
    var player: AVAudioPlayer?
    
    func playMusic(musicName: String?) {
        
        guard let url = Bundle.main.url(forResource: musicName, withExtension: nil) else {
            return
        }
        
        if player?.url == url {
            player?.play()
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.delegate = self
            player?.play()
        } catch {
            
        }
        
    }
    
    func pauseMusic() {
        player?.pause()
    }
    
    func seekToTime(time: TimeInterval) -> () {
        player?.currentTime = time
    }
    
}

extension QQMusicTool: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("播放完成")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kPlayFinishNotification), object: nil)
        
    }
}















