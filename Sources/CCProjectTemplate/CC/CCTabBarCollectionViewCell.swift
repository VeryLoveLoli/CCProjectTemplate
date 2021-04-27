//
//  CCTabBarCollectionViewCell.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/4.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit
import JSONValue

/**
 CC标签栏集合视图Cell
 */
open class CCTabBarCollectionViewCell: CCCollectionViewCell {
    
    /// 标题
    @IBOutlet open weak var title: UILabel?
    
    /**
     更新
     
     - parameter    json:   JSON数据
     */
    open override func update(_ json: JSONValue) {
        
        title?.text = json.title.number.string
        
        if json.select.number.bool {
            
            title?.textColor = UIColor.darkGray
            title?.font = UIFont.boldSystemFont(ofSize: 16)
        }
        else {
            
            title?.textColor = UIColor.lightGray
            title?.font = UIFont.systemFont(ofSize: 14)
        }
    }
}
