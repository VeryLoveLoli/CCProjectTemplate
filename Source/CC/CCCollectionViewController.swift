//
//  CCCollectionViewController.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit
import JSONValue
import DragLoad
import Prompt

/**
 CC集合视图控制器
 */
open class CCCollectionViewController: CCViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /**
     Storyboard
     */
    open override class func storyboard() -> Self {
        
        return storyboard(name: "CC", identifier: "CCCollectionViewController")
    }
    
    /// 集合
    @IBOutlet open weak var collectionView: DragLoadCollectionView!
    
    /// 页码
    open var page = 0
    /// 是否分组
    open var isGroup = false
    /// 是否显示空数据Cell
    open var isShowEmptyCell = false
    
    /// 修改Cell
    open var cellNibName: String? {
        
        didSet {
            
            if let name = cellNibName {
                
                collectionView.register(UINib.init(nibName: name, bundle: nil), forCellWithReuseIdentifier: "Cell")
            }
        }
    }
    
    /// 修改空数据Cell
    open var emptyCellNibName: String? = "CCCollectionViewEmptyCell" {
        
        didSet {
            
            if let name = emptyCellNibName {
                
                collectionView.register(UINib.init(nibName: name, bundle: nil), forCellWithReuseIdentifier: "EmptyCell")
            }
        }
    }
    
    /// 设置Header
    open var headerViewNibName: String? = "CCCollectionViewHeaderFooterView" {
        
        didSet {
            
            if let name = headerViewNibName {
                
                collectionView.register(UINib.init(nibName: name, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
            }
        }
    }
    
    /// 设置Footer
    open var footerNibName: String? = "CCCollectionViewHeaderFooterView" {
        
        didSet {
            
            if let name = footerNibName {
                
                collectionView.register(UINib.init(nibName: name, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")
            }
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.dragUpLoading = {[weak self] in
            
            self?.page += 1
            self?.networkLoading()
        }
        
        collectionView.dragDownLoading = {[weak self] in
            
            self?.page = 0
            self?.networkLoading()
        }
        
        if let name = cellNibName {
            
            collectionView.register(UINib.init(nibName: name, bundle: nil), forCellWithReuseIdentifier: "Cell")
        }
        
        if let name = emptyCellNibName {
            
            collectionView.register(UINib.init(nibName: name, bundle: nil), forCellWithReuseIdentifier: "EmptyCell")
        }
        
        if let name = headerViewNibName {
            
            collectionView.register(UINib.init(nibName: name, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        }
        
        if let name = footerNibName {
            
            collectionView.register(UINib.init(nibName: name, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")
        }
    }
    
    // MARK: - NetworkLoading
    
    /**
     网络加载
     */
    open override func networkLoading() {
        
    }
    
    /**
     网络加载结束
     
     - parameter    bool:       是否成功
     - parameter    array:      数据列表
     - parameter    message:    提示消息
     */
    open func networkLoadingEnd(_ bool: Bool, array: [JSONValue], message: String) {
        
        DispatchQueue.main.async {
            
            if self.collectionView.dragUpView?.dragLoadStatus == .loading {
                
                self.collectionView.endDragUpLoading()
                
                if bool {
                    
                    self.source = (self.source.array + array).json
                    
                    self.collectionView.reloadData()
                }
                else {
                    
                    self.page -= 1
                }
            }
            else {
                
                if self.collectionView.dragDownView?.dragLoadStatus == .loading {
                    
                    self.collectionView.endDragDownLoading()
                }
                
                if bool {
                    
                    self.source = array.json
                    
                    self.collectionView.reloadData()
                }
                else if !self.isShowEmptyCell {
                    
                    self.isShowEmptyCell = true
                    
                    self.collectionView.reloadData()
                }
                
            }
            
            self.collectionView.isDragUp = array.count > 0
            
            if !bool && !message.isEmpty {
                
                self.promptTitle(message)
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    /**
     分组数量
     */
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if isShowEmptyCell {
            
            return 1
        }
        else if isGroup {
            
            return source.array.count
        }
        else {
            
            return 1
        }
    }
    
    /**
     分组格子数
     */
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isShowEmptyCell {
            
            return 1
        }
        else if isGroup {
            
            return source[section].list.array.count
        }
        else {
            
            return source.array.count
        }
    }
    
    /**
     设置格子
     */
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isShowEmptyCell {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCell", for: indexPath) as! CCCollectionViewCell
        }
        else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CCCollectionViewCell
            cell.update(isGroup ? source[indexPath.section].list[indexPath.row] : source[indexPath.row])
            return cell
        }
    }
    
    /**
     设置组头组尾
     */
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
        }
        else if kind == UICollectionView.elementKindSectionFooter {
            
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
        }
        else {
            
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Empty", for: indexPath)
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    /**
     选择格子
     */
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isShowEmptyCell {
            
            _ = callback(JSONValue())
        }
        else if isGroup {
            
            var json = source[indexPath.section]
            json.list = json.list[indexPath.row]
            _ = callback(JSONValue(["section": indexPath.section, "row": indexPath.row, "json": json]))
        }
        else {
            
            _ = callback(JSONValue(["row": indexPath.row, "json": source[indexPath.row]]))
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    /**
     格子大小
     */
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.frame.size
    }
    
    /**
     组头大小
     */
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if let flow = collectionViewLayout as? UICollectionViewFlowLayout {
            
            if flow.scrollDirection == .vertical {
                
                return CGSize.init(width: collectionView.frame.size.width, height: CGFloat(source[section].header.height.number.float))
            }
            else {
                
                return CGSize.init(width: CGFloat(source[section].header.width.number.float), height: collectionView.frame.size.height)
            }
        }
        
        return CGSize.init(width: CGFloat(source[section].header.width.number.float), height: CGFloat(source[section].header.height.number.float))
    }
    
    /**
     组尾大小
     */
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if let flow = collectionViewLayout as? UICollectionViewFlowLayout {
            
            if flow.scrollDirection == .vertical {
                
                return CGSize.init(width: collectionView.frame.size.width, height: CGFloat(source[section].footer.height.number.float))
            }
            else {
                
                return CGSize.init(width: CGFloat(source[section].footer.width.number.float), height: collectionView.frame.size.height)
            }
        }
        
        return CGSize.init(width: CGFloat(source[section].footer.width.number.float), height: CGFloat(source[section].footer.height.number.float))
    }
}
