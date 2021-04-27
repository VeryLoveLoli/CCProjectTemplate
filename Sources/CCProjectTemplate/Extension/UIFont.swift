//
//  UIFont.swift
//  
//
//  Created by 韦烽传 on 2021/3/25.
//

import Foundation
import UIKit

// MARK: - 字体修改

public extension UIFont {
    
    /**
     系统粗体
     */
    func systemBody() -> UIFont {
        
        return systemWeight(.bold)
    }
    
    /**
     系统权重
     
     - parameter    value:  权重
     */
    func systemWeight(_ value: Weight) -> UIFont {
        
        return UIFont.systemFont(ofSize: pointSize, weight: value)
    }
}
