//
//  QQLrcTVC.swift
//  仿QQ音乐
//
//  Created by huangbiyong on 2018/1/4.
//  Copyright © 2018年 com.chase. All rights reserved.
//

import UIKit

class QQLrcTVC: UITableViewController {

    var lrcMs: [QQLrcModel] = [QQLrcModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var scrollRow = 0 {
        didSet {
            if scrollRow == oldValue {
                return
            }
            
            // 先刷新，再滚动
            let indexPaths = tableView.indexPathsForVisibleRows
            tableView.reloadRows(at: indexPaths!, with: .fade)
            
            let indexPath = IndexPath(row: scrollRow, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
    }
    
    var progress: CGFloat = 0 {
        didSet {
            let indexPath = IndexPath(row: scrollRow, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as? QQLrcCell
            
            cell?.progress = progress
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = .none
        
        self.tableView.rowHeight = 50
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.height * 0.5, 0, self.tableView.height * 0.5, 0)

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lrcMs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        let cell = QQLrcCell.cellWidthTableView(tableView)
        
        let model = lrcMs[indexPath.row]
        cell.lrcContent = model.lrcContent
        
        if indexPath.row == scrollRow {
            cell.progress = progress
        } else {
            cell.progress = 0
        }
        
        return cell
    }
}







