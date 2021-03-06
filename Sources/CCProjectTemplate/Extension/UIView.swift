//
//  UIView.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation

import UIKit

// MARK: 约束

public extension UIView {
    
    /**
     约束(基于superview)
     
     - parameter    top:        上
     - parameter    bottom:     下
     - parameter    leading:    左
     - parameter    right:      右
     */
    func constraintForSuperview(top: CGFloat = 0, bottom: CGFloat = 0, leading: CGFloat = 0, right: CGFloat = 0) {
        
        if let superview = superview {
            
            translatesAutoresizingMaskIntoConstraints = false
            
            let t = NSLayoutConstraint.init(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: top)
            let l = NSLayoutConstraint.init(item: self, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: leading)
            let b = NSLayoutConstraint.init(item: superview, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: bottom)
            let r = NSLayoutConstraint.init(item: superview, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: right)
            
            superview.addConstraints([t, l, b, r])
        }
    }
}

import Prompt

// MARK: - 提示

public extension UIView {
    
    /**
     文字提示
     
     - parameter    title:          文字
     - parameter    milliseconds:   显示时间
     - parameter    isBackground:   是否显示背景（用于阻止用户点击）
     */
    func promptTitle(_ title: String, milliseconds: Int = 2000, isBackground: Bool = false) {
        
        Prompt.title(title, milliseconds: milliseconds, isBackground: isBackground, sup: self, location: self.center)
    }
    
    /**
     加载提示
     
     - parameter    title:          文字
     - parameter    timeInterval:   动态显示的文字时间间隔
     - parameter    repeats:        动态显示的文字个数（小于或等于`title.count`，从后往前算）
     - parameter    dynamic:        最大长度动态字符串（不显示，需设置`dynamic`属性，`dynamic`字符串在`repeats`之前）
     - parameter    isBackground:   是否显示背景（用于阻止用户点击）
     */
    func promptLoad(_ title: String = "正在加载...", timeInterval: TimeInterval = 1, repeats: Int = 2, dynamic: String = "", isBackground: Bool = false) -> Prompt {
        
        return Prompt.load(title, timeInterval: timeInterval, repeats: repeats, dynamic: dynamic, isBackground: isBackground, sup: self, location: self.center)
    }
    
    /**
     GIF提示
     
     - parameter    data:           GIF数据
     - parameter    isBackground:   是否显示背景（用于阻止用户点击）
     */
    func promptGIF(_ data: Data, isBackground: Bool = false) -> Prompt {
        
        return Prompt.gif(data, isBackground: isBackground, sup: self, location: self.center)
    }
}

// MARK: - 圆角阴影

/**
 
 `layer.masksToBounds = true` 或 设置`layer.mask`值 会引起离屏渲染
 
 一般视图直接设置圆角、阴影即可
 
 `UIImageView`、`UIButton` 绘制圆角图片即可，
 阴影则添加设置`layer.shadowPath = UIBezierPath(rect: bounds).cgPath`
 */
