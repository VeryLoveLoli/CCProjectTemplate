//
//  CCWebViewController.swift
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
 CC网页视图控制器
 */
open class CCWebViewController: CCViewController, WKUIDelegate, WKNavigationDelegate {
    
    /// 刷新图标
    public static var reloadImage = UIImage.CC_web_reload
        
    /// 地址
    open var urlString: String?
    /// 是否网页标题
    open var isWebTitle = false {
        
        didSet {
            
            if isWebTitle {
                
                webKVO("title")
            }
            else {
                
                removeWebKVO("title")
            }
        }
    }
    /// 加载
    open var loading: Prompt?
    /// 是否显示加载
    open var isShowLoading = true
    /// 是否显示错误
    open var isShowError = true
    /// 首个地址加载失败是否显示刷新
    open var isShowReloadInRootError = true
    /// 刷新图标
    open var reloadImage = CCWebViewController.reloadImage
    /// 刷新按钮
    open var reloadButton = UIButton.init(type: .custom)
    
    /// 网页视图
    open lazy var webView: WKWebView = {
        
        return initWebView()
    }()
    
    /// KVO 路径列表
    open var pathList: [String] = []
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        view.sendSubviewToBack(webView)
        webView.constraintForSuperview()
        
        reloadButton.setImage(reloadImage, for: .normal)
        reloadButton.setImage(reloadImage, for: .highlighted)
        reloadButton.setImage(reloadImage, for: .selected)
        reloadButton.addTarget(self, action: #selector(reload), for: .touchUpInside)
        reloadButton.isHidden = true
        view.addSubview(reloadButton)
        reloadButton.constraintForSuperview()
        
        if let urlString = urlString, let url = URL.init(string: urlString) {
            
            webView.load(URLRequest.init(url: url))
        }
    }
    
    // MARK: - WKUIDelegate
    
    // MARK: - WKNavigationDelegate
    
    /**
     网页拦截
     */
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    /**
     网页开始加载
     */
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        if isShowLoading {
            
            loading?.close()
            loading = nil
            loading = promptLoad()
        }
    }
    
    /**
     网页内容开始返回
     */
    open func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    /**
     网页加载完成
     */
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        loading?.close()
        loading = nil
    }
    
    /**
     网页加载失败
     */
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        loading?.close()
        loading = nil
        
        reloadButton.isHidden = false
        
        if isShowError {
            
            promptTitle(error.localizedDescription)
        }
    }
    
    /**
     网页加载失败
     */
    open func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        loading?.close()
        loading = nil
        
        if isShowReloadInRootError && webView.url == nil {
            
            reloadButton.isHidden = false
        }
        
        if isShowError {
            
            promptTitle(error.localizedDescription)
        }
    }
    
    // MARK: - Navigation Event
    
    /**
     返回事件
     */
    @IBAction open override func backEvent(_ sender: Any? = nil) {
        
        if webView.canGoBack {
            
            webView.goBack()
        }
        else {
            
            super.backEvent(sender)
        }
    }
    
    /**
     刷新标题
     */
    open func reloadWebViewTitle() {
        
        /// 调用JS
        webView.evaluateJavaScript("document.title") { (any, error) in
            
            if let value = any {
                
                switch value {
                case let string as String:
                    let title = self.title
                    let tabBarTitle = self.navigationController?.tabBarItem.title
                    self.title = string
                    if title != tabBarTitle {
                        self.navigationController?.tabBarItem.title = tabBarTitle
                    }
                default:
                    break
                }
            }
        }
    }
    
    // MARK: - KVO
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let web = object as? WKWebView, keyPath == "title" {
            
            title = web.title
        }
    }
    
    // MARK: - Event
    
    /**
     初始化网页视图
     */
    open func initWebView() -> WKWebView {
        
        let preferences = WKPreferences.init()
        
        let configuration = WKWebViewConfiguration.init()
        configuration.preferences = preferences
        
        let webView = WKWebView.init(frame: view?.bounds ?? .zero, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        return webView
    }
    
    /**
     刷新
     */
    @objc open func reload() {
        
        reloadButton.isHidden = true
        
        if webView.url == nil {
            
            if let urlString = urlString, let url = URL.init(string: urlString) {
                
                webView.load(URLRequest.init(url: url))
            }
        }
        else {
            
            webView.reload()
        }
    }
    
    /**
     侦听
     
     - parameter    key:    侦听路径
     */
    open func webKVO(_ key: String) {
        
        if !pathList.contains(key) {
            
            pathList.append(key)
            webView.addObserver(self, forKeyPath: key, options: .new, context: nil)
        }
    }
    
    /**
     删除Web侦听
     
     - parameter    key:    侦听路径
     */
    open func removeWebKVO(_ key: String) {
        
        if pathList.contains(key) {
            
            webView.removeObserver(self, forKeyPath: key)
        }
    }
    
    /**
     删除所有Web侦听
     */
    open func removeAllWebKVO() {
        
        for item in pathList {
            
            webView.removeObserver(self, forKeyPath: item)
        }
    }
    
    // MARK: - deinit
    
    deinit {
        
        webView.stopLoading()
        webView.uiDelegate = nil
        webView.navigationDelegate = nil
        webView.scrollView.delegate = nil
        webView.configuration.userContentController.removeAllUserScripts()
        
        if #available(iOS 11.0, *) {
            webView.configuration.userContentController.removeAllContentRuleLists()
        } else {
            // Fallback on earlier versions
        }
    }
}
