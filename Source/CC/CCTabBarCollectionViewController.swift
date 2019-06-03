//
//  CCTabBarCollectionViewController.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/3.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit
import JSONValue

/**
 CC标签栏集合视图控制器
 */
open class CCTabBarCollectionViewController: CCCollectionViewController {
    
    /**
     Storyboard
     */
    open override class func storyboard() -> Self {
        
        return storyboard(name: "CC", identifier: "CCTabBarCollectionViewController")
    }
    
    /// 视图控制器列表
}
