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
    
    /// 集合
    @IBOutlet open weak var collectionView: DragLoadCollectionView!
    
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
    
    /// 修改Cell
    open var cellNibName: String? {
        
        didSet {
            
            if let name = cellNibName {
                
                collectionView.register(UINib.init(nibName: name, bundle: nil), forCellWithReuseIdentifier: CCCollectionView.CellIdentifier)
            }
        }
    }
    
    /// 设置Header
    open var headerNibName: String? {
        
        didSet {
            
            if let name = headerNibName {
                
                collectionView.register(UINib.init(nibName: name, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CCCollectionView.HeaderIdentifier)
            }
        }
    }
    
    /// 设置Footer
    open var footerNibName: String? {
        
        didSet {
            
            if let name = footerNibName {
                
                collectionView.register(UINib.init(nibName: name, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CCCollectionView.FooterIdentifier)
            }
        }
    }
    
    /// 修改空数据Cell
    open var emptyCellNibName: String? {
        
        didSet {
            
            if let name = emptyCellNibName {
                
                collectionView.register(UINib.init(nibName: name, bundle: nil), forCellWithReuseIdentifier: CCCollectionView.EmptyIdentifier)
            }
        }
    }
    
    /// 设置 Empty Header
    open var emptyHeaderNibName: String? {
        
        didSet {
            
            if let name = emptyHeaderNibName {
                
                collectionView.register(UINib.init(nibName: name, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CCCollectionView.EmptyIdentifier)
            }
        }
    }
    
    /// 设置 Empty Footer
    open var emptyFooterNibName: String? {
        
        didSet {
            
            if let name = emptyFooterNibName {
                
                collectionView.register(UINib.init(nibName: name, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CCCollectionView.EmptyIdentifier)
            }
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        /// Xcode 11 Storyboard 默认为 UICollectionViewFlowLayout.automaticSize
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = CGSize.zero
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let flow = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            collectionView.isVerticalScroll = flow.scrollDirection == .vertical
        }
        
        collectionView.dragUpLoading = {[weak self] in
            
            self?.page += 1
            self?.networkLoading()
        }
        
        collectionView.dragDownLoading = {[weak self] in
            
            self?.page = 0
            self?.networkLoading()
        }
        
        
        headerNibName = CCCollectionView.HeaderNibName
        footerNibName = CCCollectionView.FooterNibName
        emptyCellNibName = CCCollectionView.EmptyCellNibName
        emptyHeaderNibName = CCCollectionView.EmptyHeaderFooterCellNibName
        emptyFooterNibName = CCCollectionView.EmptyHeaderFooterCellNibName
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
                    
                    self.isShowEmptyCell = array.isEmpty
                    
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
