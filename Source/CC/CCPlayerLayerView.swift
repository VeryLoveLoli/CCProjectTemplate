//
//  CCPlayerLayerView.swift
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
 CC播放层视图
 */
open class CCPlayerLayerView: UIView {
    
    /// 播放背景
    open lazy var playerBackground: UIImageView = {
        
        let image = UIImageView.init()
        image.contentMode = .scaleAspectFit
        
        self.addSubview(image)
        self.sendSubviewToBack(image)
        image.constraintForSuperview()
        
        return image
    }()
    
    /// 播放层
    open var playerLayer: AVPlayerLayer? {
        
        willSet {
            
            playerLayer?.removeFromSuperlayer()
        }
        
        didSet {
            
            if let layer = playerLayer {
                
                layer.frame = bounds
                self.layer.addSublayer(layer)
            }
        }
    }
    
    /// 位置大小
    open override var frame: CGRect {
        
        didSet {
            
            /// 更新播放层大小
            playerLayer?.frame = bounds
        }
    }
    
    /// 布局更新
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        /// 更新播放层大小
        playerLayer?.frame = bounds
    }
}
