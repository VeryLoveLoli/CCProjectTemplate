//
//  CCTableViewCell.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit
import JSONValue

/**
 CC列表Cell
 */
open class CCTableViewCell: UITableViewCell {
    
    /**
     更新
     
     - parameter    json:   JSON数据
     */
    open func update(_ json: JSONValue) {
        
        textLabel?.text = json.text.number.string
        detailTextLabel?.text = json.detailText.number.string
        if !json.image.isEmpty() {
            imageView?.image = UIImage.init(named: json.image.number.string, in: json.imageModule.number.bool ? .module : .main, compatibleWith: nil)
        }
        imageView?.load(json.image_url.number.string, defaultImage: imageView?.image?.image())
    }
}
