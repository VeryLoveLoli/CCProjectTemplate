//
//  JSONValue.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import JSONValue
import TEA

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
            
            #if DEBUG
            print(error)
            #endif
            
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
    func save(_ filePath: String, isPrettyPrinted: Bool = false, level: String = "") -> Bool {
        
        let data = self.JSONFormatData()
        
        do {
            
            try data.write(to: URL.init(fileURLWithPath: filePath))
            
            return true
            
        } catch  {
            
            #if DEBUG
            print(error)
            #endif
            
            return false
        }
    }
}

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
                
                #if DEBUG
                print("error: \(filePath) not tea file")
                #endif
                
                return JSONValue()
            }
            
        } catch {
            
            #if DEBUG
            print(error)
            #endif
            
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
        
        var data = self.JSONFormatData()
        
        data = tea.encrypt(data)
        
        do {
            
            try data.write(to: URL.init(fileURLWithPath: filePath))
            
            return true
            
        } catch  {
            
            #if DEBUG
            print(error)
            #endif
            
            return false
        }
    }
}
