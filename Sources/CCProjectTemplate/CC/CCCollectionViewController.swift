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
    
    /// 集合
    @IBOutlet open weak var collectionView: UICollectionView!
    
    /// 顶部加载视图（创建加载视图并设置拖动方向和偏移值）
    open var topLoad = DragLoadTitleView(.down(DragLoad.offsetValue))
    /// 底部加载视图（创建加载视图并设置拖动方向和偏移值）
    open var bottomLoad = DragLoadTitleView(.up(DragLoad.offsetValue))
    
    /// 页码
    open var page = 0
    /// 是否分组
    open var isGroup = false
    /// 是否显示空数据Cell
    open var isShowEmptyCell = false
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11, *) {
            
        }
        else {
            
            automaticallyAdjustsScrollViewInsets = false
        }
        
        /// Xcode 11 Storyboard 默认为 UICollectionViewFlowLayout.automaticSize
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = CGSize.zero
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let flow = collectionView.collectionViewLayout as? UICollectionViewFlowLayout, flow.scrollDirection == .horizontal {
            
            topLoad = DragLoadTitleView(.right(DragLoad.offsetValue))
            bottomLoad = DragLoadTitleView(.left(DragLoad.offsetValue))
        }
        
        collectionView.addSubview(topLoad)
        
        topLoad.isDragLoad = false
        
        topLoad.dragLoadCallback = {[weak self] in
            
            self?.page = 0
            self?.networkLoading()
        }
        
        collectionView.addSubview(bottomLoad)
        
        bottomLoad.isDragLoad = false
        
        bottomLoad.dragLoadCallback = {[weak self] in
            
            self?.page += 1
            self?.networkLoading()
        }
        
        collectionView.registerHeader(CCCollectionView.HeaderNibName, bundle: .module)
        collectionView.registerFooter(CCCollectionView.FooterNibName, bundle: .module)
        collectionView.registerHeader(CCCollectionView.EmptyHeaderFooterCellNibName, bundle: .module, identifier: CCCollectionView.EmptyIdentifier)
        collectionView.registerFooter(CCCollectionView.EmptyHeaderFooterCellNibName, bundle: .module, identifier: CCCollectionView.EmptyIdentifier)
        collectionView.registerCell(CCCollectionView.EmptyCellNibName, bundle: .module, identifier: CCCollectionView.EmptyIdentifier)
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
            
            if self.bottomLoad.isDragLoad {
                
                self.bottomLoad.loadEnd(self.collectionView)
                
                if bool {
                    
                    self.source = (self.source.array + array).json
                    
                    self.collectionView.reloadData()
                }
                else {
                    
                    self.page -= 1
                }
            }
            else {
                
                if self.topLoad.isDragLoad {
                    
                    self.topLoad.loadEnd(self.collectionView)
                }
                
                if bool {
                    
                    self.source = array.json
                    
                    self.isShowEmptyCell = array.isEmpty
                    
                    self.collectionView.reloadData()
                }
                else if !self.isShowEmptyCell {
                    
                    self.isShowEmptyCell = true
                    
                    self.collectionView.reloadData()
                }
                
            }
            
            self.bottomLoad.isDragLoad = array.count > 0
            
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
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: CCCollectionView.EmptyIdentifier, for: indexPath) as! CCCollectionViewCell
        }
        else {
            
            let item = isGroup ? source[indexPath.section].list[indexPath.row] : source[indexPath.row]
            
            var identifier = item.identifier.number.string
            
            if identifier.count == 0 {
                
                identifier = CCCollectionView.CellIdentifier
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CCCollectionViewCell
            
            cell.update(item)
            return cell
        }
    }
    
    /**
     设置组头组尾
     */
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            
            let item = source[indexPath.section].header
            
            var identifier = item.identifier.number.string
            
            if identifier.count == 0 {
                
                if item.dictionary.count == 1 && (!item.height.isEmpty() || !item.width.isEmpty()) {
                    
                    identifier = CCCollectionView.EmptyIdentifier
                }
                else {
                    
                    identifier = CCCollectionView.HeaderIdentifier
                }
            }
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
            
            if let cc = header as? CCCollectionViewHeaderFooterView {
                
                cc.update(item)
            }
            
            return header
        }
        else if kind == UICollectionView.elementKindSectionFooter {
            
            let item = source[indexPath.section].footer
            
            var identifier = item.identifier.number.string
            
            if identifier.count == 0 {
                
                if item.dictionary.count == 1 && (!item.height.isEmpty() || !item.width.isEmpty()) {
                    
                    identifier = CCCollectionView.EmptyIdentifier
                }
                else {
                    
                    identifier = CCCollectionView.FooterIdentifier
                }
            }
            
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
            
            if let cc = footer as? CCCollectionViewHeaderFooterView {
                
                cc.update(item)
            }
            
            return footer
        }
        else {
            
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CCCollectionView.EmptyIdentifier, for: indexPath)
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
