//
//  NSObjectProtocol.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation

// MARK: - 通用存储属性

/// 通用存储Key
private var any_key: UInt8 = 0

public extension NSObjectProtocol {
    
    /// 通用存储属性
    var any: Any? {
        
        get {
            
            return objc_getAssociatedObject(self, &any_key)
        }
        set {
            
            objc_setAssociatedObject(self, &any_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
