//
//  QQMusicCell.swift
//  仿QQ音乐
//
//  Created by huangbiyong on 2018/1/3.
//  Copyright © 2018年 com.chase. All rights reserved.
//

import UIKit

enum AnimationType {
    case Rotation
    case Transition
    case Scale
}

class QQMusicCell: UITableViewCell {

    @IBOutlet weak var singerIconImageView: UIImageView!
    
    @IBOutlet weak var songNameLabel: UILabel!
    
    @IBOutlet weak var singerNameLabel: UILabel!
    
    var musicM: QQMusicModel? {
        didSet {
            
            guard let musicM = musicM else {
                return
            }
            
            singerIconImageView.image = UIImage.init(named: (musicM.singerIcon)!)
            songNameLabel.text = musicM.name
            singerNameLabel.text = musicM.singer
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        singerIconImageView.layer.cornerRadius = singerIconImageView.width * 0.5
        singerIconImageView.layer.masksToBounds = true
    }
    
    
    class func cellWithTableView(tableView: UITableView) -> QQMusicCell {
        
        // 一定要cell de xib, 里面添加循环利用的标示
        let cellID = "music"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? QQMusicCell
        if cell == nil {
            //print("test")
            cell = Bundle.main.loadNibNamed("QQMusicCell", owner: nil, options: nil)?.first as? QQMusicCell
        }
        
        return cell!
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func aniation(type: AnimationType) {
        
        if type == .Rotation {
            
            self.layer.removeAnimation(forKey: "Rotation")
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            animation.values = [-1/6 * M_PI, 0, 1/6 * M_PI, 0]
            animation.duration = 0.2
            animation.repeatCount = 3
            self.layer.add(animation, forKey: "Rotation")
        } else if type == .Scale {
            self.layer.removeAnimation(forKey: "Scale")
            let animation = CAKeyframeAnimation(keyPath: "transform.scale.x")
            animation.values = [0.5, 1, 0.5, 1]
            animation.duration = 0.2
            animation.repeatCount = 2
            self.layer.add(animation, forKey: "Scale")
        }
        
    }
    
    
    
}























