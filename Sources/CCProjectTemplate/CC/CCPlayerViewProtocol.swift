//
//  CCPlayerViewProtocol.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

/**
 CC播放视图协议
 */
public protocol CCPlayerViewProtocol {
    
    /**
     播放状态改变
     
     - parameter    status:         播放状态
     - parameter    duration:       视频时长
     */
    func playerViewChangeStatus(_ status: AVPlayerItem.Status, duration: Double)
    
    /**
     播放缓冲区间
     
     - parameter    timeRange:      缓冲区间
     */
    func playerViewTimeRange(_ timeRange: CMTimeRange)
    
    /**
     播放当前时间
     
     - parameter    time:           当前播放时间
     */
    func playerViewCurrentPlayTime(_ time: CMTime)
    
    /**
     播放结束
     */
    func playerViewPlayEnd()
}
