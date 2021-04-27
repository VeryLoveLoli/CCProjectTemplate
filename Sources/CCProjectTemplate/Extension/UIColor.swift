//
//  File.swift
//  
//
//  Created by 韦烽传 on 2021/3/15.
//

import Foundation
import UIKit

// MARK: - 颜色值

public extension UIColor {
    
    /**
     Hex 颜色值
     */
    static func hex(_ value: UInt32) -> UIColor {
        
        let r = (value & 0xFF000000) >> 24
        let g = (value & 0x00FF0000) >> 16
        let b = (value & 0x0000FF00) >> 8
        let a = (value & 0x000000FF)
        
        return rgba(r: Int(r), g: Int(g), b: Int(b), a: Int(a))
    }
    
    /**
     RGBA 颜色值
     */
    static func rgba(r: Int, g: Int, b: Int, a: Int) -> UIColor {
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a)/255.0)
    }
}
