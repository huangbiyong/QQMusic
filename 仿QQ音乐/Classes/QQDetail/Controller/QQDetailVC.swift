//
//  QQDetailVC.swift
//  仿QQ音乐
//
//  Created by huangbiyong on 2018/1/3.
//  Copyright © 2018年 com.chase. All rights reserved.
//

import UIKit

class QQDetailVC: UIViewController {

    /** 歌词动画背景 */
    @IBOutlet weak var lrcScrollView: UIScrollView!
    
    // 分析界面, 根据不同的更新频率, 采用不同的方案赋值
    
    /** 背景图片 1 */
    @IBOutlet weak var backImageView: UIImageView!
    
    /** 前进图片 1*/
    @IBOutlet weak var foreImageView: UIImageView!
    
    /** 歌曲名称 1*/
    @IBOutlet weak var songNameLabel: UILabel!
    
    /** 歌手名称 1*/
    @IBOutlet weak var singerNameLabel: UILabel!
    
    /** 总时长 1*/
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    // 歌词的视图 1
    lazy var lrcTVC: QQLrcTVC = {
        return QQLrcTVC()
    }()
    
    
    /** 歌词label n */
    @IBOutlet weak var lrcLabel: QQLrcLabel!
    
    /** 进度条 n*/
    @IBOutlet weak var progressSlider: UISlider!
    
    /** 已经播放时长 n*/
    @IBOutlet weak var costTimeLabel: UILabel!
    
    /** 播放或暂停按钮 n*/
    @IBOutlet weak var playOrPauseBtn: UIButton!
    
    // 负责更新很多次的timer
    var timer: Timer?
    
    // 负责更新歌词的link
    var updateLrcLink: CADisplayLink?
    
    
    // 关闭控制器
    @IBAction func close() {
        
       self.navigationController?.popViewController(animated: true)
        
    }
    
    // 播放或者暂停
    @IBAction func playOrPause(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            QQMusicOperationTool.shareInstance.playCurrentMusic()
            resumeRotationAnimation()
        }else {
            QQMusicOperationTool.shareInstance.pauseCurrentMusic()
            pauseRotationAnimation()
        }
    }

    // 上一首
    @IBAction func preMusic() {
        QQMusicOperationTool.shareInstance.preMusic()
        // 切换一次更新界面的操作
        setUpOnce()
        

    }
    
    // 下一首
    @IBAction func nextMusic() {
        QQMusicOperationTool.shareInstance.nextMusic()
        // 切换一次更新界面的操作
        setUpOnce()
        
        
    }
    
    
    
    @IBAction func touchDown() {
        
        removeTimer()
    }
    
    @IBAction func touchUp() {
        
        addTimer()
        
        // 设置歌曲播放某个时间点
        // 0.0 - 1.0
        let value = progressSlider.value
        
        // 获取总时长
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageModel()
        let totalTime = musicMessageM.totalTime
        
        // 计算已经播放的时长
        let costTime = totalTime * TimeInterval(value)
        
        // 设置歌曲播放到对应的时间点
        QQMusicOperationTool.shareInstance.seekToTime(time: costTime)
        
    }
    
    @IBAction func valueChange(_ sender: UISlider) {
        
        // 修改已经播放的时间
        
        // 0.0 - 1.0
        let value = progressSlider.value
        
        // 获取总时长
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageModel()
        let totalTime = musicMessageM.totalTime
        
        // 计算已经播放的时长
        let costTime = totalTime * TimeInterval(value)
        
        let timeStr = QQTimeTool.getFormatTime(timeInterval: costTime)
        
        costTimeLabel.text = timeStr
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 添加歌词视图
        addlrcTVC()
        // 设置做歌词动画的滚动视图
        setUpLrcScrollView()
        // 设置进度条
        setSlider()
        
        NotificationCenter.default.addObserver(self, selector: #selector(QQDetailVC.nextMusic), name: NSNotification.Name(rawValue: kPlayFinishNotification), object: nil)
        
    }

    // 即将显示界面后执行的方法
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 只需要更新一次的界面更新
        setUpOnce()
        // 触发需要更新多次的界面更新方法
        addTimer()
        
        addLink()
    }
    
    // 即将不显示界面后执行的方法
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 移除更新的timer
        removeTimer()
        
        removeLink()
    }

    // 系统重新布局子控件的方法(在这个方法里面, 可以获取到最后正确的frame, 所以, 一般把控件的布局, 写到这个位置)
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // 设置歌词frame
        setlrcTVCFrame()
        // 设置前景图片圆角
        setUpForeImageView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


// 业务逻辑
extension QQDetailVC {
    // 执行多次更新方法的定时器
    func addTimer() -> () {
        timer = Timer(timeInterval: 1, target: self, selector: #selector(QQDetailVC.setUpTimes), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    // 移除定时器
    func removeTimer() -> () {
        timer?.invalidate()
        timer = nil
    }

    func addLink() {
        updateLrcLink = CADisplayLink(target: self, selector: #selector(updateLrc))
        updateLrcLink?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    func removeLink() {
        updateLrcLink?.invalidate()
        updateLrcLink = nil
    }
    
    // 更新歌词
    @objc func updateLrc() {
        
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageModel()
        
        // 拿到歌词
        // 当前的歌词
        let time = musicMessageM.costTime
        
        // 拿到歌词数组
        let lrcMs = lrcTVC.lrcMs
        
        let rowAndLrcM = QQMusicDataTool.getCurrentLrcM(currentTime: time, lrcMs: lrcMs)
        
        let lrcM = rowAndLrcM.lrcM
        
        // 赋值
        lrcLabel.text = lrcM?.lrcContent
        
        // 进度
        if let lrcM = lrcM {
            let radio = CGFloat((time - lrcM.beginTime) / (lrcM.endTime - lrcM.beginTime))
            lrcLabel.radio = radio
        }
        
        lrcTVC.progress = lrcLabel.radio
    
        
        // 滚动歌词
        // 滚到哪一行
        let row = rowAndLrcM.row
        
        
        // 赋值给lrcTVC，让她来负责具体怎么滚
        lrcTVC.scrollRow = row
        
        
        // 设置锁屏中心界面
        if UIApplication.shared.applicationState == .background {
           QQMusicOperationTool.shareInstance.setupLockMessage()
        }
        
        
    }
    
    
    
    // 当歌曲切换时, 需要更新一次的操作
    func setUpOnce() -> () {
        
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageModel()
        
        guard let musicM = musicMessageM.musicM else {return}
        
        /** 背景图片 1 */
        if musicM.icon != nil
        {
            backImageView.image = UIImage(named: (musicM.icon)!)
            /** 前进图片 1*/
            foreImageView.image = UIImage(named: (musicM.icon)!)
        }
        
        
        /** 歌曲名称 1*/
        songNameLabel.text = musicM.name
        
        /** 歌手名称 1*/
        singerNameLabel.text = musicM.singer
        
        /** 总时长 1*/
        // 212.0988 -> 04:56
        totalTimeLabel.text = QQTimeTool.getFormatTime(timeInterval: musicMessageM.totalTime)
        
        // 歌词的视图 1
        //        lrcTVC
        
        
        // 开始动画
        addRotationAnimation()
        
        if musicMessageM.isPlaying {
            resumeRotationAnimation()
        } else {
            pauseRotationAnimation()
        }
        
        
        // 切换最新的歌词
        let lrcMs: [QQLrcModel] = QQMusicDataTool.getLrcMs(lrcName: musicM.lrcname)
        lrcTVC.lrcMs = lrcMs
        
    }
    
    // 当歌曲切换时, 需要更新N次的操作
    @objc func setUpTimes() -> () {
        /** 歌词label n */
        //        lrcLabel.text = ""
        
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageModel()
        
        /** 进度条 n*/
        progressSlider.value = Float(musicMessageM.costTime / musicMessageM.totalTime)
        
        /** 已经播放时长 n*/
        costTimeLabel.text =  QQTimeTool.getFormatTime(timeInterval: musicMessageM.costTime)
        
        /** 按钮更新状态 */
        playOrPauseBtn.isSelected = musicMessageM.isPlaying
    }
    
}

// 界面操作
extension QQDetailVC  {
    
    // 设置进度条图标
    func setSlider() -> () {
        progressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), for: .normal)
        
    }
    
    // 设置前景图片的圆角效果
    func setUpForeImageView() -> () {
        foreImageView.layer.cornerRadius = foreImageView.width * 0.5
        foreImageView.layer.masksToBounds = true
    }
    
    // 添加歌词视图
    func addlrcTVC() -> () {
        //lrcTVC = UIView()
        lrcTVC.tableView.backgroundColor = UIColor.clear
        lrcScrollView.addSubview(lrcTVC.tableView)
    }
    
    // 调整歌词视图frame
    func setlrcTVCFrame() -> () {
        lrcTVC.tableView.frame = lrcScrollView.bounds
        lrcTVC.tableView.x = lrcScrollView.width
        lrcScrollView.contentSize = CGSize(width: lrcScrollView.width * 2, height: 0)
        
    }
    
    // 设置scrollView的contentSize
    func setUpLrcScrollView() -> () {
        // 设置代理, 监听滚动--> 做动画用的
        lrcScrollView.delegate = self
        // 设置分页
        lrcScrollView.isPagingEnabled = true
        // 隐藏水平滚动条
        lrcScrollView.showsHorizontalScrollIndicator = false
    }
}

// 做动画
extension QQDetailVC: UIScrollViewDelegate {
    
    // 监听滚动视图的滚动, 做透明动画效果
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 获取当前的移动量
        let x = scrollView.contentOffset.x
        // 计算移动的比例
        let radio = 1 - x / scrollView.width
        
        // 0.0 - 1.0
        foreImageView.alpha = radio
        lrcLabel.alpha = radio
    }
    
    // 添加旋转动画
    func addRotationAnimation() {
        
        foreImageView.layer.removeAnimation(forKey: "rotation")
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = M_PI * 2
        animation.duration = 30
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        foreImageView.layer.add(animation, forKey: "rotation")
    }
    
    // 暂停旋转动画
    func pauseRotationAnimation() {
        foreImageView.layer.pauseAnimation()
    }
    
    // 继续旋转动画
    func resumeRotationAnimation() {
        foreImageView.layer.resumeAnimation()
    }
    
}


extension QQDetailVC {
    
    override func remoteControlReceived(with event: UIEvent?) {
        let type = event?.subtype
        switch type! {
        case .remoteControlPlay: // 播放
            QQMusicOperationTool.shareInstance.playCurrentMusic()
        case .remoteControlPause: // 暂停
            QQMusicOperationTool.shareInstance.pauseCurrentMusic()
        case .remoteControlNextTrack: // 下一首
            QQMusicOperationTool.shareInstance.nextMusic()
        case .remoteControlPreviousTrack: // 上一首
            QQMusicOperationTool.shareInstance.preMusic()
        default:
            print("default")
        }
        
        setUpOnce()
    }
    
    // 摇一摇，就播放下一首
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        QQMusicOperationTool.shareInstance.nextMusic()
        
        setUpOnce()
    }
    
}


























