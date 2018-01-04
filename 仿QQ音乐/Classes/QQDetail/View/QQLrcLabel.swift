//
//  QQLrcLabel.swift
//  仿QQ音乐
//
//  Created by huangbiyong on 2018/1/4.
//  Copyright © 2018年 com.chase. All rights reserved.
//

import UIKit

class QQLrcLabel: UILabel {

    
    var radio: CGFloat = 0 {
        didSet {
            setNeedsDisplay()  //会自动调用 draw
        }
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 设置颜色
        UIColor.green.set()
        
        let fillRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width * radio, height: rect.size.height)
        UIRectFillUsingBlendMode(fillRect, .sourceIn)
    
    }


}
