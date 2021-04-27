//
//  CCScriptMessageHandler.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import Social

/**
 CCJS消息处理
 */
class CCScriptMessageHandler: NSObject, WKScriptMessageHandler {
    
    weak var delegate: WKScriptMessageHandler?
    
    init(_ delegate: WKScriptMessageHandler) {
        
        self.delegate = delegate
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        delegate?.userContentController(userContentController, didReceive: message)
    }
    
    deinit {
        
        delegate = nil
        
        CCPrint.debug("deinit: \(self)")
    }
}
