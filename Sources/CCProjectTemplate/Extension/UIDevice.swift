//
//  UIDevice.swift
//  
//
//  Created by 韦烽传 on 2021/3/17.
//

import Foundation
import UIKit

// MARK: - 设备名称

public extension UIDevice {
    
    /**
     设备名称
     */
    static func modelName() -> String {
        
        var systemInfo = utsname()
        
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        
        let identifier = machineMirror.children.reduce("") { identifier, element in
          
          guard let value = element.value as? Int8, value != 0 else { return identifier }
          
          return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
          
        case "iPhone1,1":           return "iPhone 1G"
        case "iPhone1,2":           return "iPhone 3G"
        case "iPhone2,1":           return "iPhone 3GS"
        case "iPhone3,1":           return "iPhone 4"
        case "iPhone3,2":           return "iPhone 4"
        case "iPhone3,3":           return "iPhone 4"
        case "iPhone4,1":           return "iPhone 4s"
        case "iPhone5,1":           return "iPhone 5"
        case "iPhone5,2":           return "iPhone 5 (GSM+CDMA)"
        case "iPhone5,3":           return "iPhone 5c (GSM)"
        case "iPhone5,4":           return "iPhone 5c (GSM+CDMA)"
        case "iPhone6,1":           return "iPhone 5s (GSM)"
        case "iPhone6,2":           return "iPhone 5s (GSM+CDMA)"
        case "iPhone7,1":           return "iPhone 6 Plus"
        case "iPhone7,2":           return "iPhone 6"
        case "iPhone8,1":           return "iPhone 6s"
        case "iPhone8,2":           return "iPhone 6s Plus"
        case "iPhone8,4":           return "iPhone SE"
        case "iPhone9,1":           return "iPhone 7 (CDMA)"
        case "iPhone9,2":           return "iPhone 7 Plus (CDMA)"
        case "iPhone9,3":           return "iPhone 7 (GSM)"
        case "iPhone9,4":           return "iPhone 7 Plus (GSM)"
        case "iPhone10,1":          return "iPhone 8" // 国行(A1863)、日行(A1906)
        case "iPhone10,2":          return "iPhone 8 Plus" // 国行(A1864)、日行(A1898)
        case "iPhone10,3":          return "iPhone X" // 国行(A1865)、日行(A1902)
        case "iPhone10,4":          return "iPhone 8" // 美版(Global/A1905)
        case "iPhone10,5":          return "iPhone 8 Plus" // 美版(Global/A1897)
        case "iPhone10,6":          return "iPhone X" // 美版(Global/A1901)
        case "iPhone11,2":          return "iPhone XS"
        case "iPhone11,4":          return "iPhone XS Max"
        case "iPhone11,6":          return "iPhone XS Max"
        case "iPhone11,8":          return "iPhone XR"
        case "iPhone12,1":          return "iPhone 11"
        case "iPhone12,3":          return "iPhone 11 Pro"
        case "iPhone12,5":          return "iPhone 11 Pro Max"
        case "iPhone12,8":          return "iPhone SE 2"
        case "iPhone13,1":          return "iPhone 12 mini"
        case "iPhone13,2":          return "iPhone 12"
        case "iPhone13,3":          return "iPhone 12 Pro"
        case "iPhone13,4":          return "iPhone 12 Pro Max"
          
        case "iPod1,1":             return "iPod Touch 1G"
        case "iPod2,1":             return "iPod Touch 2G"
        case "iPod3,1":             return "iPod Touch 3G"
        case "iPod4,1":             return "iPod Touch 4G"
        case "iPod5,1":             return "iPod Touch 5"
        case "iPod7,1":             return "iPod Touch 6"
          
        case "iPad1,1":             return "iPad"
        case "iPad1,2":             return "iPad 3G"
        case "iPad2,1":             return "iPad 2 (WiFi)"
        case "iPad2,2":             return "iPad 2"
        case "iPad2,3":             return "iPad 2 (CDMA)"
        case "iPad2,4":             return "iPad 2"
        case "iPad2,5":             return "iPad 2 Mini (WiFi)"
        case "iPad2,6":             return "iPad 2 Mini"
        case "iPad2,7":             return "iPad 2 Mini (GSM+CDMA)"
        case "iPad3,1":             return "iPad 3 (WiFi)"
        case "iPad3,2":             return "iPad 3 (GSM+CDMA)"
        case "iPad3,3":             return "iPad 3"
        case "iPad3,4":             return "iPad 4 (WiFi)"
        case "iPad3,5":             return "iPad 4"
        case "iPad3,6":             return "iPad 4 (GSM+CDMA)"
        case "iPad4,1":             return "iPad Air (WiFi)"
        case "iPad4,2":             return "iPad Air (Cellular)"
        case "iPad4,3":             return "iPad Air"
        case "iPad4,4":             return "iPad Mini 2 (WiFi)"
        case "iPad4,5":             return "iPad Mini 2 (Cellular)"
        case "iPad4,6":             return "iPad Mini 2"
        case "iPad4,7":             return "iPad Mini 3"
        case "iPad4,8":             return "iPad Mini 3"
        case "iPad4,9":             return "iPad Mini 3"
        case "iPad5,1":             return "iPad Mini 4 (WiFi)"
        case "iPad5,2":             return "iPad Mini 4 (LTE)"
        case "iPad6,3":             return "iPad Pro 9.7"
        case "iPad6,4":             return "iPad Pro 9.7"
        case "iPad6,7":             return "iPad Pro 12.9"
        case "iPad6,8":             return "iPad Pro 12.9"
        case "iPad6,11":            return "iPad 5 (WiFi)"
        case "iPad6,12":            return "iPad 5 (Cellular)"
        case "iPad7,1":             return "iPad Pro 12.9 inch 2nd gen (WiFi)"
        case "iPad7,2":             return "iPad Pro 12.9 inch 2nd gen (Cellular)"
        case "iPad7,3":             return "iPad Pro 10.5 inch (WiFi)"
        case "iPad7,4":             return "iPad Pro 10.5 inch (Cellular)"
        case "iPad7,5":             return "iPad 6th generation"
        case "iPad7,6":             return "iPad 6th generation"
        case "iPad8,1":             return "iPad Pro (11-inch)"
        case "iPad8,2":             return "iPad Pro (11-inch)"
        case "iPad8,3":             return "iPad Pro (11-inch)"
        case "iPad8,4":             return "iPad Pro (11-inch)"
        case "iPad8,5":             return "iPad Pro (12.9-inch) (3rd generation)"
        case "iPad8,6":             return "iPad Pro (12.9-inch) (3rd generation)"
        case "iPad8,7":             return "iPad Pro (12.9-inch) (3rd generation)"
        case "iPad8,8":             return "iPad Pro (12.9-inch) (3rd generation)"
            
        case "AppleTV2,1":          return "Apple TV 2"
        case "AppleTV3,1":          return "Apple TV 3"
        case "AppleTV3,2":          return "Apple TV 4"
        case "AppleTV5,3":          return "Apple TV 5"
            
        case "i386":                return "Simulator"
        case "x86_64":              return "Simulator"
          
        default:                    return identifier
          
        }
    }
}
