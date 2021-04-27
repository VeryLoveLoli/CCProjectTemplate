//
//  File.swift
//  
//
//  Created by 韦烽传 on 2020/12/1.
//

import Foundation
import UIKit

/**
 资源包
 */
public extension Bundle {
    
    /// CCProjectTemplate 资源包
    static var cc = { Bundle.module }
}

/**
 图片资源
 */
public extension UIImage {
    
    static var CC_back_bar_gray = UIImage.init(named: "CC_back_bar_gray", in: .module, compatibleWith: nil)
    static var CC_back_bar_white = UIImage.init(named: "CC_back_bar_white", in: .module, compatibleWith: nil)
    static var CC_line_bottom = UIImage.init(named: "CC_line_bottom", in: .module, compatibleWith: nil)
    static var CC_line_left = UIImage.init(named: "CC_line_left", in: .module, compatibleWith: nil)
    static var CC_line_right = UIImage.init(named: "CC_line_right", in: .module, compatibleWith: nil)
    static var CC_line_top = UIImage.init(named: "CC_line_top", in: .module, compatibleWith: nil)
    static var CC_nil = UIImage.init(named: "CC_nil", in: .module, compatibleWith: nil)
    static var CC_point_pink = UIImage.init(named: "CC_point_pink", in: .module, compatibleWith: nil)
    static var CC_web_reload = UIImage.init(named: "CC_web_reload", in: .module, compatibleWith: nil)
}
