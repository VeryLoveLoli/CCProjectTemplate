//
//  CCDataModelProtocol.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/6.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import JSONValue
import TEA

/**
 CC数据模型协议
 */
public protocol CCDataModelProtocol {
    
    /// 文件路径
    static var filePath: String { get }
    /// 默认
    static var `default`: Self { get set }
    /// JSON
    var json: JSONValue { get set }
    
    /**
     初始化
     
     - parameter    value:  JSONValue
     */
    init(_ value: JSONValue)
    
    /**
     
     */
    subscript(_ key: CCDataModelKeyProtocol) -> JSONValue { get set }
    
    /**
     保存磁盘
     
     - parameter    filePath:   文件路径
     */
    func save(_ filePath: String) -> Bool
}

public extension CCDataModelProtocol {
    
    /// 文件路径
    static var filePath: String {
        
        let path = NSHomeDirectory() + "/Documents/JSONModel/"
        
        /// 文件管理
        let fileManager: FileManager = FileManager.default
        
        /// 判断文件夹是否存在
        if !fileManager.fileExists(atPath: path) {
            
            do {
                /// 创建文件夹
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                
            } catch {
                
            }
        }
        
        return path + "\(Self.self)"
    }
    
    subscript(_ key: CCDataModelKeyProtocol) -> JSONValue {
        
        get {
            
            return json["\(key.self)"]
        }
        
        set {
            
            json["\(key.self)"] = newValue
        }
    }
    
    /**
     保存磁盘
     */
    func save(_ filePath: String = Self.filePath) -> Bool {
        
        return json.save(filePath)
    }
}
