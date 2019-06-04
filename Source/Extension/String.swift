//
//  String.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/4.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation

// MARK: 区间字符串

extension String {
    
    /**
     获取索引字符串
     */
    subscript(_ i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    /**
     获取索引区间字符串
     */
    subscript(_ range: Range<Int>) -> String {
        
        if count == 0 {
            
            return ""
        }
        
        let i = min(range.lowerBound, self.count)
        let l = min(range.upperBound, self.count) - range.lowerBound
        
        let start = index(startIndex, offsetBy: i)
        let end = index(start, offsetBy: l)
        
        return String(self[start..<end])
    }
}
