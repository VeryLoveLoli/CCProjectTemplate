//
//  UIView.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation

import UIKit

// MARK: 约束

public extension UIView {
    
    /**
     约束(基于superview)
     
     - parameter    top:        上
     - parameter    bottom:     下
     - parameter    leading:    左
     - parameter    right:      右
     */
    func constraintForSuperview(top: CGFloat = 0, bottom: CGFloat = 0, leading: CGFloat = 0, right: CGFloat = 0) {
        
        if let superview = superview {
            
            translatesAutoresizingMaskIntoConstraints = false
            
            let t = NSLayoutConstraint.init(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: top)
            let l = NSLayoutConstraint.init(item: self, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: leading)
            let b = NSLayoutConstraint.init(item: superview, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: bottom)
            let r = NSLayoutConstraint.init(item: superview, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: right)
            
            superview.addConstraints([t, l, b, r])
        }
    }
}
