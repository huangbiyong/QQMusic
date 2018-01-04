//
//  QQLrcCell.swift
//  仿QQ音乐
//
//  Created by huangbiyong on 2018/1/4.
//  Copyright © 2018年 com.chase. All rights reserved.
//

import UIKit

class QQLrcCell: UITableViewCell {

    
    @IBOutlet weak var lrcLabel: QQLrcLabel!
    
    var lrcContent = "" {
        didSet {
            lrcLabel.text = lrcContent
        }
    }
    
    var progress: CGFloat = 0 {
        didSet {
            lrcLabel.radio = progress
        }
    }
    
    
    class func cellWidthTableView(_ tableView: UITableView) -> QQLrcCell {
        let cellID = "lrc"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? QQLrcCell
        
        if cell == nil {
            cell = Bundle.main.loadNibNamed("QQLrcCell", owner: nil, options: nil)?.first as? QQLrcCell
            
            // 设置界面
            cell?.selectionStyle = .none
            cell?.backgroundColor = UIColor.clear
            cell?.textLabel?.textColor = UIColor.white
            cell?.textLabel?.textAlignment = .center
        }
        return cell!
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
