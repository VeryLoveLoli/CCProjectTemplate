//
//  CCGradientView.swift
//  
//
//  Created by 韦烽传 on 2021/6/4.
//

import Foundation
import UIKit

/**
 CC渐变视图
 */
open class CCGradientView: UIView {
    
    open override class var layerClass: AnyClass {
        
        CAGradientLayer.self
    }
    
    /**
     渐变图层
     */
    open var gradientLayer: CAGradientLayer {
        
        layer as! CAGradientLayer
    }
}
