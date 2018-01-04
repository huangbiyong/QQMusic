//
//  CALayer+Extension.swift
//  仿QQ音乐
//
//  Created by huangbiyong on 2018/1/4.
//  Copyright © 2018年 com.chase. All rights reserved.
//

import UIKit


extension CALayer {
    
    // 暂停动画
    func pauseAnimation() {
        let pausedTime: CFTimeInterval = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0.0
        timeOffset = pausedTime
    }
    
    func resumeAnimation() {
        let pausedTime: CFTimeInterval = timeOffset
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        let timeSincePause: CFTimeInterval = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        beginTime = timeSincePause
    }
}

















