//
//  QQImageTool.swift
//  仿QQ音乐
//
//  Created by huangbiyong on 2018/1/4.
//  Copyright © 2018年 com.chase. All rights reserved.
//

import UIKit

class QQImageTool: NSObject {

    class func getNewImage(sourceImage: UIImage?, str: String?) -> UIImage? {
        
        // 0. 容错处理
        guard let image = sourceImage else {
            return nil
        }
        
        guard let resultStr = str else {
            return image
        }
        
        // 1. 开启图形上下文
        UIGraphicsBeginImageContext(image.size)
        
        // 2. 绘制大图片
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        // 3. 绘制文字
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        let textAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),
            NSAttributedStringKey.paragraphStyle: style
        ]
        (resultStr as NSString).draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: 18), withAttributes: textAttributes)
        
        // 4. 取出图片
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 5. 关闭上下文
        UIGraphicsEndImageContext()
        
        return resultImage
    }
    
}



















