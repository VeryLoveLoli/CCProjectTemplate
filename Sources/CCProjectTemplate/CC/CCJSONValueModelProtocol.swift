//
//  CCJSONValueModelProtocol.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/6.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import JSONValue

/**
 CCJSONValue模型协议
 
 重新实现对应的 CCJSONValueModelKeyProtocol 下标 可以直接 点出属性
 */
public protocol CCJSONValueModelProtocol {
    
    /// JSON
    var json: JSONValue { get set }
    
    /**
     下标
     */
    subscript(_ key: CCJSONValueModelKeyProtocol) -> JSONValue { get set }
}

/*
// MARK: - 实现属性

/// json存储Key
private var json_key: UInt8 = 0

public extension CCJSONValueModelProtocol {
    
    /// 通用存储属性
    var json: JSONValue {
        
        get {
            
            return objc_getAssociatedObject(self, &json_key) as? JSONValue ?? JSONValue()
        }
        set {
            
            objc_setAssociatedObject(self, &json_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
*/

// MARK: - 实现下标

public extension CCJSONValueModelProtocol {
    
    /**
     下标
     */
    subscript(_ key: CCJSONValueModelKeyProtocol) -> JSONValue {
        
        set { json[key.rawValue] = newValue }
        get { json[key.rawValue] }
    }
}

/// 示例
/*
struct ExampleJSONModel: CCJSONValueModelProtocol {
    
    enum Key: String, CCJSONValueModelKeyProtocol {
        
        case id
        //...
    }
    
    var json: JSONValue
    
    init(_ value: JSONValue) {
        
        json = value
    }
    
    subscript(key: Key) -> JSONValue {
        
        set { json[key.rawValue] = newValue }
        get { json[key.rawValue] }
    }
}
 */
