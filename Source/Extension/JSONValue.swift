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
    
    /// TEA
    static var tea = TEA.init(5, key: (1219719899,2901921256, 3018872983, 3069152560))
    
    /**
     磁盘
     
     - parameter    filePath:   文件路径
     - parameter    tea:        是否TEA加密
     
     - returns: JSONValue
     */
    static func disk(_ filePath: String, tea: TEA? = JSONValue.tea) -> JSONValue {
        
        do {
            
            var data = try Data.init(contentsOf: URL.init(fileURLWithPath: filePath))
            
            if let teaData = tea?.decrypt(data) {
                
                data = teaData
                
                /// 清除末尾多余'\0'
                for _ in 0..<data.count {
                    
                    if data[data.count-1] == 0 {
                        
                        data.remove(at: data.count-1)
                    }
                    else {
                        
                        break
                    }
                }
            }
            
            if data.count == 0 {
                
                return JSONValue()
            }
            else {
                
                return data.json
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
     
     - parameter    filePath:   文件路径
     - parameter    tea:        是否TEA加密
     
     - returns: Bool    是否成功
     */
    func save(_ filePath: String, tea: TEA? = JSONValue.tea) -> Bool {
        
        var data = self.JSONFormatData()
        
        if let teaData = tea?.encrypt(data) {
            
            data = teaData
        }
        
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
