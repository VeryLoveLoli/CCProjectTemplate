//
//  File.swift
//  
//
//  Created by 韦烽传 on 2021/3/23.
//

import Foundation
import UIKit

/**
 导航栏超出视图
 */
open class CCBeyondTabBar: UITabBar, BeyondProtocol {
    
    /// 超出视图列表
    open var beyondViews: [UIView] = []
    
    /**
     点击视图
     */
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
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
}
