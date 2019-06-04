//
//  CCView.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/4.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit

/**
 CC视图
 */
open class CCView: UIView, CCXIBProtocol {
    
    /**
     XIB
     */
    open class func xib() -> Self {
        
        return xib(name: "CCView", index: 0)
    }
    
    /**
     默认设置
     */
    open class func defaultSetting(_ any: Any) {
        
    }
}
