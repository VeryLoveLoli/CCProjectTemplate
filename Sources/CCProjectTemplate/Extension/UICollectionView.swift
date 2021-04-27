//
//  File.swift
//  
//
//  Created by 韦烽传 on 2020/12/1.
//

import Foundation
import UIKit

/**
 扩展注册方法
 */
public extension UICollectionView {
    
    /**
     注册Cell
     
     - parameter    name:           XIB名称
     - parameter    bundle:         Bundle包
     - parameter    identifier:     identifier
     */
    func registerCell(_ name: String, bundle: Bundle? = nil, identifier: String = CCCollectionView.CellIdentifier) {
        
        register(UINib.init(nibName: name, bundle: bundle), forCellWithReuseIdentifier: identifier)
    }
    
    /**
     注册Header
     
     - parameter    name:           XIB名称
     - parameter    bundle:         Bundle包
     - parameter    identifier:     identifier
     */
    func registerHeader(_ name: String, bundle: Bundle? = nil, identifier: String = CCCollectionView.HeaderIdentifier) {
        
        register(UINib.init(nibName: name, bundle: bundle), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
    }
    
    /**
     注册Footer
     
     - parameter    name:           XIB名称
     - parameter    bundle:         Bundle包
     - parameter    identifier:     identifier
     */
    func registerFooter(_ name: String, bundle: Bundle? = nil, identifier: String = CCCollectionView.FooterIdentifier) {
        
        register(UINib.init(nibName: name, bundle: bundle), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier)
    }
}
