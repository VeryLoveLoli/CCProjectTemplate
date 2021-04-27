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
open class CCPlayerView: UIView {
    
    /// 控制器
    open lazy var player: AVPlayer = {
        
        return AVPlayer()
    }()
    
    /// 显示图层
    open lazy var playerLayer: AVPlayerLayer = {
        
        let av = AVPlayerLayer()
        av.player = player
        layer.addSublayer(av)
        
        return av
    }()
    
    /// 播放背景
    open lazy var playerBackground: UIImageView = {
        
        let image = UIImageView.init()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .clear
        
        self.addSubview(image)
        self.sendSubviewToBack(image)
        image.constraintForSuperview()
        
        return image
    }()
    
    /// 播放进度监听
    open var timeObserver: Any?
    /// KVO路径
    open var kvoPath: [String] = []
    
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
     - parameter    videoGravity:   播放层填充模式 默认保持比例显示完整
     */
    open func setPlayer(_ urlString: String, videoGravity: AVLayerVideoGravity = .resizeAspect) {
        
        /// 创建地址
        guard let url = URL(string: urlString) else {
            
            removePlayer()
            
            return
        }
        
        /// 创建资源
        let item = AVPlayerItem(url: url)
        
        setPlayer(item, videoGravity: videoGravity)
    }
    
    /**
     设置播放器
     
     - parameter    item:           播放资源
     - parameter    videoGravity:   播放层填充模式 默认保持比例显示完整
     */
    open func setPlayer(_ item: AVPlayerItem, videoGravity: AVLayerVideoGravity) {
        
        removePlayer()
        
        playerBackground.isHidden = false
        playerLayer.videoGravity = videoGravity
        
        settingObserver(item)
        
        /// 将资源添加到控制器上 （替换当前资源）
        player.replaceCurrentItem(with: item)
    }
    
    /**
     设置监听
     */
    open func settingObserver(_ item: AVPlayerItem) {
        
        /// KVO监听状态
        var path = "status"
        item.addObserver(self, forKeyPath: path, options: .new, context: nil)
        kvoPath.append(path)
        /// KVO监听缓存进度
        path = "loadedTimeRanges"
        item.addObserver(self, forKeyPath: path, options: .new, context: nil)
        kvoPath.append(path)
                
        /// 注册播放结束通知
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: item)
        
        /**
         获取当前播放进度
         
         `CMTime(value: 1, timescale: 1)`间隔分数（单位秒）
         `value`分子
         `timescale`分母
         */
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 10), queue: .global()) { [weak self] (time) in
            
            /// 协议回调当前播放进度
            self?.delegate?.playerViewCurrentPlayTime(time)
            
            CCPrint.debug("当前播放时间：\(CMTimeGetSeconds(time))秒")
        }
    }
    
    /**
     删除播放 监听、通知(退出时必须调用)
     */
    open func removePlayer() {
        
        /// 暂停
        player.pause()
        
        /// 清除旧的监听
        for item in kvoPath {
            
            player.currentItem?.removeObserver(self, forKeyPath: item, context: nil)
            kvoPath.remove(at: 0)
        }
        
        /// 清除旧的通知
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        if let observer = timeObserver {
            
            /// 清除监听播放进度
            player.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
    
    /**
     重新播放
     */
    open func replay() {
        
        /// 回到最开始位置
        player.seek(to: CMTime.zero, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        
        if player.status == .readyToPlay {
            
            player.play()
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
        
        guard let item = object as? AVPlayerItem  else { return }
        guard let key = keyPath else { return }
        
        switch key {
        
        case "status":
            
            if item.status == .readyToPlay && isAutoPlay {
                
                playerBackground.isHidden = true
                player.play()
            }
            
            delegate?.playerViewChangeStatus(item.status, duration: CMTimeGetSeconds(item.duration))
            
            switch item.status {
            case .unknown:
                CCPrint.debug("未知状态")
            case .readyToPlay:
                CCPrint.debug("可播放")
                CCPrint.debug("视频长度: \(CMTimeGetSeconds(item.duration))秒")
            case .failed:
                CCPrint.debug("失败")
            @unknown default:
                CCPrint.debug("未知类型")
            }
            
        case "loadedTimeRanges":
            
            if let first = item.loadedTimeRanges.first {
                
                self.delegate?.playerViewTimeRange(first.timeRangeValue)
                
                /// 本次缓冲时间范围
                let timeRange = first.timeRangeValue
                /// 本次缓冲起始时间
                let startSeconds = CMTimeGetSeconds(timeRange.start)
                /// 缓冲时间
                let durationSecounds = CMTimeGetSeconds(timeRange.duration)
                /// 缓冲总长度
                let seconds = startSeconds + durationSecounds
                CCPrint.debug("缓冲: \(durationSecounds)秒 [\(startSeconds)-\(seconds)]")
            }
            
        default:
            break
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
        
        CCPrint.debug("播放结束")
    }
    
    /**
     以下为了在视图大小发生变化时`playerLayer`显示层也更新
     */
    
    /// 继承`frame`位置大小
    open override var frame: CGRect {
        
        /// 赋值`frame`后触发
        didSet {
            
            /// 更新显示图层大小
            playerLayer.frame = bounds
        }
    }
    
    /**
     布局更新
     */
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        /// 更新显示图层大小
        playerLayer.frame = bounds
    }
}
