//
//  UIViewController.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit
import Prompt

// MARK: - 提示

public extension UIViewController {
    
    /**
     文字提示
     
     - parameter    title:          文字
     - parameter    milliseconds:   显示时间
     - parameter    isBackground:   是否显示背景（用于阻止用户点击）
     */
    func promptTitle(_ title: String, milliseconds: Int = 2000, isBackground: Bool = false) {
        
        Prompt.title(title, milliseconds: milliseconds, isBackground: isBackground, sup: view, location: view.center)
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
        
        return Prompt.load(title, timeInterval: timeInterval, repeats: repeats, dynamic: dynamic, isBackground: isBackground, sup: view, location: view.center)
    }
    
    /**
     GIF提示
     
     - parameter    data:           GIF数据
     - parameter    isBackground:   是否显示背景（用于阻止用户点击）
     */
    func promptGIF(_ data: Data, isBackground: Bool = false) -> Prompt {
        
        return Prompt.gif(data, isBackground: isBackground, sup: view, location: view.center)
    }
}
