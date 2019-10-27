//
//  CCJSONValueModelKeyProtocol.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/6.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation

/**
 CCJSONValue模型Key协议
 
 按照以下模型使用
 
 enum <#name#>: String, CCDataModelKeyProtocol {
     case <#case#>
 }
 */
public protocol CCJSONValueModelKeyProtocol {
    
    /// 类型值
    var rawValue: String { get }
}
