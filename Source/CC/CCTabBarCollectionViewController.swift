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
    
    /**
     Storyboard
     */
    open override class func storyboard() -> Self {
        
        return storyboard(name: "CC", identifier: "CCTabBarCollectionViewController")
    }
    
    /// 标签栏集合视图
    @IBOutlet open weak var tabBarCollectionView: CCTabBarCollectionView?
    
    /// 索引
    var index = 0 {
        
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
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        update()
        tabBarCollectionView?.update()
    }
    
    // MARK: - UICollectionViewDataSource
    
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        
        let vc = list[indexPath.row]
        vc.view.removeFromSuperview()
        cell.contentView.addSubview(vc.view)
        vc.view.constraintForSuperview()
        
        return cell
    }
    
    // MARK: UIScrollViewDelegate
    
    /**
     滑动停止
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

/**
 CC标签栏集合视图
 */
open class CCTabBarCollectionView: CCCollectionView {
    
    /**
     XIB
     */
    open override class func xib() -> Self {
        
        return xib(name: "CCTabBarCollectionView", index: 0)
    }
    
    /// 滑块
    open lazy var sliderImageView: UIImageView = {
        
       return initSlider()
    }()
    
    /// 滑块大小
    open var sliderSize: CGSize?
    /// 滑块动画时间
    open var sliderAnimateTime: TimeInterval = 0.25
    
    /// 可见标签数量
    open var visibleTabBarNumber: CGFloat = 2
    
    /// 索引
    open var index = 0 {
        
        didSet {
            
            if oldValue != index {
                
                update()
            }
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.addSubview(sliderImageView)
    }
    
    // MARK: - UICollectionViewDelegate
    
    open override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, didSelectItemAt: indexPath)
        
        index = indexPath.row
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    /**
     格子大小
     */
    open override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: CGFloat(Int(collectionView.frame.width/visibleTabBarNumber)), height: collectionView.frame.height)
    }
    
    // MARK: - Event
    
    /**
     初始化滑块
     */
    open func initSlider() -> UIImageView {
        
        let imageView = UIImageView.init(image: UIImage.init(named: "CC_point_pink"))
        
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        
        return imageView
    }
    
    /**
     更新
     */
    open func update() {
        
        for i in 0..<source.array.count {
            
            source[i].select = (i == index).json
        }
        
        collectionView.reloadData()
        
        let cellSize = CGSize.init(width: CGFloat(Int(collectionView.frame.width/visibleTabBarNumber)), height: collectionView.frame.height)
        
        if index == 0 {
            
            collectionView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        }
        else if index == source.array.count - 1 {
            
            collectionView.setContentOffset(CGPoint.init(x: collectionView.contentSize.width - collectionView.frame.width, y: 0), animated: true)
        }
        else {
            
            var px = Int((CGFloat(index+1+1)-visibleTabBarNumber)*cellSize.width)
            
            if px < 0 {
                
                px = 0
            }
            else if CGFloat(px) + CGFloat(index+1) * cellSize.width >= collectionView.contentSize.width {
                
                px = Int(collectionView.contentSize.width - collectionView.frame.width)
            }
            
            collectionView.setContentOffset(CGPoint.init(x: px, y: 0), animated: true)
        }
        
        let imageSize = sliderSize ?? CGSize.init(width: 0.8*cellSize.width, height: 3)
        
        UIView.animate(withDuration: sliderAnimateTime) {
            
            self.sliderImageView.frame = CGRect.init(origin: CGPoint.init(x: cellSize.width*CGFloat(self.index) + (cellSize.width - imageSize.width)/2, y: cellSize.height - imageSize.height), size: imageSize)
        }
    }
}

/**
 CC标签栏集合视图Cell
 */
open class CCTabBarCollectionViewCell: CCCollectionViewCell {
    
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
