//
//  CCViewController.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit
import JSONValue

/**
 CC视图控制器
 */
open class CCViewController: UIViewController, CCStoryboardProtocol {
    
    /// 状态栏
    public static var preferredStatusBarStyle: UIStatusBarStyle = .lightContent
    public static var preferredStatusBarUpdateAnimation: UIStatusBarAnimation = .fade
    
    /// 返回按钮图片
    public static var backBarItemImage = UIImage.init(named: "CC_back_bar_white")
    /// 返回按钮文字
    public static var backBarItemTitle = ""
    /// 返回按钮文字颜色
    public static var backBarItemTitleColor = UIColor.white
    
    /**
     Storyboard
     */
    open class func storyboard() -> Self {
        
        return storyboard(name: "CC", identifier: "CCViewController")
    }
    
    /**
     默认设置
     */
    open class func defaultSetting(_ vc: UIViewController) {
        
    }
    
    /// 回调
    open var callback: (JSONValue)->JSONValue = {_ in return JSONValue()}
    
    /// 数据
    open var source = JSONValue()
    
    /// 返回按钮图片
    open var backBarItemImage = CCViewController.backBarItemImage
    /// 返回按钮文字
    open var backBarItemTitle = CCViewController.backBarItemTitle
    /// 返回按钮文字颜色
    open var backBarItemTitleColor = CCViewController.backBarItemTitleColor
    
    /// 是否隐藏导航
    open var isHiddenNavigationController = false
    /// 是否动画隐藏显示导航
    open var isAnimatedNavigationController = true
    /// 是否隐藏返回按钮
    open var isHiddeBackBarItem: Bool = false {
        
        didSet {
            
            if !isHiddeBackBarItem {
                
                addNavBarItem(backBarItemImage, title: backBarItemTitle, titleColor: backBarItemTitleColor, direction: .left, action: #selector(backEvent))
            }
            else {
                
                let item = UIBarButtonItem.init(customView: UIView.init())
                navigationItem.leftBarButtonItem = item
                navigationItem.backBarButtonItem = item
            }
        }
    }
    
    /// 状态栏
    open var isHiddenStatusBar = false { didSet { setNeedsStatusBarAppearanceUpdate() } }
    open override var prefersStatusBarHidden: Bool { get { return isHiddenStatusBar } }
    open override var preferredStatusBarStyle: UIStatusBarStyle { get { return CCViewController.preferredStatusBarStyle} }
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { get { return CCViewController.preferredStatusBarUpdateAnimation } }
    
    open var statusBar = CCViewController.preferredStatusBarStyle {
        
        didSet {
            
            if statusBar == .default {
                
                navigationController?.navigationBar.barStyle = .default
            }
            else {
                
                navigationController?.navigationBar.barStyle = .black
            }
            
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    // MARK: - Activity
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        statusBar = CCViewController.preferredStatusBarStyle
        
        isHiddeBackBarItem = navigationController?.viewControllers.first == nil || navigationController?.viewControllers.first == self
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// 显示/隐藏 导航
        navigationController?.setNavigationBarHidden(isHiddenNavigationController, animated: isAnimatedNavigationController)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// 手势返回
        switch self.navigationController {
        case let nav as CCNavigationController:
            nav.isGestureBack = nav.viewControllers.count > 1
        default:
            break
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Navigation Event
    
    /**
     跳转页面
     
     - parameter    viewController:     页面
     - parameter    animated:           动画
     */
    open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: animated)
        viewController.tabBarController?.tabBar.isTranslucent = false
    }
    
    /**
     导航按钮方向
     */
    public enum NavBarItemDirection {
        /// 左边
        case left
        /// 右边
        case right
    }
    
    /**
     添加导航栏按钮
     
     - parameter    image:          图片
     - parameter    title:          文字
     - parameter    titleColor:     文字颜色
     - parameter    direction:      方向
     - parameter    action:         点击事件
     */
    open func addNavBarItem(_ image: UIImage?, title: String?, titleColor: UIColor?, direction: NavBarItemDirection, action: Selector) {
        
        let button = UIButton.init(type: .custom)
        
        var width: CGFloat = 5
        var height: CGFloat = 5
        
        if let icon = image {
            
            button.setImage(icon, for: .normal)
            width += icon.size.width
            height += icon.size.height
        }
        
        if let t = title {
            
            let font = UIFont.systemFont(ofSize: 16)
            button.titleLabel?.font = font
            button.setTitle(title, for: .normal)
            button.setTitleColor(titleColor, for: .normal)
            let rect = t.boundingRect(with: CGSize(width: 10000, height: 20), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font ], context: nil)
            width += rect.size.width
            height += rect.size.height
        }
        
        if image != nil && title != nil {
            
            width += 5
            height += 5
        }
        
        button.frame = CGRect.init(x: 0, y: 0, width: width, height: height)
        button.addTarget(self, action: action, for: .touchUpInside)
        
        addNavBarItem(button, direction: direction)
    }
    
    /**
     添加导航按钮
     
     - parameter    customView:     视图
     - parameter    direction:      方向
     */
    open func addNavBarItem(_ customView: UIView, direction: NavBarItemDirection) {
        
        let item = UIBarButtonItem.init(customView: customView)
        
        switch direction {
        case .left:
            if navigationItem.leftBarButtonItems == nil {
                navigationItem.leftBarButtonItems = [item]
            }
            else {
                navigationItem.leftBarButtonItems?.append(item)
            }
        case .right:
            if navigationItem.rightBarButtonItems == nil {
                navigationItem.rightBarButtonItems = [item]
            }
            else {
                navigationItem.rightBarButtonItems?.append(item)
            }
        }
    }
    
    /**
     返回事件
     */
    @IBAction open func backEvent(_ sender: Any? = nil) {
        
        if let nav = self.navigationController {
            
            nav.popViewController(animated: true)
        }
        else {
            
            dismiss(animated: true)
        }
    }
    
    // MARK: - Network
    
    /**
     网络加载
     */
    open func networkLoading() {
        
    }
    
    // MARK: - deinit
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        #if DEBUG
        print("deinit: \(self)")
        #endif
    }
}
