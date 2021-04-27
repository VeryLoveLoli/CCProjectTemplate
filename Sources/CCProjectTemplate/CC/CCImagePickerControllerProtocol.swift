//
//  CCImagePickerControllerProtocol.swift
//  
//
//  Created by 韦烽传 on 2021/2/23.
//

import Foundation
import UIKit
import AVFoundation
import Photos

/**
 CC图片/视频选择控制器协议
 */
public protocol CCImagePickerControllerProtocol { }

/**
 CC图片/视频选择控制器协议
 */
public extension CCImagePickerControllerProtocol where Self: UIViewController {
    
    /**
     提示拍照或选择相册
     
     - parameter    isEditing: 是否编辑照片/视频
     */
    func alertCameraOrPhotoLibrary(_ isEditing: Bool = true, isImage: Bool = true, block: @escaping (UIImage, URL?)->Void) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction.init(title: "拍照", style: .default, handler: { (action) in
            
            if self.cameraPermissions() {
                
                self.open(.camera, isEditing: isEditing, isImage: isImage, block: block)
            }
            else {
                
                self.alertPermissions(.camera)
            }
        }))
        
        alert.addAction(UIAlertAction.init(title: "选择相册", style: .default, handler: { (action) in
            
            if self.photoLibraryPermissions() {
                
                self.open(.photoLibrary, isEditing: isEditing, isImage: isImage, block: block)
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
     - parameter    isEditing: 是否编辑图片/视频
     */
    func open(_ type: UIImagePickerController.SourceType , isEditing: Bool, isImage: Bool, block: @escaping (UIImage, URL?)->Void) {
        
        let imagePickerController: UIImagePickerController = UIImagePickerController()
        
        if isImage {
            
            imagePickerController.mediaTypes = ["public.image"]
        }
        else {
            
            imagePickerController.mediaTypes = ["public.movie"]
        }
        
        let delegate = CCImagePickerControllerHandle.init()
        
        any = delegate
        
        delegate.finishPickingMediaWithInfoBlock = { [weak self] (image, url) in
            
            if let image = image {
                
                block(image, url)
            }
            
            self?.any = nil
            self?.dismiss(animated: true, completion: nil)
        }
        
        delegate.cancelBlock = { [weak self] in
            
            self?.any = nil
            self?.dismiss(animated: true, completion: nil)
        }
        
        imagePickerController.delegate = delegate
        imagePickerController.allowsEditing = isEditing
        imagePickerController.sourceType = type
        
        present(imagePickerController, animated: true, completion: nil)
    }
}
