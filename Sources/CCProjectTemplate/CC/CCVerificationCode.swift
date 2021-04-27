//
//  CCVerificationCode.swift
//  
//
//  Created by 韦烽传 on 2021/3/31.
//

import Foundation
import UIKit

/**
 CC验证码
 */
open class CCVerificationCode: UIView {
    
    // MARK: - Parameter
    
    /// 字符集
    open var characters = "1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM"
    /// 字符数
    open var number = 6
    /// 干扰线数
    open var lineNumber = 8
    /// 字体变化大小
    open var fontChange: UInt32 = 8
    /// 线宽变化大小（像素）
    open var lineWidthChange: UInt32 = 6
    /// 验证码
    open private(set) var code = ""
    /// 是否点击刷新
    open var isTouchUpload = false
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        upload()
    }
    
    // MARK: - Touch
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if isTouchUpload {
            
            upload()
        }
    }
    
    // MARK: - Event
    
    /**
     更新
     */
    open func upload() {
        
        if characters.count == 0 {
            
            CCPrint.debug("characters.count == 0")
            return
        }
        
        code = ""
        
        for _ in 0..<number {
            
            code += characters[Int(arc4random()%UInt32(characters.count))]
        }
        
        backgroundColor = UIColor.hex(arc4random() | 0xff)
        
        setNeedsDisplay()
    }
    
    // MARK: - Draw
    
    /**
     绘制
     */
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        /// 每个字符的宽度位置
        let width = rect.width/CGFloat(number)
        /// 每个字符的高度位置
        let height = rect.height
        /// 最大字体大小
        let maxFontSize = min(width, height) - 3
        /// 字符开始点位置
        var point = CGPoint.zero
        
        for i in 0..<code.count {
            
            /// 字符
            let c = code[i] as NSString
            
            /// 权重
            var weight = UIFont.Weight.regular
            
            /// 随机权重
            switch arc4random()%9 {
            case 0:
                weight = .black
            case 1:
                weight = .bold
            case 2:
                weight = .heavy
            case 3:
                weight = .light
            case 4:
                weight = .medium
            case 5:
                weight = .regular
            case 6:
                weight = .semibold
            case 7:
                weight = .thin
            case 8:
                weight = .ultraLight
            default:
                weight = UIFont.Weight.regular
            }
            
            /// 字体
            var font = UIFont.systemFont(ofSize: maxFontSize - CGFloat(arc4random()%fontChange), weight: weight)
            
            /// 随机斜体
            if arc4random()%3 == 0 {
                
                font = UIFont.italicSystemFont(ofSize: font.pointSize)
            }
            
            /// 字符大小
            let size = c.boundingRect(with: CGSize(width: 1000, height: 1000), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil)
            
            point.x = CGFloat(arc4random()%UInt32(width - size.width)) + width*CGFloat(i)
            point.y = CGFloat(arc4random()%UInt32(height - size.height))
            
            /// 字符绘制
            c.draw(at: point, withAttributes: [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor : UIColor.black])
        }
        
        if let context = UIGraphicsGetCurrentContext() {
            
            for _ in 0..<lineNumber {
                
                /// 线颜色
                context.setStrokeColor(UIColor.hex(arc4random() | 0xff).cgColor)
                /// 线宽
                context.setLineWidth(CGFloat(arc4random()%lineWidthChange + 1)/UIScreen.main.scale)
                
                /// 线开始点
                context.move(to: CGPoint(x: CGFloat(arc4random()%UInt32(rect.width)), y: CGFloat(arc4random()%UInt32(rect.height))))
                /// 线结束点
                context.addLine(to: CGPoint(x: CGFloat(arc4random()%UInt32(rect.width)), y: CGFloat(arc4random()%UInt32(rect.height))))
                
                /// 线绘制
                context.strokePath()
            }
        }
    }
}
