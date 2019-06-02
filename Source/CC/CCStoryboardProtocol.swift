//
//  CCStoryboardProtocol.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit

/**
 CC故事板协议
 
 故事板初始化视图控制器，自动转换对应的类
 */
public protocol CCStoryboardProtocol {
    
    /**
     故事板初始化视图控制器，调用 storyboard(name: String, identifier: String)
     */
    static func storyboard() -> Self
    
    /**
     故事板初始化视图控制器
     
     - parameter    name:           故事板名称
     - parameter    identifier:     视图控制器ID
     */
    static func storyboard(name: String, identifier: String) -> Self
    
    /**
     默认设置
     */
    static func defaultSetting(_ vc: UIViewController)
}

public extension CCStoryboardProtocol {
    
    /**
     故事板初始化视图控制器
     
     - parameter    name:           故事板名称
     - parameter    identifier:     视图控制器ID
     */
    static func storyboard(name: String, identifier: String) -> Self {
        
        let vc = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: identifier)
        defaultSetting(vc)
        return vc as! Self
    }
}
