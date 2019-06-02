//
//  CCNavigationController.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit
import JSONValue

/**
 CC导航视图控制器
 */
open class CCNavigationController: UINavigationController {
    
    /// 回调
    open var callback: (JSONValue)->JSONValue = {_ in return JSONValue()}
    
    /// 手势协议
    open var popGestureDelegate: UIGestureRecognizerDelegate?
    
    /// 是否手势返回
    open var isGestureBack: Bool {
        
        get {
            
            return interactivePopGestureRecognizer?.delegate == nil
        }
        
        set {
            
            interactivePopGestureRecognizer?.delegate = newValue ? nil : popGestureDelegate
        }
    }
    
    // MARK: - Activity
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        
        popGestureDelegate = interactivePopGestureRecognizer?.delegate
    }
    
    // MARK: UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return isGestureBack
    }
    
    // MARK: - Event
    
    /**
     跳转页面
     
     - parameter    viewController:     页面
     - parameter    animated:           动画
     */
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        super.pushViewController(viewController, animated: animated)
        
        isGestureBack = false
    }
    
    // MARK: - deinit
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        #if DEBUG
        print("deinit: \(self)")
        #endif
    }
}
