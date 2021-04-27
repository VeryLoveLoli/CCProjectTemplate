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
     XIB初始化视图，调用 storyboard(name: String,bundle:bundle?, identifier: String)
     */
    static func xib() -> Self
    
    /**
     XIB初始化视图
     
     - parameter    name:           XIB名称
     - parameter    bundle:         Bundle包
     - parameter    index:          视图位置
     */
    static func xib(name: String, bundle: Bundle?, index: Int) -> Self
    
    /**
     NIB
     
     - parameter    bundle:         Bundle包
     */
    static func nib(_ bundle: Bundle?) -> UINib
    
    /**
     默认设置
     */
    static func defaultSetting(_ any: Any)
}

public extension CCXIBProtocol {
    
    /**
     XIB初始化视图，调用 storyboard(name: String,bundle:bundle?, identifier: String)
    */
    static func xib() -> Self {
        
        return xib(name: "\(Self.self)")
    }
    
    /**
     XIB初始化视图
     
     - parameter    name:           XIB名称
     - parameter    bundle:         Bundle包
     - parameter    index:          视图位置
     */
    static func xib(name: String, bundle: Bundle? = nil, index: Int = 0) -> Self {
        
        let v = UINib.init(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil)[index]
        defaultSetting(v)
        return v as! Self
    }
    
    /**
     NIB
     
     - parameter    bundle:         Bundle包
     */
    static func nib(_ bundle: Bundle? = nil) -> UINib {
        
        return UINib.init(nibName: "\(Self.self)", bundle: bundle)
    }
}
