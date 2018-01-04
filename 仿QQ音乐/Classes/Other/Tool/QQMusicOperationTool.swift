//
//  QQMusicOperationTool.swift
//  仿QQ音乐
//
//  Created by huangbiyong on 2018/1/3.
//  Copyright © 2018年 com.chase. All rights reserved.
//

import UIKit
import MediaPlayer

class QQMusicOperationTool: NSObject {

    static let shareInstance = QQMusicOperationTool()
    
    fileprivate var musicModel = QQMusicMessageModel()
    
    // 播放的音乐列表
    var musicMs: [QQMusicModel] = [QQMusicModel]()
    
    let tool = QQMusicTool()
    
    func getMusicMessageModel() -> QQMusicMessageModel {
        
        musicModel.musicM = musicMs[currentPlayIndex]
        
        musicModel.costTime = (tool.player?.currentTime) ?? 0
        //print(musicModel.costTime)
        musicModel.totalTime = (tool.player?.duration) ?? 0
        
        musicModel.isPlaying = (tool.player?.isPlaying) ?? false
        
        return musicModel
    }
    
    var currentPlayIndex = -1 {
        didSet {
            if currentPlayIndex < 0 {
                currentPlayIndex = musicMs.count - 1
            } else if currentPlayIndex > musicMs.count - 1 {
                currentPlayIndex = 0
            }
        }
    }
    
    
    // 播放
    func playMusic(musicM: QQMusicModel) {
        tool.playMusic(musicName: musicM.filename)
        currentPlayIndex = musicMs.index(of: musicM)!
    }
    
    func playCurrentMusic() {
        // 取出需要播放的音乐数据模型
        let model = musicMs[currentPlayIndex]
        
        // 播放音乐模型
        playMusic(musicM: model)
    }
    
    
    // 暂停
    func pauseCurrentMusic() {
        tool.pauseMusic()
    }
    
    // 下一首
    func nextMusic() -> () {
        
        currentPlayIndex += 1
        
        // 取出需要播放的音乐数据模型
        let model = musicMs[currentPlayIndex]
        
        // 根据音乐模型, 进行播放
        playMusic(musicM: model)
        
    }
    
    // 上一首
    func preMusic() -> () {
        
        currentPlayIndex -= 1
        
        // 取出需要播放的音乐数据模型
        let model = musicMs[currentPlayIndex]
        
        // 根据音乐模型, 进行播放
        playMusic(musicM: model)
        
    }

    
    var artWork: MPMediaItemArtwork?
    var lastRow: Int = 0
    
    // 设置锁屏界面
    func setupLockMessage() {
        // 去出需要展示的数据模型
        let musicMessageM = getMusicMessageModel()
        
        // 1. 获取锁屏中心
        let center = MPNowPlayingInfoCenter.default()
        
        
        // 2. 给锁屏中心赋值
        let musicName = musicMessageM.musicM?.name ?? ""
        let singerName = musicMessageM.musicM?.singer ?? ""
        let consTime = musicMessageM.costTime
        let totalTime = musicMessageM.totalTime
        
        let imageName = musicMessageM.musicM?.icon ?? ""
        let image = UIImage(named: imageName)
        
        
        // 3. 设置锁屏歌词
        // 3.1 获取当前正在播放的歌词
        let lrcFileName = musicMessageM.musicM?.lrcname
        let lrcMs = QQMusicDataTool.getLrcMs(lrcName: lrcFileName)
        let rowAndLrcMs = QQMusicDataTool.getCurrentLrcM(currentTime: musicMessageM.costTime, lrcMs: lrcMs)
        
        let lrcM = rowAndLrcMs.lrcM
        let lrcRow = rowAndLrcMs.row
        
        // 3.2 歌词绘制到图片，生成一个新的图片
        var resultImage: UIImage?
        
        
        // 优化
        if lastRow != lrcRow {
            lastRow = lrcRow
            resultImage = QQImageTool.getNewImage(sourceImage: image, str: lrcM?.lrcContent)
        }
        
        
        var nowPlayingInfo = [MPMediaItemPropertyAlbumTitle: musicName,
                              MPMediaItemPropertyArtist: singerName,
                              MPMediaItemPropertyPlaybackDuration: totalTime,
                              MPNowPlayingInfoPropertyElapsedPlaybackTime: consTime] as [String : Any]
        
        if resultImage != nil {
            artWork = MPMediaItemArtwork(image: resultImage!)
        }
        
        if artWork != nil {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = artWork!
        }
        
        center.nowPlayingInfo = nowPlayingInfo
        
        // 3. 接收远程事件
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    func seekToTime(time: TimeInterval) -> () {
        tool.seekToTime(time: time)
    }
    
}























