//
//  FileManager.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation

// MARK: - 删除

public extension FileManager {
    
    /**
     删除文件/文件夹
     
     - parameter    path:       路径
     */
    func remove(_ path: String) {
        
        do {
            try removeItem(atPath: path)
        } catch  {
            
        }
    }
    
    /**
     删除文件夹下的文件夹和文件
     
     - parameter    path:       路径
     */
    func removeDirectoryFile(_ path: String) {
        
        if let fileArray = subpaths(atPath: path) {
            
            var folder = path
            
            if folder.last != "/" {
                
                folder.append("/")
            }
            
            for file in fileArray {
                
                do {
                    try removeItem(atPath: folder + file)
                } catch  {
                    
                }
            }
        }
    }
}

// MARK: - 大小

public extension FileManager {
    
    /**
     文件夹(包含文件夹下的文件)大小
     
     - parameter    path:       路径
     - parameter    isIgnore:   是否忽略本身文件夹
     
     - returns: Int
     */
    func directorySize(_ path: String, isIgnore: Bool = true) -> Int {
        
        if let fileArray = subpaths(atPath: path) {
            
            var folder = path
            
            if folder.last != "/" {
                
                folder.append("/")
            }
            
            var size = isIgnore ? 0 : fileSize(folder)
            
            for file in fileArray {
                
                size += fileSize(folder + file)
            }
            
            return size
        }
        else {
            
            return 0
        }
    }
    
    /**
     文件大小
     
     - parameter    path:       路径
     
     - returns: Int
     */
    func fileSize(_ path: String) -> Int {
        
        do {
            
            let fileAttributes = try attributesOfItem(atPath: path)
            let size = fileAttributes[FileAttributeKey.size]
            
            return (size  as AnyObject).integerValue
            
        } catch  {
            
            return 0
        }
    }
}

// MARK: - 应用文件夹路径

public extension FileManager {
    
    /// 文件资料路径
    static let documentsPath = NSHomeDirectory() + "/Documents/"
    /// 库路径
    static let libraryPath = NSHomeDirectory() + "/Library/"
    /// 缓存路径
    static let tmpPath = NSHomeDirectory() + "/tmp/"
    /// 系统数据路径
    static let systemDataPath = NSHomeDirectory() + "/SystemData/"
}
