//
//  CCTabBarController.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit
import JSONValue

/**
 CC底部导航视图控制器
 */
open class CCTabBarController: UITabBarController {
    
    /// 回调
    open var callback: (JSONValue)->JSONValue = {_ in return JSONValue()}
    
    /// 按钮配置    [["title": xx, "image": xx, "selectedImage": xx, "titleHorizontal": xx, "titleVertical": xx, "imageHorizontal": xx, "imageVertical": xx],...]
    open var items = JSONValue()
    
    // MARK: - Activity
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Event
    
    /**
     更新按钮
     */
    open func updateTabBarItem() {
        
        var i = 0
        
        for vc in viewControllers ?? [] {
            
            let item = items[i]
            
            vc.title = item.title.number.string
            vc.tabBarItem.image = UIImage.init(named: item.image.number.string)?.withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.selectedImage = UIImage.init(named: item.selectedImage.number.string)?.withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.titlePositionAdjustment = UIOffset.init(horizontal: CGFloat(item.titleHorizontal.number.float), vertical: CGFloat(item.titleVertical.number.float))
            vc.tabBarItem.imageInsets = UIEdgeInsets(top: CGFloat(item.imageVertical.number.float), left: CGFloat(item.imageHorizontal.number.float), bottom: -CGFloat(item.imageVertical.number.float), right: -CGFloat(item.imageHorizontal.number.float))
            
            i += 1
        }
    }
    
    // MARK: - deinit
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        #if DEBUG
        print("deinit: \(self)")
        #endif
    }
}
