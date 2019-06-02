//
//  Timer.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation

// MARK: - 闭包模式

public extension Timer {
    
    /**
     时间器
     
     - parameter    timeInterval:   时间间隔
     - parameter    repeats:        是否重复
     - parameter    block:          执行代码
     */
    class func timeInterval(_ timeInterval: TimeInterval, repeats: Bool = true, block: @escaping (Timer) -> Void) {
        
        _ = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(event(_:)), userInfo: block, repeats: repeats)
    }
    
    
    /**
     事件调用代码
     */
    @objc class func event(_ timer: Timer) {
        
        let block = timer.userInfo! as! (Timer) -> Void
        
        block(timer)
    }
}
