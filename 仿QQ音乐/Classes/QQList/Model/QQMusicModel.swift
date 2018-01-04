//
//  QQMusicModel.swift
//  仿QQ音乐
//
//  Created by huangbiyong on 2018/1/3.
//  Copyright © 2018年 com.chase. All rights reserved.
//

import UIKit

class QQMusicModel: NSObject {

    // 歌曲名称
    var name: String?

    // 歌曲文件名称
    var filename: String?

    // 歌词文件名称
    var lrcname: String?

    // 歌手名称
    var singer: String?

    // 歌手头像名称
    var singerIcon: String?

    // 专辑头像图片
    var icon: String?

    override init() {
        super.init()
    }
    
    init(dic: [String: AnyObject]) {
        super.init()
        
        //setValuesForKeys(dic)
        
        name = dic["name"] as? String
        filename = dic["filename"] as? String
        lrcname = dic["lrcname"] as? String
        singer = dic["singer"] as? String
        singerIcon = dic["singerIcon"] as? String
        icon = dic["icon"] as? String
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
