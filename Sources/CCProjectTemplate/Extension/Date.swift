//
//  Date.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation

// MARK: - 时间格式

public extension Date {
    
    /**
     时间格式化
     
     - parameter    string:     格式  例如:yyyy-MM-dd HH:mm:ss.SSS
     
     - returns: String  格式化字符串
     */
    func format(_ string: String = "yyyy-MM-dd HH:mm:ss") -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = string
        
        return formatter.string(from: self)
    }
    
    /**
     时间格式化
     
     - parameter    string:         格式  例如:yyyy-MM-dd HH:mm:ss.SSS
     - parameter    dateString:     时间字符串（按照string格式）
     */
    static func format(_ string: String = "yyyy-MM-dd HH:mm:ss", dateString: String) -> Date? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = string
        
        return formatter.date(from: dateString)
    }
}
