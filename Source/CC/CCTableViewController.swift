//
//  CCTableViewController.swift
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
import Network

/**
 CC列表视图控制器
 */
open class CCTableViewController: CCViewController, UITableViewDelegate, UITableViewDataSource {
    
    /**
     Storyboard
     */
    open override class func storyboard() -> Self {
        
        return storyboard(name: "CC", identifier: "CCTableViewController")
    }
    
    /// 列表
    @IBOutlet open weak var tableView: DragLoadTableView!
    
    /// 页码
    open var page = 0
    /// 是否分组
    open var isGroup = false
    /// 是否显示空数据Cell
    open var isShowEmptyCell = false
    /// 修改Cell
    open var cellNibName: String?
    /// 修改空数据Cell
    open var emptyCellNibName: String? = "CCTableViewEmptyCell"
    /// 设置Header
    open var headerViewNibName: String? = "CCTableViewHeaderFooterView"
    /// 设置Footer
    open var footerNibName: String? = "CCTableViewHeaderFooterView"
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.dragUpLoading = {[weak self] in
            
            self?.page += 1
            self?.networkLoading()
        }
        
        tableView.dragDownLoading = {[weak self] in
            
            self?.page = 0
            self?.networkLoading()
        }
        
        if let name = cellNibName {
            
            tableView.register(UINib.init(nibName: name, bundle: nil), forCellReuseIdentifier: "Cell")
        }
        
        if let name = emptyCellNibName {
            
            tableView.register(UINib.init(nibName: name, bundle: nil), forCellReuseIdentifier: "EmptyCell")
        }
        
        if let name = headerViewNibName {
            
            tableView.register(UINib.init(nibName: name, bundle: nil), forHeaderFooterViewReuseIdentifier: "Header")
        }
        
        if let name = footerNibName {
            
            tableView.register(UINib.init(nibName: name, bundle: nil), forHeaderFooterViewReuseIdentifier: "Footer")
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
            
            if self.tableView.dragUpView?.dragLoadStatus == .loading {
                
                self.tableView.endDragUpLoading()
                
                if bool {
                    
                    self.source = (self.source.array + array).json
                    
                    self.tableView.reloadData()
                }
                else {
                    
                    self.page -= 1
                }
            }
            else if self.tableView.dragDownView?.dragLoadStatus == .loading {
                
                self.tableView.endDragDownLoading()
                
                if bool {
                    
                    self.source = array.json
                    
                    self.tableView.reloadData()
                }
                else if !self.isShowEmptyCell {
                    
                    self.isShowEmptyCell = true
                    
                    self.tableView.reloadData()
                }
                
            }
            
            self.tableView.isDragUp = array.count > 0
            
            if !bool && !message.isEmpty {
                
                self.promptTitle(message)
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    /**
     分组数量
     */
    open func numberOfSections(in tableView: UITableView) -> Int {
        
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
     分组行数
     */
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
     设置行
     */
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isShowEmptyCell {
            
            return tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as! CCTableViewCell
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CCTableViewCell
            cell.update(isGroup ? source[indexPath.section].list[indexPath.row] : source[indexPath.row])
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    
    /**
     选择行
     */
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
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
    
    /**
     组头高度
     */
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if isShowEmptyCell {
            
            return 0.000001
        }
        else if isGroup {
            
            return CGFloat(source[section].header.height.number.float)
        }
        else {
            
            return 0.000001
        }
    }
    
    /**
     组尾高度
     */
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if isShowEmptyCell {
            
            return 0.000001
        }
        else if isGroup {
            
            return CGFloat(source[section].footer.height.number.float)
        }
        else {
            
            return 0.000001
        }
    }
    
    /**
     设置组头
     */
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if isShowEmptyCell {
            
            return nil
        }
        else if isGroup {
            
            let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header")
            
            if let cc = cell as? CCTableViewHeaderFooterView {
                
                cc.update(source[section].header)
            }
            
            return cell
        }
        else {
            
            return nil
        }
    }
    
    /**
     设置组尾
     */
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if isShowEmptyCell {
            
            return nil
        }
        else if isGroup {
            
            let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Footer")
            
            if let cc = cell as? CCTableViewHeaderFooterView {
                
                cc.update(source[section].footer)
            }
            
            return cell
        }
        else {
            
            return nil
        }
    }
}
