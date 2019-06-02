//
//  CCPlayerView.swift
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
 CC播放视图
 */
open class CCPlayerView: CCPlayerLayerView {
    
    /// 视频播放器
    open var player: AVPlayer?
    /// CC播放协议
    open var delegate: CCPlayerViewProtocol?
    
    /// 是否自动播放
    open var isAutoPlay = true
    /// 是否自动重新播放
    open var isAutoReplay = true
    
    // MARK: - Setting
    
    /**
     设置播放器
     
     - parameter    urlString:      播放地址
     - parameter    videoGravity:   播放层填充模式
     */
    open func setPlayer(_ urlString: String, videoGravity: AVLayerVideoGravity) {
        
        if player == nil, let url = URL.init(string: urlString) {
            
            playerBackground.isHidden = false
            
            player = AVPlayer.init(url: url)
            playerLayer = AVPlayerLayer.init(player: player)
            playerLayer?.videoGravity = videoGravity
            
            settingObserver()
        }
    }
    
    /**
     设置播放器
     
     - parameter    playerItem:     播放
     - parameter    videoGravity:   播放层填充模式
     */
    open func setPlayer(_ playerItem: AVPlayerItem?, videoGravity: AVLayerVideoGravity) {
        
        if player == nil {
            
            playerBackground.isHidden = false
            
            player = AVPlayer.init(playerItem: playerItem)
            playerLayer = AVPlayerLayer.init(player: player)
            playerLayer?.videoGravity = videoGravity
            
            settingObserver()
        }
    }
    
    /**
     设置监听
     */
    open func settingObserver() {
        
        /// 播放状态
        player?.currentItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        /// 缓存进度
        player?.currentItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        /// 当前播放时间
        player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.global(), using: { [weak self] (time) in
            
            self?.delegate?.playerViewCurrentPlayTime(time)
            #if DEBUG
            print("当前播放时间：\(CMTimeGetSeconds(time))秒")
            #endif
        })
        
        /// 播放结束
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    /**
     删除播放 监听、通知(退出时必须调用)
     */
    open func removePlayer() {
        
        delegate = nil
        player?.currentItem?.removeObserver(self, forKeyPath: "status")
        player?.currentItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        NotificationCenter.default.removeObserver(self, name:  Notification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        player?.pause()
        player = nil
        playerLayer = nil
    }
    
    /**
     重新播放
     */
    open func replay() {
        
        /// 回到最开始位置
        player?.seek(to: CMTime.zero, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        
        if player?.status == .readyToPlay {
            
            player?.play()
        }
    }
    
    // MARK: - KVO
    
    /**
     通过KVO监控播放器状态
     
     - parameter    keyPath:    监控属性
     - parameter    object:     监视器
     - parameter    change:     状态改变
     - parameter    context:    上下文
     */
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let playerItem = object as? AVPlayerItem  else { return }
        guard let keyPath = keyPath else { return }
        
        if keyPath == "status" {
            
            if playerItem.status == .readyToPlay && isAutoPlay {
                
                playerBackground.isHidden = true
                player?.play()
            }
            
            delegate?.playerViewChangeStatus(playerItem.status, duration: CMTimeGetSeconds(playerItem.duration))
            
            #if DEBUG
            switch playerItem.status {
                
            case .unknown:
                
                print("未知状态")
                
            case .readyToPlay:
                
                print("开始播放")
                print("视频长度: \(CMTimeGetSeconds(playerItem.duration))秒")
                
            case .failed:
                
                print("播放失败")
            @unknown default:
                print("未知类型")
            }
            #endif
        }
        else if keyPath == "loadedTimeRanges" {
            
            if let first = playerItem.loadedTimeRanges.first {
                
                self.delegate?.playerViewTimeRange(first.timeRangeValue)
                
                #if DEBUG
                /// 本次缓冲时间范围
                let timeRange = first.timeRangeValue
                /// 本次缓冲起始时间
                let startSeconds = CMTimeGetSeconds(timeRange.start)
                /// 缓冲时间
                let durationSecounds = CMTimeGetSeconds(timeRange.duration)
                /// 缓冲总长度
                let seconds = startSeconds + durationSecounds
                print("缓冲: \(durationSecounds)秒 [\(startSeconds)-\(seconds)]")
                #endif
            }
        }
    }
    
    // MARK: - Notification
    
    /**
     播放结束
     */
    @objc open func playerItemDidReachEnd(notification: Notification) {
        
        if isAutoReplay {
            
            replay()
        }
        
        self.delegate?.playerViewPlayEnd()
    }
}
