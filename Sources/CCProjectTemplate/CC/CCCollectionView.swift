//
//  CCCollectionView.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/3.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit
import JSONValue
import DragLoad
import Prompt

/**
 CC集合视图
 */
open class CCCollectionView: CCView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /// 默认 Cell Identifier
    public static let CellIdentifier = "Cell"
    /// 默认 Header Identifier
    public static let HeaderIdentifier = "Header"
    /// 默认 Footer Identifier
    public static let FooterIdentifier = "Footer"
    /// 默认 空白 Cell、Header、Footer Identifier
    public static let EmptyIdentifier = "Empty"
    
    /// 空数据Cell Nib名称
    public static let EmptyCellNibName = "CCCollectionViewEmptyCell"
    /// Header Nib名称
    public static let HeaderNibName = "CCCollectionViewHeaderFooterView"
    /// Footer Nib名称
    public static let FooterNibName = "CCCollectionViewHeaderFooterView"
    /// 空白 Header、Footer Nib名称
    public static let EmptyHeaderFooterCellNibName = "CCCollectionViewEmptyHeaderFooterView"
    
    /// 顶部加载视图
    public static var TopLoad: ()->DragLoadView = { DragLoadTitleView(.down(DragLoad.offsetValue)) }
    /// 底部加载视图
    public static var BottomLoad: ()->DragLoadView = { DragLoadTitleView(.up(DragLoad.offsetValue)) }
    
    /// 集合
    @IBOutlet open weak var collectionView: UICollectionView!
    
    /// 顶部加载视图
    open var topLoad = CCCollectionView.TopLoad()
    /// 底部加载视图
    open var bottomLoad = CCCollectionView.BottomLoad()
    
    /// 回调
    open var callback: (JSONValue)->JSONValue = {_ in return JSONValue()}
    /// 网络回调
    open var networkCallback: (Int)->(Bool,[JSONValue],String) = {_ in return (true,[],"")}
    
    /// 数据
    open var source = JSONValue()
    
    /// 页码
    open var page = 0
    /// 是否分组
    open var isGroup = false
    /// 是否显示空数据Cell
    open var isShowEmptyCell = false
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
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
    open func networkLoading() {
        
        DispatchQueue.global().async {
            
            let (bool, array, message) = self.networkCallback(self.page)
            
            self.networkLoadingEnd(bool, array: array, message: message)
        }
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
