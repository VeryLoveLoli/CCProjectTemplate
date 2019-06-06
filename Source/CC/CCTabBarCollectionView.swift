//
//  CCTabBarCollectionView.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/4.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit
import JSONValue

/**
 CC标签栏集合视图
 */
open class CCTabBarCollectionView: CCCollectionView {
    
    /**
     XIB
     */
    open override class func xib() -> Self {
        
        return xib(name: "CCTabBarCollectionView", index: 0)
    }
    
    /// 滑块
    open lazy var sliderImageView: UIImageView = {
        
        return initSlider()
    }()
    
    /// 滑块大小
    open var sliderSize: CGSize?
    /// 滑块动画时间
    open var sliderAnimateTime: TimeInterval = 0.25
    
    /// 可见标签数量
    open var visibleTabBarNumber: CGFloat = 2
    
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
        
        collectionView.addSubview(sliderImageView)
        update(false)
    }
    
    // MARK: - UICollectionViewDelegate
    
    open override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, didSelectItemAt: indexPath)
        
        index = indexPath.row
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    /**
     格子大小
     */
    open override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let flow = collectionViewLayout as? UICollectionViewFlowLayout {
            
            if flow.scrollDirection == .vertical {
                
                return CGSize.init(width: collectionView.frame.width, height: CGFloat(Int(collectionView.frame.height/visibleTabBarNumber)))
            }
            else {
                
                return CGSize.init(width: CGFloat(Int(collectionView.frame.width/visibleTabBarNumber)), height: collectionView.frame.height)
            }
        }
        
        return CGSize.init(width: CGFloat(Int(collectionView.frame.width/visibleTabBarNumber)), height: collectionView.frame.height)
    }
    
    // MARK: - Event
    
    /**
     初始化滑块
     */
    open func initSlider() -> UIImageView {
        
        let imageView = UIImageView.init(image: UIImage.init(named: "CC_point_pink"))
        
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        
        return imageView
    }
    
    /**
     更新
     */
    open func update(_ isAnimate: Bool = true) {
        
        for i in 0..<source.array.count {
            
            source[i].select = (i == index).json
        }
        
        collectionView.reloadData()
        
        let cellSize = collectionView(collectionView, layout: collectionView.collectionViewLayout, sizeForItemAt: IndexPath.init(row: index, section: 0))
        
        var isVerticalScroll = false
        
        if let flow = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            isVerticalScroll = flow.scrollDirection == .vertical
        }
        
        if isVerticalScroll {
            
            if index == 0 {
                
                collectionView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
            }
            else if index == source.array.count - 1 {
                
                collectionView.setContentOffset(CGPoint.init(x: 0, y: collectionView.contentSize.height - collectionView.frame.height), animated: true)
            }
            else {
                
                var py = Int((CGFloat(index+1+1)-visibleTabBarNumber)*cellSize.height)
                
                if py < 0 {
                    
                    py = 0
                }
                else if CGFloat(py) + CGFloat(index+1) * cellSize.width >= collectionView.contentSize.height {
                    
                    py = Int(collectionView.contentSize.height - collectionView.frame.height)
                }
                
                collectionView.setContentOffset(CGPoint.init(x: 0, y: py), animated: true)
            }
            
            let imageSize = sliderSize ?? CGSize.init(width: 3, height: cellSize.height)
            
            UIView.animate(withDuration: isAnimate ? sliderAnimateTime : 0) {
                
                self.sliderImageView.frame = CGRect.init(origin: CGPoint.init(x: cellSize.width - imageSize.width, y: cellSize.height*CGFloat(self.index) + (cellSize.height - imageSize.height)/2), size: imageSize)
            }
        }
        else {
            
            if index == 0 {
                
                collectionView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
            }
            else if index == source.array.count - 1 {
                
                collectionView.setContentOffset(CGPoint.init(x: collectionView.contentSize.width - collectionView.frame.width, y: 0), animated: true)
            }
            else {
                
                var px = Int((CGFloat(index+1+1)-visibleTabBarNumber)*cellSize.width)
                
                if px < 0 {
                    
                    px = 0
                }
                else if CGFloat(px) + CGFloat(index+1) * cellSize.width >= collectionView.contentSize.width {
                    
                    px = Int(collectionView.contentSize.width - collectionView.frame.width)
                }
                
                collectionView.setContentOffset(CGPoint.init(x: px, y: 0), animated: true)
            }
            
            let imageSize = sliderSize ?? CGSize.init(width: 0.8*cellSize.width, height: 3)
            
            UIView.animate(withDuration: isAnimate ? sliderAnimateTime : 0) {
                
                self.sliderImageView.frame = CGRect.init(origin: CGPoint.init(x: cellSize.width*CGFloat(self.index) + (cellSize.width - imageSize.width)/2, y: cellSize.height - imageSize.height), size: imageSize)
            }
        }
    }
}
