//
//  Prompt.swift
//  PromptTest
//
//  Created by 韦烽传 on 2019/4/27.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit

/**
 提示
 */
public class Prompt {
    
    /// 背景
    public let background = UIView.init()
    /// 内容
    public let content = UIView.init()
    /// 提示文本
    public let title = UILabel.init()
    /// 指示器
    public let activity = UIActivityIndicatorView.init(style: .white)
    /// GIF
    public let gif = UIImageView.init()
    
    public init() {
        
        background.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        gif.backgroundColor = UIColor.clear
        
        content.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        content.layer.cornerRadius = 8
        content.layer.masksToBounds = true
        
        title.backgroundColor = UIColor.clear
        title.font = UIFont.systemFont(ofSize: 14)
        title.textAlignment = .center
        title.textColor = UIColor.white
        title.numberOfLines = 0
        
        content.addSubview(title)
        content.addSubview(activity)
    }
    
    /**
     文字提示
     
     - parameter    title:          文字
     - parameter    milliseconds:   显示时间
     - parameter    isBackground:   是否显示背景（用于阻止用户点击）
     - parameter    sup:            添加到的视图
     - parameter    location:       在视图中的位置
     */
    public static func title(_ title: String, milliseconds: Int, isBackground: Bool, sup: UIView, location: CGPoint) {
        
        DispatchQueue.main.async {
            
            let prompt = Prompt.init()
            prompt.activity.isHidden = true
            prompt.title.text = title
            prompt.background.isHidden = !isBackground
            prompt.background.frame = CGRect.init(origin: CGPoint.init(), size: sup.frame.size)
            
            let rect = title.boundingRect(with: CGSize.init(width: 0.8 * sup.frame.size.width, height: 0.8 * sup.frame.size.height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: prompt.title.font!], context: nil)
            
            prompt.title.frame = rect
            prompt.content.frame = CGRect.init(x: 0, y: 0, width: rect.size.width + 40, height: rect.size.height + 40)
            
            prompt.title.center = prompt.content.center
            prompt.content.center = location
            
            sup.addSubview(prompt.background)
            sup.addSubview(prompt.content)
            
            prompt.background.alpha = 0
            prompt.content.alpha = 0
            prompt.content.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            
            UIView.animate(withDuration: 0.25, animations: {
                
                prompt.background.alpha = 1
                prompt.content.alpha = 1
                prompt.content.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(milliseconds)) {
                
                prompt.close()
            }
        }
    }
    
    /**
     加载提示
     
     - parameter    title:          文字
     - parameter    timeInterval:   动态显示的文字时间间隔
     - parameter    repeats:        动态显示的文字个数（<=title.count，从后往前算）
     - parameter    isBackground:   是否显示背景（用于阻止用户点击）
     - parameter    sup:            添加到的视图
     - parameter    location:       在视图中的位置
     */
    public static func load(_ title: String, timeInterval: TimeInterval, repeats: Int, isBackground: Bool, sup: UIView, location: CGPoint) -> Prompt {
        
        let prompt = Prompt.init()
        
        DispatchQueue.main.async {
            
            prompt.activity.startAnimating()
            prompt.title.text = title
            prompt.background.isHidden = !isBackground
            prompt.background.frame = CGRect.init(origin: CGPoint.init(), size: sup.frame.size)
            
            if !title.isEmpty {
                
                let rect = title.boundingRect(with: CGSize.init(width: 0.8 * sup.frame.size.width, height: 0.8 * sup.frame.size.height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: prompt.title.font!], context: nil)
                prompt.title.frame = rect
                prompt.content.frame = CGRect.init(x: 0, y: 0, width: rect.size.width + 40, height: rect.size.height + 40 + prompt.activity.frame.size.height + 12)
                prompt.title.center = CGPoint.init(x: prompt.content.center.x, y: prompt.content.center.y + prompt.activity.frame.size.height/2 + 6)
                prompt.activity.center = CGPoint.init(x: prompt.content.center.x, y: prompt.content.center.y - prompt.title.frame.size.height/2 - 6)
            }
            else {
                
                prompt.content.frame = CGRect.init(x: 0, y: 0, width: prompt.activity.frame.size.width + 40, height: prompt.activity.frame.size.height + 40)
                prompt.activity.center = prompt.content.center
            }
            
            prompt.content.center = location
            
            sup.addSubview(prompt.background)
            sup.addSubview(prompt.content)
            
            prompt.background.alpha = 0
            prompt.content.alpha = 0
            prompt.content.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            
            UIView.animate(withDuration: 0.25, animations: {
                
                prompt.background.alpha = 1
                prompt.content.alpha = 1
                prompt.content.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            })
            
            if title.count >= repeats && repeats > 0 {
                
                var i = repeats
                
                let timer = Timer.init(timeInterval: timeInterval, repeats: true, block: { (timer) in
                    
                    let start = title.index(title.startIndex, offsetBy: 0)
                    let end = title.index(title.endIndex, offsetBy: -i)
                    
                    prompt.title.text = String.init(title[start..<end])
                    
                    i -= 1
                    
                    if i < 0 {
                        
                        i = repeats
                    }
                    
                    if prompt.content.superview == nil && timer.isValid {
                        
                        timer.invalidate()
                    }
                })
                
                RunLoop.current.add(timer, forMode: .default)
            }
        }
        
        return prompt
    }
    
    /**
     GIF提示
     
     - parameter    data:           GIF数据
     - parameter    isBackground:   是否显示背景（用于阻止用户点击）
     - parameter    sup:            添加到的视图
     - parameter    location:       在视图中的位置
     */
    public static func gif(_ data: Data, isBackground: Bool, sup: UIView, location: CGPoint) -> Prompt {
        
        let prompt = Prompt.init()
        
        DispatchQueue.main.async {
            
            prompt.activity.isHidden = true
            prompt.title.isHidden = true
            prompt.content.isHidden = true
            prompt.background.isHidden = !isBackground
            prompt.background.frame = CGRect.init(origin: CGPoint.init(), size: sup.frame.size)
            
            prompt.gif.gif(data)
            
            if let image = prompt.gif.image {
                
                prompt.gif.frame = CGRect.init(origin: CGPoint.init(), size: image.size)
            }
            
            prompt.gif.center = location
            
            sup.addSubview(prompt.background)
            sup.addSubview(prompt.gif)
            
            prompt.background.alpha = 0
            prompt.gif.alpha = 0
            prompt.gif.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            
            UIView.animate(withDuration: 0.25, animations: {
                
                prompt.background.alpha = 1
                prompt.gif.alpha = 1
                prompt.gif.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            })
        }
        
        return prompt
    }
    
    /**
     关闭
     */
    public func close() {
        
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.background.alpha = 0
                self.content.alpha = 0
                self.content.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                self.gif.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                
            }) { (bool) in
                
                self.activity.stopAnimating()
                self.background.removeFromSuperview()
                self.content.removeFromSuperview()
                self.gif.removeFromSuperview()
            }
        }
    }
}

fileprivate extension UIImageView {
    
    /**
     GIF
     
     - parameter    data:   GIF数据
     */
    func gif(_ data: Data) {
        
        /// 获取图片资源
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            
            return
        }
        
        /// 获取图片数量
        let count = CGImageSourceGetCount(source)
        
        var images: [UIImage] = []
        var duration: TimeInterval = 0
        
        for i in 0..<count {
            
            /// 获取图片
            guard let cgimage = CGImageSourceCreateImageAtIndex(source, i, nil) else {
                
                continue
            }
            
            let image = UIImage.init(cgImage: cgimage)
            
            images.append(image)
            
            /// 获取时间
            guard let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) else {
                
                continue
            }
            
            guard let gifDict = (properties as Dictionary)[kCGImagePropertyGIFDictionary] else {
                
                continue
            }
            
            guard let time = (gifDict as? Dictionary<CFString, Any>)?[kCGImagePropertyGIFDelayTime] else {
                
                continue
            }
            
            duration += (time as? TimeInterval) ?? 0
        }
        
        if images.count > 0 {
            
            self.image = images[0]
        }
        
        self.animationImages = images
        self.animationDuration = duration
        self.startAnimating()
    }
}

public extension Prompt {
    
    static func keyWindow() -> UIWindow? {
        
        if let window = UIApplication.shared.keyWindow {
            
            return window
        }
        else if UIApplication.shared.windows.count > 0 {
            
            return UIApplication.shared.windows[0]
        }
        else {
            
            return nil
        }
    }
    
    /**
     窗口文字提示
     
     - parameter    title:          文字
     - parameter    milliseconds:   显示时间
     - parameter    isBackground:   是否显示背景（用于阻止用户点击）
     */
    static func titleWindow(_ title: String, milliseconds: Int, isBackground: Bool) {
        
        if let window = keyWindow() {
            
            self.title(title, milliseconds: milliseconds, isBackground: isBackground, sup: window, location: window.center)
        }
    }
    
    /**
     窗口加载提示
     
     - parameter    title:          文字
     - parameter    timeInterval:   动态显示的文字时间间隔
     - parameter    repeats:        动态显示的文字个数（<=title.count，从后往前算）
     - parameter    isBackground:   是否显示背景（用于阻止用户点击）
     */
    static func loadWindow(_ title: String, timeInterval: TimeInterval, repeats: Int, isBackground: Bool) -> Prompt? {
        
        if let window = keyWindow() {
            
            return load(title, timeInterval: timeInterval, repeats: repeats, isBackground: isBackground, sup: window, location: window.center)
        }
        else {
            
            return nil
        }
    }
    
    /**
     窗口GIF提示
     
     - parameter    data:           GIF数据
     - parameter    isBackground:   是否显示背景（用于阻止用户点击）
     */
    static func gifWindow(_ data: Data, isBackground: Bool) -> Prompt? {
        
        if let window = keyWindow() {
            
            return gif(data, isBackground: isBackground, sup: window, location: window.center)
        }
        else {
            
            return nil
        }
    }
}
