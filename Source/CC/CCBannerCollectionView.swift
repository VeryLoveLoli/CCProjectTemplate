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
    
    /// 页码控制器
    @IBOutlet open weak var pageControl: UIPageControl?
    
    /// 定时器
    open var timer: Timer?
    /// 时间间隔
    open var timeInterval = CCBannerCollectionView.timeInterval
    
    /// 索引
    open var index = 0 {
        
        didSet {
            
            update()
        }
    }
    
    /// 列表
    open var list: [JSONValue] = [] {
        
        didSet {
            
            update()
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        source = Array.init(repeating: JSONValue(), count: 5).json
        
        Timer.timeInterval(timeInterval) { [weak self] (timer) in
            
            self?.timer = timer
            
            if self == nil && timer.isValid {
                
                timer.invalidate()
            }
            else {
                
                if let number = self?.source.array.count, let v = self?.collectionView {
                    
                    var isVerticalScroll = false
                    
                    if let flow = v.collectionViewLayout as? UICollectionViewFlowLayout {
                        
                        isVerticalScroll = flow.scrollDirection == .vertical
                    }
                    
                    if isVerticalScroll {
                        
                        v.setContentOffset(CGPoint.init(x: 0, y: CGFloat(number/2 + number%2)*v.frame.height), animated: true)
                    }
                    else {
                        
                        v.setContentOffset(CGPoint.init(x: CGFloat(number/2 + number%2)*v.frame.width, y: 0), animated: true)
                    }
                }
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
        
        updateIndex()
    }
    
    /**
     滑动动画结束
     */
    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        updateIndex()
    }
    
    // MARK: - Event
    
    /**
     更新
     */
    open func update() {
        
        let midIndex = CGFloat(source.array.count/2 + source.array.count%2) - 1

        if list.count > 0 {
            
            let start_index = index - Int(midIndex) + list.count
            
            for i in 0..<source.array.count {
                
                source[i] = list[(start_index+i)%list.count]
            }
        }
        
        var isVerticalScroll = false
        
        if let flow = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            isVerticalScroll = flow.scrollDirection == .vertical
        }
        
        if isVerticalScroll {
            
            if collectionView.contentSize.height < CGFloat(list.count)*collectionView.frame.size.height {
                
                collectionView.contentSize.height = CGFloat(list.count)*collectionView.frame.size.height
            }
            
            collectionView.contentOffset = CGPoint.init(x: 0, y: midIndex*collectionView.frame.size.height)
        }
        else {
            
            if collectionView.contentSize.width < CGFloat(list.count)*collectionView.frame.size.width {
                
                collectionView.contentSize.width = CGFloat(list.count)*collectionView.frame.size.width
            }
            
            collectionView.contentOffset = CGPoint.init(x: midIndex*collectionView.frame.size.width, y: 0)
        }
        
        pageControl?.numberOfPages = list.count
        pageControl?.currentPage = index
        collectionView.reloadData()
    }
    
    /**
     更新索引
     */
    open func updateIndex() {
        
        let midIndex = source.array.count/2 + source.array.count%2 - 1
        var offsetIndex = 0
        
        var isVerticalScroll = false
        
        if let flow = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            isVerticalScroll = flow.scrollDirection == .vertical
        }
        
        if isVerticalScroll {
            
            offsetIndex = Int(collectionView.contentOffset.y/collectionView.frame.size.height)
        }
        else {
            
            offsetIndex = Int(collectionView.contentOffset.x/collectionView.frame.size.width)
        }
        
        offsetIndex -= midIndex
        
        var newIndex = 0
        
        if list.count > 0 {
            
            newIndex = index + offsetIndex
            
            while newIndex < 0 {
                
                newIndex += list.count
            }
            
            newIndex = newIndex%list.count
        }
        
        index = newIndex
    }
}
