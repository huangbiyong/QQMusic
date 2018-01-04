//
//  QQTimeTool.swift
//  仿QQ音乐
//
//  Created by huangbiyong on 2018/1/3.
//  Copyright © 2018年 com.chase. All rights reserved.
//

import UIKit

class QQTimeTool: NSObject {

    class func getFormatTime(timeInterval: TimeInterval) -> String {
        
        // timeInterval 21.123
        let min = Int(timeInterval) / 60
        let sec = Int(timeInterval) % 60
        
        return String(format: "%02d: %02d", min, sec)
        
    }
    
    class func getTimeInterval(formatTime: String) -> TimeInterval {
        
        // 00:33.20
        
        let minSec = formatTime.components(separatedBy: ":")
        if minSec.count != 2 {
            return 0
        }
        
        let min = TimeInterval(minSec[0]) ?? 0
        let sec = TimeInterval(minSec[1]) ?? 0
        
        return min * 60 + sec
    }
    
}
