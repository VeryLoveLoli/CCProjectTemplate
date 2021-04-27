//
//  CCWebJSViewController.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import Social
import Prompt

/**
 CC网页JS交互视图控制器
 */
open class CCWebJSViewController: CCWebViewController, WKScriptMessageHandler {
    
    // MARK: - WKScriptMessageHandler
    
    /**
     JS消息
     */
    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        scriptMessageHandler(message)
    }
    
    // MARK: - Event
    
    /**
     初始化网页视图
     */
    open override func initWebView() -> WKWebView {
        
        let preferences = WKPreferences.init()
        preferences.javaScriptEnabled = true
        
        let configuration = WKWebViewConfiguration.init()
        configuration.preferences = preferences
        
        /**
         添加接收JS消息
         
         JS发送消息
         
         try {
         window.webkit.messageHandlers.<方法名称>.postMessage(<消息内容>)
         } catch (error) {
         console.log('WKWebView post message ' + error)
         }
         
         <方法名> name
         <消息内容> NSNumber, NSString, NSDate, NSArray, NSDictionary, NSNull
         
         例如以下设置 name = CCScriptMessagetHandler
         configuration.userContentController.add(CCScriptMessagetHandler.init(self), name: "CCScriptMessagetHandler")
         则JS发消息为
         window.webkit.messageHandlers.CCScriptMessagetHandler.postMessage(<消息内容>)
         */
        
        let handler = CCScriptMessageHandler.init(self)
        
        for item in scriptMessageHandlerNames() {
            
            configuration.userContentController.add(handler, name: item)
        }
        
        /*
         /// 添加JS代码  source: JS代码；injectionTime: 添加时间atDocumentStart(在文档开始)/atDocumentEnd(在文档结束)；forMainFrameOnly: 是否仅限于主框架；
         configuration.userContentController.addUserScript(WKUserScript.init(source: "", injectionTime: .atDocumentEnd, forMainFrameOnly: true)))
         */
        
        let webView = WKWebView.init(frame: view.bounds, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        return webView
    }
    
    /**
     JS调用原生方法名称列表
     */
    open func scriptMessageHandlerNames() -> [String] {
        
        return ["CCScriptMessageHandler"]
    }
    
    /**
     JS消息
     
     - parameter    message:    消息
     */
    open func scriptMessageHandler(_ message: WKScriptMessage) {
        
        CCPrint.debug(message)
        CCPrint.debug(message.body)
    }
    
    // MARK: - deinit
    
    deinit {
        
        
        for item in scriptMessageHandlerNames() {
            
            webView.configuration.userContentController.removeScriptMessageHandler(forName: item)
        }
    }
}
