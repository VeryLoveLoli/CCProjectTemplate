//
//  CCBannerCollectionViewCell.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/4.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit
import JSONValue
import Network

/**
 CCBanner集合Cell
 */
open class CCBannerCollectionViewCell: CCCollectionViewCell {
    
    /// 图标
    @IBOutlet open weak var icon: UIImageView?
    /// 标题
    @IBOutlet open weak var title: UILabel?
    
    /**
     更新
     
     - parameter    json:   JSON数据
     */
    open override func update(_ json: JSONValue) {
        
        var defaultImage: UIImage?
        
        if !json.icon.isEmpty()  {
            
            defaultImage = UIImage(named: json.icon.number.string, in: json.iconModule.number.bool ? .module : .main, compatibleWith: nil)
        }
        
        icon?.load(json.icon_url.number.string, defaultImage: defaultImage)
        title?.text = json.title.number.string
    }
}
