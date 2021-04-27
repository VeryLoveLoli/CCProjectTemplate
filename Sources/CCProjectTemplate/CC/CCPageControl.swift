//
//  CCPageControl.swift
//  
//
//  Created by 韦烽传 on 2021/3/15.
//

import Foundation
import UIKit

/**
 页码控制器
 */
open class CCPageControl: UIView {
    
    /**
     模式
     */
    public enum Mode {
        
        /// 左
        case left
        /// 中
        case mid
        /// 右
        case right
    }
    
    /// 索引
    open var index = 0 { didSet { layerDraw() } }
    /// 总数
    open var number = 0 { didSet { layerCreate() } }
    /// 模式
    open var mode: CCPageControl.Mode = .mid { didSet { layerDraw() } }
    /// 间距
    open var spacing: CGFloat = 6 { didSet { layerDraw() } }
    /// 当前页大小
    open var currentSize: CGSize = CGSize(width: 12, height: 6) { didSet { layerDraw() } }
    /// 默认页大小
    open var defaultSize: CGSize = CGSize(width: 6, height: 6) { didSet { layerDraw() } }
    /// 当前页颜色
    open var currentColor: CGColor = UIColor.white.cgColor { didSet { layerDraw() } }
    /// 默认页颜色
    open var defaultColor: CGColor = UIColor.lightGray.cgColor { didSet { layerDraw() } }
    /// 圆角
    open var rounded: CGFloat = 3 { didSet { layerDraw() } }
    /// 页码列表
    open var items: [CALayer] = []
    
    open override var frame: CGRect {
        
        didSet {
            
            layerDraw()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        layerDraw()
    }
    
    /**
     图层创建
     */
    open func layerCreate() {
        
        if items.count < number {
            
            for _ in items.count..<number {
                
                let l = CALayer()
                layer.addSublayer(l)
                items.append(l)
            }
        }
        else if items.count > number {
            
            for _ in 0..<(items.count - number) {
                
                items.remove(at: 0).removeFromSuperlayer()
            }
        }
        
        layerDraw()
    }
    
    /**
     图层绘制
     */
    open func layerDraw() {
        
        let size = bounds.size
        var x: CGFloat = 0
        let y = size.height/2
        
        switch mode {
        case .left:
            x = spacing
        case .mid:
            x = (size.width - CGFloat(items.count - 1) * (defaultSize.width + spacing) - currentSize.width)/2
        case .right:
            x = size.width - CGFloat(items.count - 1) * (defaultSize.width + spacing) - currentSize.width - spacing
        }
        
        for i in 0..<items.count {
            
            let item = items[i]
            
            if i == index {
                
                item.frame = CGRect(x: x, y: y, width: currentSize.width, height: currentSize.height)
                item.cornerRadius = rounded
                item.backgroundColor = currentColor
                
                x += currentSize.width
            }
            else {
                
                item.frame = CGRect(x: x, y: y, width: defaultSize.width, height: defaultSize.height)
                item.cornerRadius = rounded
                item.backgroundColor = defaultColor
                
                x += defaultSize.width
            }
            
            x += spacing
        }
    }
}
