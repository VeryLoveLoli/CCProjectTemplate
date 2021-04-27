//
//  JSONValue.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import JSONValue

// MARK: - 存储

public extension JSONValue {
        
    /**
     磁盘
     
     - parameter    filePath:   文件路径
     
     - returns: JSONValue
     */
    static func disk(_ filePath: String) -> JSONValue {
        
        do {
            
            let data = try Data.init(contentsOf: URL.init(fileURLWithPath: filePath))
            
            return data.json
            
        } catch {
            
            CCPrint.error(error)
            
            return JSONValue()
        }
    }
    
    /**
     保存
     
     - parameter    filePath:           文件路径
     - parameter    isPrettyPrinted:    是否漂亮的格式
     - parameter    level:              层次字符串
     
     - returns: Bool    是否成功
     */
    @discardableResult func save(_ filePath: String, isPrettyPrinted: Bool = false, level: String = "") -> Bool {
        
        guard filePath.createDirectoryFromFilePath() else { return false }
        
        let data = JSONFormatData()
        
        do {
            
            try data.write(to: URL.init(fileURLWithPath: filePath))
            
            return true
            
        } catch  {
            
            CCPrint.error(error)
            
            return false
        }
    }
}

/*
 *  TEA加密比较简单，而且轻量级数据AES加密时间和TEA差不多
import TEA

// MARK: - 存储（TEA）

public extension JSONValue {
        
    /**
     磁盘
     
     - parameter    tea:        TEA密钥
     - parameter    filePath:   文件路径
     
     - returns: JSONValue
     */
    static func diskTEA(_ tea: TEA, filePath: String) -> JSONValue {
        
        do {
            
            var data = try Data.init(contentsOf: URL.init(fileURLWithPath: filePath))
            
            data = tea.decrypt(data)
            
            /// 是否是TEA解密数据（TEA 每次加密8位、不足会补位）
            if data.count%8 == 0 && data.count >= 8 {
                
                /// 还原数据（清除末尾多余'\0'）
                for _ in 0..<8 {
                    
                    if data[data.count-1] == 0 {
                        
                        data.remove(at: data.count-1)
                    }
                    else {
                        
                        break
                    }
                }
                
                return data.json
            }
            else {
                
                CCPrint.error("error: \(filePath) not tea file")
                
                return JSONValue()
            }
            
        } catch {
            
            CCPrint.error(error)
            
            return JSONValue()
        }
    }
    
    /**
     保存
     
     - parameter    tea:        TEA密钥
     - parameter    filePath:   文件路径
     
     - returns: Bool    是否成功
     */
    func saveTEA(_ tea: TEA, filePath: String) -> Bool {
        
        guard filePath.createDirectoryFromFilePath() else { return false }
        
        var data = JSONFormatData()
        
        data = tea.encrypt(data)
        
        do {
            
            try data.write(to: URL.init(fileURLWithPath: filePath))
            
            return true
            
        } catch  {
            
            CCPrint.error(error)
            
            return false
        }
    }
}
*/

import CryptoSwift

// MARK: - 存储（AES）

public extension JSONValue {
        
    /**
     磁盘
     
     - parameter    aes:        TEA密钥
     - parameter    filePath:   文件路径
     
     - returns: JSONValue
     */
    static func diskAES(_ aes: AES, filePath: String) -> JSONValue {
        
        do {
            
            let diskData = try Data.init(contentsOf: URL.init(fileURLWithPath: filePath))
            
            guard let data = aes.decrypt(diskData) else { return JSONValue() }
            
            return data.json
            
        } catch {
            
            CCPrint.error(error)
            
            return JSONValue()
        }
    }
    
    /**
     保存
     
     - parameter    aes:        AES密钥
     - parameter    filePath:   文件路径
     
     - returns: Bool    是否成功
     */
    @discardableResult func saveAES(_ aes: AES, filePath: String) -> Bool {
        
        guard filePath.createDirectoryFromFilePath() else { return false }
        
        guard let data = aes.encrypt(JSONFormatData()) else { return false }
        
        do {
            
            try data.write(to: URL.init(fileURLWithPath: filePath))
            
            return true
            
        } catch  {
            
            CCPrint.error(error)
            
            return false
        }
    }
}
