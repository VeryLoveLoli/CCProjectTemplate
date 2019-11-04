//
//  CCXIBProtocol.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/4.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit

/**
 CCXIB协议
 
 XIB初始化视图，自动转换对应的类
 */
public protocol CCXIBProtocol {
    
    /**
     故事板初始化视图，调用 storyboard(name: String, identifier: String)
     */
    static func xib() -> Self
    
    /**
     XIB初始化视图
     
     - parameter    name:           XIB名称
     - parameter    index:          视图位置
     */
    static func xib(name: String, index: Int) -> Self
    
    /**
     默认设置
     */
    static func defaultSetting(_ any: Any)
}

public extension CCXIBProtocol {
    
    /**
    故事板初始化视图，调用 storyboard(name: String, identifier: String)
    */
    static func xib() -> Self {
        
        return xib(name: "\(Self.self)", index: 0)
    }
    
    /**
     XIB初始化视图
     
     - parameter    name:           XIB名称
     - parameter    index:          视图位置
     */
    static func xib(name: String, index: Int) -> Self {
        
        let v = UINib.init(nibName: name, bundle: nil).instantiate(withOwner: nil, options: nil)[index]
        defaultSetting(v)
        return v as! Self
    }
}
