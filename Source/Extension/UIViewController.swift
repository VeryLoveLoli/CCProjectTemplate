//
//  UIViewController.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit
import Prompt

// MARK: - 提示

public extension UIViewController {
    
    /**
     文字提示
     
     - parameter    title:          文字
     - parameter    milliseconds:   显示时间
     - parameter    isBackground:   是否显示背景（用于阻止用户点击）
     */
    func promptTitle(_ title: String, milliseconds: Int = 2000, isBackground: Bool = false) {
        
        Prompt.title(title, milliseconds: milliseconds, isBackground: isBackground, sup: view, location: view.center)
    }
    
    /**
     加载提示
     
     - parameter    title:          文字
     - parameter    timeInterval:   动态显示的文字时间间隔
     - parameter    repeats:        动态显示的文字个数（<=title.count，从后往前算）
     - parameter    isBackground:   是否显示背景（用于阻止用户点击）
     */
    func promptLoad(_ title: String = "正在加载...", timeInterval: TimeInterval = 1, repeats: Int = 2, isBackground: Bool = false) -> Prompt {
        
        return Prompt.load(title, timeInterval: timeInterval, repeats: repeats, isBackground: isBackground, sup: view, location: view.center)
    }
    
    /**
     GIF提示
     
     - parameter    data:           GIF数据
     - parameter    isBackground:   是否显示背景（用于阻止用户点击）
     */
    func promptGIF(_ data: Data, isBackground: Bool = false) -> Prompt {
        
        return Prompt.gif(data, isBackground: isBackground, sup: view, location: view.center)
    }
}

import AVFoundation
import Photos

// MARK: - 选择相册图片/相机图片

public extension UIViewController {
    
    /**
     提示拍照或选择相册
     
     - parameter    isEditing: 是否编辑照片
     */
    func alertCameraOrPhotoLibrary(_ isEditing: Bool = true, block: @escaping (UIImage)->Void) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction.init(title: "拍照", style: .default, handler: { (action) in
            
            if self.cameraPermissions() {
                
                self.open(.camera, isEditing: isEditing, block: block)
            }
            else {
                
                self.alertPermissions(.camera)
            }
        }))
        
        alert.addAction(UIAlertAction.init(title: "选择相册", style: .default, handler: { (action) in
            
            if self.photoLibraryPermissions() {
                
                self.open(.photoLibrary, isEditing: isEditing, block: block)
            }
            else {
                
                self.alertPermissions(.photoLibrary)
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    /**
     判断相机权限
     */
    func cameraPermissions() -> Bool{
        
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        if(authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted) {
            
            return false
        }
        else {
            
            return true
        }
        
    }
    
    /**
     判断相册权限
     */
    func photoLibraryPermissions() -> Bool {
        
        let library:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        if(library == PHAuthorizationStatus.denied || library == PHAuthorizationStatus.restricted){
            
            return false
        }
        else {
            
            return true
        }
    }
    
    /**
     提示设置权限
     
     - parameter    type:   权限类型
     */
    func alertPermissions(_ type: UIImagePickerController.SourceType) {
        
        var message = ""
        
        switch type {
        case .camera:
            message = "请在设置中打开相机权限"
        case .photoLibrary:
            message = "请在设置中打开相册权限"
        default:
            message = "请在设置中打开权限"
        }
        
        let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: "设置", style: .default, handler: { (action) in
            
            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!)
        }))
        
        alert.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    /**
     打开相册/相机
     
     - parameter    type: .photoLibrary: 相册; .camera:打开相机
     - parameter    isEditing: 是否编辑图片
     */
    func open(_ type: UIImagePickerController.SourceType , isEditing: Bool, block: @escaping (UIImage)->Void) {
        
        let imagePickerController: UIImagePickerController = UIImagePickerController()
        
        let delegate = CCImagePickerControllerDelegate.init()
        
        delegate.finishPickingMediaWithInfoBlock = { [weak self] (image) in
            
            if let image = image {
                
                block(image)
            }
            
            self?.any = nil
            self?.dismiss(animated: true, completion: nil)
        }
        
        delegate.cancelBlock = { [weak self] in
            
            self?.any = nil
            self?.dismiss(animated: true, completion: nil)
        }
        
        any = delegate
        
        imagePickerController.delegate = delegate
        imagePickerController.allowsEditing = isEditing
        imagePickerController.sourceType = type
        
        present(imagePickerController, animated: true, completion: nil)
    }
}
