//
//  QQMusicMessageModel.swift
//  仿QQ音乐
//
//  Created by huangbiyong on 2018/1/3.
//  Copyright © 2018年 com.chase. All rights reserved.
//

import UIKit

class QQMusicMessageModel: NSObject {

    var musicM: QQMusicModel?
    
    // 已经播放时间
    var costTime: TimeInterval = 0
    
    // 总时长
    var totalTime: TimeInterval = 0
    
    // 播放状态
    var isPlaying: Bool = false
}
