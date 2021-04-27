//
//  File.swift
//  
//
//  Created by 韦烽传 on 2021/3/23.
//

import Foundation
import UIKit

/**
 超出协议
 
 需继承以下方法使用
 
 方式一：
 
 override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
     
     /**
      `hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView?`
      会调用
      `point(inside point: CGPoint, with event: UIEvent?) -> Bool`
      */
     if let view = super.hitTest(point, with: event) {
         
         return view
     }
     
     return beyondHitTest(point, with: event)
 }
 
 方式二：（仅在视图和子视图区域有效）
 
 override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
     
     if super.point(inside: point, with: event) {
         
         return true
     }
     
     return beyondPoint(inside: point, with: event)
 }
 
 注意：继承该协议的视图的父视图，其区域必须包含超出视图的区域才有效
 */
public protocol BeyondProtocol {
    
    /// 超出视图列表
    var beyondViews: [UIView] { get set }
}

/**
 扩展实现
 */
public extension BeyondProtocol where Self: UIView {
    
    /**
     超出点是否在超出视图列表中
     */
    func beyondPoint(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        for item in beyondViews {
            
            if item.point(inside: item.convert(point, from: self), with: event) {
                
                return true
            }
        }
        
        return false
    }
    
    /**
     超出点测试点击到的超出视图
     */
    func beyondHitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        /// 用户交互关闭、隐藏、透明 点击无效
        if !isUserInteractionEnabled || isHidden || alpha == 0 {
            
            return nil
        }
        
        for item in beyondViews {
            
            /// 超出视图位置
            let convertPoint : CGPoint = item.convert(point, from: self)
            
            /// 点击测试 返回点击到的视图
            if let view = item.hitTest(convertPoint, with: event) {
                
                return view
            }
        }
        
        return nil
    }
}
