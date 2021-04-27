//
//  File.swift
//  
//
//  Created by 韦烽传 on 2020/12/2.
//

import Foundation
import UIKit

// MARK: - 设置 placeholderLabel

public extension UITextField {
    
    /**
     设置 placeholderLabel 文字颜色
        
     - parameter    color:  颜色
     */
    func placeholderLabelTextColor(_ color: UIColor) {
        
        if #available(iOS 13, *) {
            
            setValue(color, forKeyPath: "placeholderLabel.textColor")
        }
        else {
            
            setValue(color, forKeyPath: "placeholderLabel.textColor")
        }
    }
    
    /**
     设置 placeholderLabel 字体
        
     - parameter    font:   字体
     */
    func placeholderLabelFont(_ font: UIFont) {
        
        if #available(iOS 13, *) {
            
            setValue(font, forKeyPath: "placeholderLabel.font")
        }
        else {
            
            setValue(font, forKeyPath: "placeholderLabel.font")
        }
    }
}
