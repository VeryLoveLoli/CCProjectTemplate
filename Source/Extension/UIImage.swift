//
//  UIImage.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/5.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 图片

public extension UIImage {
    
    /**
     获取颜色图片
     
     - parameter    color:      颜色
     
     - returns: UIImage
     */
    class func color(_ color: UIColor) -> UIImage {
        
        let rect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    /**
     获取视图图片
     
     - parameter    view:       视图
     
     - returns: UIImage
     */
    class func view(_ view: UIView) -> UIImage {
        
        return layer(view.layer)
    }
    
    /**
     获取图层图片
     
     - parameter    layer:      图层
     
     - returns: UIImage
     */
    class func layer(_ layer: CALayer) -> UIImage {
        
        let size = layer.bounds.size
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    /**
     获取透明度图片
     
     - parameter    value:      透明值
     
     - returns: UIImage
     */
    func alpha(_ value: CGFloat) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()!
        
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -size.height)
        context.setBlendMode(CGBlendMode.multiply)
        context.setAlpha(value)
        context.draw(cgImage!, in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    /**
     重新绘制图片
     
     - parameter    value:      图片大小比率
     
     - returns: 图片
     */
    func redraw(_ value: CGFloat) -> UIImage {
        
        return redraw(CGSize.init(width: size.width * value, height: size.height * value))
    }
    
    /**
     重新绘制图片
     
     - parameter    size:       图片大小
     
     - returns: UIImage
     */
    func redraw(_ size: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        self.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext();
        
        return image;
    }
    
    /**
     裁剪图片
     
     - parameter    rect:       裁剪区域
     
     - returns: UIImage
     */
    func clip(_ rect: CGRect) -> UIImage {
        
        let scale = UIScreen.main.scale
        
        let scaleRect = CGRect.init(x: rect.origin.x * scale,
                                    y: rect.origin.y * scale,
                                    width: rect.size.width * scale,
                                    height: rect.size.height * scale)
        
        
        let image = UIImage.init(cgImage: cgImage!.cropping(to: scaleRect)!, scale: UIScreen.main.scale, orientation: .up)
        
        return image
    }
}

// MARK: - 颜色值

public extension UIImage {
    
    /**
     获取图片中的像素颜色
     
     - parameter    point:      图片中的位置
     
     - returns: UIColor
     */
    func pixelColor(_ point: CGPoint) -> UIColor {
        
        let (r, g, b, a) = pixelColorValue(point)
        
        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a)/255.0)
    }
    
    
    /**
     获取图片中的像素颜色值
     
     - parameter    point:      图片中的位置
     
     - returns: (R,G,B,A)
     */
    func pixelColorValue(_ point: CGPoint) -> (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        
        let pixelData = self.cgImage!.dataProvider!.data
        
        let data:UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(point.y)) + Int(point.x)) * 4
        
        return (data[pixelInfo], data[pixelInfo+1], data[pixelInfo+2], data[pixelInfo+3])
    }
}

// MARK: - 存储

extension UIImage {
    
    /**
     保存图片
     
     - parameter    filePath:   文件路径
     */
    func save(_ filePath: String) -> Bool {
        
        var jp = pngData()
        
        if jp == nil {
            
            jp = jpegData(compressionQuality: 1)
        }
        
        if let data = jp {
            
            do {
                
                try data.write(to: URL.init(fileURLWithPath: filePath))
                
                return true
                
            } catch {
                
                #if DEBUG
                print(error)
                #endif
                
                return false
            }
        }
        else {
            
            return false
        }
    }
    
    /**
     获取磁盘图片
     
     - parameter    filePath:   文件路径
     */
    static func disk(_ filePath: String) -> UIImage? {
        
        do {
            
            let data = try Data.init(contentsOf: URL.init(fileURLWithPath: filePath))
            
            return UIImage.init(data: data)
            
        } catch {
            
            return nil
        }
    }
}
