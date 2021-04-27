//
//  CCTableViewHeaderFooterView.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit
import JSONValue

/**
 CC列表组头组尾
 */
open class CCTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    /// 标题
    @IBOutlet open weak var title: UILabel?
    
    /**
     更新
     
     - parameter    json:   JSON数据
     */
    open func update(_ json: JSONValue) {
        
        title?.text = json.title.number.string
    }
}
