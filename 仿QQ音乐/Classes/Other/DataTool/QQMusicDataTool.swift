//
//  QQMusicDataTool.swift
//  仿QQ音乐
//
//  Created by huangbiyong on 2018/1/3.
//  Copyright © 2018年 com.chase. All rights reserved.
//

import UIKit

class QQMusicDataTool: NSObject {

    
    class func getMusicMs(result: ([QQMusicModel])->()) {
        guard let path = Bundle.main.path(forResource: "Musics.plist", ofType: nil) else {
            result([QQMusicModel]())
            return
        }
        
        guard let array = NSArray(contentsOfFile: path) else {
            result([QQMusicModel]())
            return
        }
        
        var models = [QQMusicModel]()
        for dic in array {
            let model = QQMusicModel(dic: dic as! [String: AnyObject])
            models.append(model)
        }
        
        result(models)
    }
    
    
    class func getLrcMs(lrcName: String?) -> [QQLrcModel] {
        
        if lrcName == nil {
            return [QQLrcModel]()
        }
        
        guard let path = Bundle.main.path(forResource: lrcName, ofType: nil) else {
            return [QQLrcModel]()
        }
        
        var lrcContent = ""
        do {
            lrcContent = try String(contentsOfFile: path)
        }catch {
            return [QQLrcModel]()
        }
        
        //print(lrcContent)
        
        let timeContentArray = lrcContent.components(separatedBy: "\n")
        
        var lrcs = [QQLrcModel]()
        
        for timeContentStr in timeContentArray {
            
            // 过滤垃圾数据
            if timeContentStr.contains("[ti:") || timeContentStr.contains("[ar:") || timeContentStr.contains("[al:") {
                continue
            }
            
            // 去除 [
            let resultLrcStr = timeContentStr.replacingOccurrences(of: "[", with: "")
            //print(resultLrcStr)
            
            let timeAndCotent = resultLrcStr.components(separatedBy: "]")
            if timeAndCotent.count != 2 {
                continue
            }
            
            let time = timeAndCotent[0]
            let content = timeAndCotent[1]
            
            // 创建歌词数据模型，进行赋值
            let lrc = QQLrcModel()
            lrc.beginTime = QQTimeTool.getTimeInterval(formatTime: time)
            lrc.lrcContent = content
            
            lrcs.append(lrc)
        }
        
        let count = lrcs.count
        for i in 0..<count {
            
            if i == count - 1 {
                continue
            }
            
            let lrcM = lrcs[i]
            let nextLrcM = lrcs[i+1]
            lrcM.endTime = nextLrcM.beginTime
        }
        
        return lrcs
    }
    
    
    class func getCurrentLrcM(currentTime: TimeInterval, lrcMs: [QQLrcModel]) -> (row: Int, lrcM: QQLrcModel?) {
        var index = 0
        for lrcM in lrcMs {
            if currentTime >= lrcM.beginTime && currentTime < lrcM.endTime {
                return (index, lrcM)
            }
            
            index += 1
        }
        return (0, nil)
    }
    
}


















