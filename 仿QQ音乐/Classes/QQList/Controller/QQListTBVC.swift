//
//  QQListTBVC.swift
//  仿QQ音乐
//
//  Created by huangbiyong on 2018/1/3.
//  Copyright © 2018年 com.chase. All rights reserved.
//

import UIKit

class QQListTBVC: UITableViewController {

    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    var musicMs: [QQMusicModel] = [QQMusicModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupInit()
        
        QQMusicDataTool.getMusicMs { (results) in
            self.musicMs = results
            QQMusicOperationTool.shareInstance.musicMs = results
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return musicMs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = QQMusicCell.cellWithTableView(tableView: tableView)
        cell.musicM = musicMs[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = musicMs[indexPath.row]
        QQMusicOperationTool.shareInstance.playMusic(musicM: model)
        self.performSegue(withIdentifier: "listToDetail", sender: nil)
        
    }
    

  
}

// 界面处理
extension QQListTBVC {
    
    func setupInit() {
        navigationController?.isNavigationBarHidden = true
        
        let imageView = UIImageView(image: UIImage(named: "QQListBack.jpg"))
        tableView.backgroundView = imageView
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }
}





















