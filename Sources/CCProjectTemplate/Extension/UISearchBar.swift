//
//  File.swift
//  
//
//  Created by 韦烽传 on 2020/12/2.
//

import Foundation
import UIKit

// MARK: - 获取 textField

public extension UISearchBar {
    
    /// 获取 textField
    var textField: UITextField? {
        
        if #available(iOS 13, *) {
            
            return value(forKey: "searchField") as? UITextField
        }
        else {
            
            return value(forKey: "_searchField") as? UITextField
        }
    }
}
