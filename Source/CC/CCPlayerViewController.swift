//
//  CCPlayerViewController.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import JSONValue

/**
 CC播放视图控制器
 */
open class CCPlayerViewController: CCViewController, CCPlayerViewProtocol {
    
    /// 播放记录路径
    public static var palyRecordPath = NSHomeDirectory() + "/Documents/CCPlayerViewPalyRecord"
    
    /**
     Storyboard
     */
    open override class func storyboard() -> Self {
        
        return storyboard(name: "CC", identifier: "CCPlayerViewController")
    }
    
    /// 播放视图
    @IBOutlet open weak var playerView: CCPlayerView!
    
    /// 视频地址
    open var urlString: String?
    /// 视频显示模式  (resizeAspect: 保持比例完整显示; resizeAspectFill: 保持比例裁剪显示)
    open var videoGravity: AVLayerVideoGravity = .resizeAspect
    /// 预览图
    open var previewImage: UIImage?
    
    /// 是否出现
    open var isAppear = false
    /// 是否出现时播放、消失时暂停
    open var isAppearDisappearAutoPlay = true
    /// 是否跳转上一次的播放位置
    open var isToLastPalyTime = true
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        playerView.delegate = self
        playerView.playerBackground.image = previewImage
        
        if let urlString = urlString {
            
            playerView.setPlayer(urlString, videoGravity: videoGravity)
            
            if isToLastPalyTime {
                
                toLastPalyTime()
            }
        }
        
        /// 应用将辞职活跃
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        /// 应用开始活跃
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        isAppear = true
        
        if playerView.player?.status == .readyToPlay && isAppearDisappearAutoPlay {
            
            playerView.player?.play()
        }
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        isAppear = false
        
        if isAppearDisappearAutoPlay {
            
            playerView.player?.pause()
            saveCurrentPlayTime()
        }
    }
    
    // MARK: - Notification
    
    /**
     应用开始活跃
     */
    @objc func didBecomeActive(notification: Notification) {
        
        if playerView.player?.status == .readyToPlay && isAppearDisappearAutoPlay && isAppear {
            
            playerView.player?.play()
        }
    }
    
    /**
     应用将辞职活跃
     */
    @objc func willResignActive(notification: Notification) {
        
        if isAppearDisappearAutoPlay {
            
            playerView.player?.pause()
            saveCurrentPlayTime()
        }
    }
    
    // MARK: - CCPlayerViewProtocol
    
    /**
     播放状态改变
     */
    open func playerViewChangeStatus(_ status: AVPlayerItem.Status, duration: Double) {
        
    }
    
    /**
     播放缓冲区间
     */
    open func playerViewTimeRange(_ timeRange: CMTimeRange) {
        
    }
    
    /**
     播放当前时间
     */
    open func playerViewCurrentPlayTime(_ time: CMTime) {
        
    }
    
    /**
     播放结束
     */
    open func playerViewPlayEnd() {
        
    }
    
    // MARK: - Event
    
    /**
     保存当前播放时间
     */
    open func saveCurrentPlayTime() {
        
        if let player = playerView.player, let playerItem = player.currentItem, let key = urlString?.data(using: .utf8)?.base64EncodedString() {
            
            let currentTime = player.currentTime()
            let duration = playerItem.duration
            
            var json = JSONValue.disk(CCPlayerViewController.palyRecordPath)
            
            // TODO: JSONValue初始化 无法识别 Int64 Int32 。。。（原项目可以的。。。）
            json[key].currentTime.value =  currentTime.value.json
            json[key].currentTime.timescale = currentTime.timescale.json
            json[key].duration.value = duration.value.json
            json[key].duration.timescale = duration.timescale.json
            
            _ = json.save(CCPlayerViewController.palyRecordPath)
        }
    }
    
    /**
     跳转上次播放时间
     */
    open func toLastPalyTime() {
        
        if let key = urlString?.data(using: .utf8)?.base64EncodedString() {
            
            let json = JSONValue.disk(CCPlayerViewController.palyRecordPath)
            
            let currentTime = CMTime.init(value: json[key].currentTime.value.number.int64, timescale: json[key].currentTime.timescale.number.int32)
            let duration = CMTime.init(value: json[key].duration.value.number.int64, timescale: json[key].duration.timescale.number.int32)
            
            if CMTimeGetSeconds(currentTime) > 0 && CMTimeGetSeconds(duration) > 0 && Int(CMTimeGetSeconds(currentTime)) < Int(CMTimeGetSeconds(duration)) {
                
                playerView.player?.seek(to: currentTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
            }
        }
        
    }
    
    // MARK: - deinit
    
    deinit {
        
        playerView.removePlayer()
    }
}
