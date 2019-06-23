//
//  CCAlertViewController.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit
import JSONValue

/**
 CC提示视图控制器
 */
open class CCAlertViewController: CCViewController {
    
    /**
     Storyboard
     */
    open override class func storyboard() -> Self {
        
        return storyboard(name: "CC", identifier: "CCAlertViewController")
    }
    
    /**
     默认设置
     */
    open override class func defaultSetting(_ vc: UIViewController) {
        
        vc.modalPresentationStyle = .custom
    }
    
    /// 透明遮层
    @IBOutlet open weak var alphaView: UIView!
    /// 内容视图
    @IBOutlet open weak var contentView: UIView!
    /// 标题
    @IBOutlet open weak var titleLable: UILabel?
    /// 详情
    @IBOutlet open weak var detailLabel: UILabel?
    /// 确定
    @IBOutlet open weak var determine: UIButton?
    /// 取消
    @IBOutlet open weak var cancel: UIButton?
    
    /// 详情
    open var detail: String?
    
    /// 动画类型
    open var animateType: CCAlertAnimateType = .Scale
    /// 动画遮层透明度
    open var animateAlpha: CGFloat = 0.3
    /// 动画时间
    open var animateTime: TimeInterval = 0.25
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = .custom
        view.backgroundColor = UIColor.clear
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        titleLable?.text = title
        detailLabel?.text = detail
        
        hide()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        show(true)
    }
    
    // MARK: - Animated Event
    
    /**
     显示动画
     
     - paramter animated: 是否动画
     
     - paramter completion: 动画结束响应
     
     */
    func show(_ animated: Bool, completion: (() -> Swift.Void)? = nil) {
        
        if animated {
            
            UIView.animate(withDuration: self.animateTime, animations: {
                
                self.show()
                
            }) { (bool) in
                
                if let complete = completion {
                    
                    complete()
                }
            }
        }
        else {
            
            self.show()
            
            if let complete = completion {
                
                complete()
            }
        }
    }
    
    /**
     显示设置
     */
    func show() {
        
        alphaView.alpha = animateAlpha
        
        switch animateType {
            
        case .Scale:
            
            contentView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            
        case .Top:
            
            contentView.transform = CGAffineTransform.init(translationX: 0, y: 0)
            
        case .bottom:
            
            contentView.transform = CGAffineTransform.init(translationX: 0, y: 0)
        }
    }
    
    /**
     隐藏动画
     
     - paramter animated: 是否动画
     
     - paramter completion: 动画结束响应
     
     */
    func hide(_ animated: Bool, completion: (() -> Swift.Void)? = nil) {
        
        if animated {
            
            UIView.animate(withDuration: self.animateTime, animations: {
                
                self.hide()
                
            }) { (bool) in
                
                self.dismiss(animated: false, completion: completion)
            }
        }
        else {
            
            hide()
            dismiss(animated: false, completion: completion)
        }
    }
    
    /// 隐藏设置
    func hide() {
        
        alphaView.alpha = 0
        
        switch animateType {
            
        case .Scale:
            
            contentView.transform = CGAffineTransform.init(scaleX: 0.000001, y: 0.000001)
            
        case .Top:
            
            contentView.transform = CGAffineTransform.init(translationX: 0, y: -contentView.frame.size.height)
            
        case .bottom:
            
            contentView.transform = CGAffineTransform.init(translationX: 0, y: contentView.frame.size.height)
        }
    }
    
    // MARK: - IBAction
    
    /**
     确定
     */
    @IBAction func determine(_ sender: Any? = nil) {
        
        hide(true) {
            
            _ = self.callback(JSONValue(true))
        }
    }
    
    /**
     取消
     */
    @IBAction func cancel(_ sender: Any? = nil) {
        
        hide(true) {
            
            _ = self.callback(JSONValue())
        }
    }
}
