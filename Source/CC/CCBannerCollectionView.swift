//
//  CCBannerCollectionView.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/4.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit
import JSONValue

open class CCBannerCollectionView: CCCollectionView {
    
    /// 时间间隔(在初始化前设置)
    public static var timeInterval: TimeInterval = 3
    
    /**
     XIB
     */
    open override class func xib() -> Self {
        
        return xib(name: "CCBannerCollectionView", index: 0)
    }
    
    /// 页码控制器
    @IBOutlet open weak var pageControl: UIPageControl?
    
    /// 定时器
    open var timer: Timer?
    /// 时间间隔
    open var timeInterval = CCBannerCollectionView.timeInterval
    
    /// 索引
    open var index = 0 {
        
        didSet {
            
            if oldValue != index {
                
                update()
            }
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        Timer.timeInterval(timeInterval) { [weak self] (timer) in
            
            self?.timer = timer
            
            if self == nil && timer.isValid {
                
                timer.invalidate()
            }
            else {
                
            }
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    /**
     将开始拖动
     */
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        timer?.fireDate = Date.distantFuture
    }
    
    /**
     结束拖动
     */
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        timer?.fireDate = Date.init(timeIntervalSince1970: Date.init().timeIntervalSince1970 + timeInterval)
    }
    
    /**
     减速结束
     */
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        index = Int(scrollView.contentOffset.x/scrollView.frame.size.width) - 1
        
    }
    
    /**
     滑动动画结束
     */
    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        index = Int(scrollView.contentOffset.x/scrollView.frame.size.width) - 1
    }
    
    // MARK: - Event
    
    /**
     更新
     */
    open func update() {
        
        
    }
}
