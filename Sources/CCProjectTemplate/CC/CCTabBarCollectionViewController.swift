//
//  CCTabBarCollectionViewController.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/3.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit
import JSONValue

/**
 CC标签栏集合视图控制器
 */
open class CCTabBarCollectionViewController: CCCollectionViewController {
    
    /// 标签栏集合视图
    @IBOutlet open weak var tabBarCollectionView: CCTabBarCollectionView?
    
    /// 索引
    open var index = 0 {
        
        didSet {
            
            if oldValue != index {
                
                update()
            }
        }
    }
    
    /// 视图控制器列表
    open var list: [UIViewController] = [] {
        
        willSet {
            
            for vc in list {
                
                vc.removeFromParent()
            }
        }
        
        didSet {
            
            for vc in list {
                
                addChild(vc)
            }
        }
    }
    
    open override var source: JSONValue {
        
        didSet {
            
            collectionView?.reloadData()
            tabBarCollectionView?.source = source
            tabBarCollectionView?.collectionView.reloadData()
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarCollectionView?.callback = { [weak self] (json) in
            
            if !json.row.isEmpty() {
                
                self?.index = json.row.number.int
            }
            
            return JSONValue()
        }
        
        for i in 0..<list.count {
            
            collectionView.register(CCCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "Cell\(i)")
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        update()
        tabBarCollectionView?.update()
    }
    
    // MARK: - UICollectionViewDataSource
    
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell\(indexPath.row)", for: indexPath)
        
        let vc = list[indexPath.row]
        
        if vc.view.superview == nil {
            
            cell.contentView.addSubview(vc.view)
            vc.view.constraintForSuperview()
        }
        
        return cell
    }
    
    // MARK: UIScrollViewDelegate
    
    /**
     减速结束
     */
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if collectionView == scrollView {
            
            index = Int(scrollView.contentOffset.x/scrollView.frame.width)
            tabBarCollectionView?.index = index
        }
    }
    
    // MARK: Event
    
    /**
     更新
     */
    open func update() {
        
        collectionView.setContentOffset(CGPoint.init(x: index*Int(collectionView.frame.width), y: 0), animated: true)
    }
    
    // MARK: - deinit
    
    deinit {
        
        list = []
    }
}
