//
//  Int.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation

// MARK: - 磁盘大小

public extension Int {
    
    /**
     磁盘大小
     
     - returns: String  格式化字符串  例如：1000B、200.00KB、300.12MB
     */
    func diskSize() -> String {
        
        var number = self
        var remainder = 0
        var unit = 0
        
        while number/1024 > 0 {
            
            unit += 1
            remainder = number%1024
            number = number/1024
        }
        
        var unitString = ""
        switch unit {
        case 0:
            unitString = "B"
        case 1:
            unitString = "KB"
        case 2:
            unitString = "MB"
        case 3:
            unitString = "GB"
        case 4:
            unitString = "TB"
        case 5:
            unitString = "PB"
        case 6:
            unitString = "EB"
        case 7:
            unitString = "ZB"
        case 8:
            unitString = "YB"
        case 9:
            unitString = "BB"
        case 10:
            unitString = "NB"
        case 11:
            unitString = "DB"
        case 12:
            unitString = "CB"
        default:
            unitString = "?B"
        }
        
        var size = ""
        
        if unit == 0 {
            
            size = "\(number)" + unitString
        }
        else {
            
            size = String.init(format: "%.2f", Float(number) + Float(remainder)/1024.0) + unitString
        }
        
        return size
    }
}
