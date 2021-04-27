//
//  File.swift
//  
//
//  Created by 韦烽传 on 2020/12/2.
//

import Foundation
import UIKit
import JSONValue
import CryptoSwift

/**
 CC选择提示
 */
open class CCPickerAlertViewController: CCAlertViewController, UIPickerViewDelegate, UIPickerViewDataSource {
        
    /// 回调类型
    public enum CallBackType {
        
        /// 标题
        case title
        /// 索引
        case index
    }
        
    // MARK: - Parameter
    
    /// 选择索引保存路径
    public static let filePath =  FileManager.documentsPath + "PickerAlertSelectIndex"
    /// AESKey
    public static let aesKey = "xklaj930dma7nx0s"
    /// AES
    public static let aes = AES.init(aesKey)
    
    /// UIPickerView
    @IBOutlet open weak var pickerView: UIPickerView!

    /// 列数
    open var column = 1
    /// 选择数据
    open var dataSource = JSONValue()
    /// 选择索引数组
    open var selectIndexArray = JSONValue()
    /// 选择标题数组
    open var selectTitleArray = JSONValue()
    
    /// 选择索引标记
    open var selectIndexMake = "make"
    /// 是否移动到上一次选择
    open var isMovePreviousSelect = true
    /// 移动指定索引数组(仅在 isMoveSelect = true 有效)
    open var moveIndexArray = JSONValue()
    /// 是否移动到指定选择(需先设置 moveIndexArray )
    open var isMoveSelect = false
    
    /// 回调类型
    open var type: CallBackType = .title
    
    
    // MARK: - Nib
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        animateType = .bottom
    }
    
    // MARK: - Activity
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.titleLabel?.text = self.title
        self.selectIndexArray = JSONValue([Int].init(repeating: 0, count: self.column))
        self.updateSelectTitleArray(0, component: 0)
        
        if self.isMoveSelect {
            
            var data = self.dataSource

            for i in 0..<self.column {
                
                self.selectIndexArray[i] = self.moveIndexArray[i]
                
                if i > 0 {
                    
                    data =  data[self.selectIndexArray[i].number.int]["list"]
                }
                
                if self.selectIndexArray[i].number.int >= data.array.count {
                    
                    self.selectIndexArray[i] = JSONValue(data.array.count-1)
                }
            }
            
            self.moveSelect()
        }
        else if self.isMovePreviousSelect {
            
            self.movePreviousSelect()
        }
    }
    
    // MARK: - UIPickerViewDataSource
    
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return self.column
    }
    
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var data = self.dataSource
        
        for i in 0..<component {
            
            data =  data[self.selectIndexArray[i].number.int]["list"]
        }
        
        return data.array.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return self.getSelectTitle(row, component: component)
    }
    
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.selectIndexArray[component] = JSONValue(row)
        
        var data = self.dataSource
        
        for i in 1..<self.column {
            
            data =  data[self.selectIndexArray[i-1].number.int]["list"]
            
            var index = self.selectIndexArray[i].number.int
            
            if i > component {
                
                self.pickerView.reloadComponent(i)//刷新
                
                if data.array.count <= index {
                    
                    index = data.array.count-1
                    self.selectIndexArray[i] = index.json
                    
                    self.pickerView.selectRow(index, inComponent: i, animated: true)
                }
            }
        }
        
        self.updateSelectTitleArray(row, component: component)
    }
    
    // MARK: - IBAction Event
    
    @IBAction func complete(_ sender: UIButton) {
        
        self.saveSelectIndex()
        
        self.hide(true) {
            
            switch self.type {
            case .title:
                _ = self.callback(self.selectTitleArray)
            case .index:
                _ = self.callback(self.selectIndexArray)
            }
        }
    }
    
    // MARK: - Event
    
    /**
     更新选择标题数组
     
     - parameter    row:        行数
     - parameter    component:  列数
     */
    func updateSelectTitleArray(_ row: Int, component: Int) {
        
        self.selectTitleArray[component] = self.getSelectTitle(row, component: component).json

        for i in (component+1)..<self.column {
            
            self.selectTitleArray[i] = self.getSelectTitle(0, component: i).json
        }
    }
    
    /**
     获取选择的标题
     
     - parameter    row:        行数
     - parameter    component:  列数
     */
    func getSelectTitle(_ row: Int, component: Int) -> String {
        
        var data = self.dataSource
        
        for i in 0..<component {
            
            data =  data[self.selectIndexArray[i].number.int]["list"]
        }
        
        return data[row]["title"].number.string
    }
    
    /**
     移动到上次选择
     */
    func movePreviousSelect() {
        
        let makeIndex = JSONValue.diskAES(CCPickerAlertViewController.aes, filePath: CCPickerAlertViewController.filePath)[self.selectIndexMake]
        
        if makeIndex.array.count == self.column {
            
            self.selectIndexArray = makeIndex
            
            var data = self.dataSource
            
            for i in 0..<self.column {
                
                if i > 0 {
                    
                    data =  data[self.selectIndexArray[i].number.int]["list"]
                }
                
                if self.selectIndexArray[i].number.int >= data.array.count && data.array.count != 0 {
                    
                    self.selectIndexArray[i] = JSONValue(data.array.count-1)
                }
            }
            
            self.moveSelect()
        }
    }
    
    /**
     移动到指定选择
     */
    func moveSelect() {
        
        for i in 0..<self.selectIndexArray.array.count {
            
            pickerView.reloadComponent(i)
            pickerView.selectRow(selectIndexArray[i].number.int, inComponent: i, animated: false)
            updateSelectTitleArray(self.selectIndexArray[i].number.int, component: i)
        }
    }
    
    /**
     保存本次选择
     */
    func saveSelectIndex() {
        
        var json = JSONValue.diskAES(CCPickerAlertViewController.aes, filePath: CCPickerAlertViewController.filePath)
        json[self.selectIndexMake] = self.selectIndexArray
        _ = json.saveAES(CCPickerAlertViewController.aes, filePath: CCPickerAlertViewController.filePath)
    }
}
