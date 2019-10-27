//
//  AES.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/10/27.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import CryptoSwift
import CryptoKit
// MARK: - AES

public extension AES {
    
    /// 位数
    enum BitSize: Int {
        /// 128位
        case aes128 = 16
        /// 192位
        case ase192 = 24
        /// 256位
        case ase256 = 32
    }
    
    /**
    初始化（处理密钥位数引起的错误）
    
    - parameter    key:        密钥
    - parameter    bitSize:    位数
    - parameter    blockMode:  模式
    - parameter    padding:    补位类型
    */
    convenience init(_ key: String, bitSize: BitSize = .aes128, blockMode: BlockMode = ECB(), padding: Padding = .pkcs5) {
        
        var keyBytes = [UInt8](key.data(using: .ascii) ?? Data())
        
        if keyBytes.count < bitSize.rawValue {
            
            keyBytes += [UInt8].init(repeating: 0, count: bitSize.rawValue - keyBytes.count)
        }
        else if keyBytes.count > bitSize.rawValue {
            
            keyBytes = [UInt8](keyBytes[0..<bitSize.rawValue])
        }
        
        try! self.init(key: keyBytes, blockMode: blockMode, padding: padding)
    }
    
    /**
     加密
     
     - parameter    data:   数据
     
     - returns: 加密数据
     */
    func encrypt(_ data: Data) -> Data? {
        
        do {
            
            let bytes = try encrypt([UInt8](data))
            
            return Data.init(bytes: bytes, count: bytes.count)
            
        } catch {
            
            #if DEBUG
            print(error)
            #endif
            
            return nil
        }
    }
    
    /**
     解密
     
     - parameter    data:   数据
     
     - returns: 解密数据
     */
    func decrypt(_ data: Data) -> Data? {
        
        do {
            
            let bytes = try decrypt([UInt8](data))
            
            return Data.init(bytes: bytes, count: bytes.count)
            
        } catch {
            
            #if DEBUG
            print(error)
            #endif
            
            return nil
        }
    }
}
