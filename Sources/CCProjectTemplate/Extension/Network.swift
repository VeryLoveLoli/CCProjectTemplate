//
//  File.swift
//  
//
//  Created by 韦烽传 on 2020/12/2.
//

import Foundation
import Network
import JSONValue
import CryptoSwift

// MARK: - 请求、解析

public extension Network {
    
    /**
     请求方式
     */
    enum HTTPMethod {
        
        case POST, GET
        
        public var value: String {
            
            switch self {
                
            case .POST:
                return "POST"
            case .GET:
                return "GET"
            }
        }
    }

    /**
     加解密序列类型
     */
    enum EDST{
        
        /// 无
        case none
        /// AES
        case aes(value: AES)
        /// Base64
        case base
    }
    
    /**
     解析类型
     */
    enum Analysis {
        
        /// 无
        case none
        /// JSON
        case json
    }
    
    /**
     请求
     
     - parameter     host:              主机
     - parameter     path:              路径
     - parameter     parameters:        参数
     - parameter     method:            请求类型
     - parameter     uniqueKey:         唯一标识Key
     - parameter     signatureKey:      签名Key
     - parameter     encryptionDEST:    加密序列
     */
    class func request(_ host: String, path: String, parameters: JSONValue, method: HTTPMethod, uniqueKey: String, signatureKey: String, encryptionDEST: [EDST]) -> URLRequest {
        
        var request = URLRequest.init(url: URL.init(string: host + path)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 30)
        
        var bodyString = ""
        
        var keys = parameters.dictionary.keys.sorted()
        
        for key in keys {
            
            if bodyString.count > 0 {
                
                bodyString = bodyString + "&"
            }
            
            let value = parameters[key].number.string
            
            bodyString = bodyString + key + "=" + value
        }
        
        request.httpMethod = method.value
        
        /// 时间戳
        let timestamp = CLongLong(Date.init().timeIntervalSince1970)
        /// 随机数
        let nonce = arc4random()
        /// 唯一标识
        let unique = ("\(timestamp)" + "\(nonce)" + uniqueKey).sha256()
        
        request.addValue("\(timestamp)", forHTTPHeaderField: "timestamp")
        request.addValue("\(nonce)", forHTTPHeaderField: "nonce")
        request.addValue(unique, forHTTPHeaderField: "unique")
        
        if keys.count > 0 {
            
            keys.sort { (item_i, item_j) -> Bool in
                
                return item_i.uppercased() < item_j.uppercased()
            }
            
            var signatureContent = ""
            
            for key in keys {
                
                let value = parameters[key].number.string
                
                signatureContent += key.uppercased()
                signatureContent += value.uppercased()
            }
            
            var signature = signatureContent.sha256()
            signature = (signature + signatureKey).sha256()
            
            bodyString += "&signature=" + signature
        }
        
        switch method {
            
        case .GET:
            request.url = URL.init(string: host + path + "?" + bodyString)!
            
        case .POST:
            
            var data = bodyString.data(using: .utf8)
            
            for dest in encryptionDEST {
                
                switch dest {
                    
                case .aes(let key):
                    
                    if let d = data {
                        
                        data = key.encrypt(d)
                    }
                    
                case .base:
                    data = data?.base64EncodedData()
                    
                case .none:
                    break
                }
            }
            
            request.httpBody = data
        }
        
        return request
    }
    
    /**
     响应数据数据解析
     
     - parameter     data:                  响应数据数据
     - parameter     decryptionDEST:        解密序列
     - parameter     analysis:              解析类型
     */
    class func responseAnalysis(_ data: Data?, decryptionDEST: [EDST], analysis: Analysis) -> JSONValue {
        
        var json = JSONValue()
        
        var destData = data
        
        for dest in decryptionDEST {
            
            switch dest {
                
            case .none:
                break
                
            case .aes(let key):
                
                if let d = destData {
                    
                    destData = key.decrypt(d)
                }
                                
            case .base:
                
                if let d = destData {
                    
                    destData = Data.init(base64Encoded: d)
                }
            }
        }
        
        switch analysis {
            
        case .none:
            
            json = JSONValue(destData)
            
        case .json:
            
            json = JSONValue(destData)
        }
        
        return json
    }
}
