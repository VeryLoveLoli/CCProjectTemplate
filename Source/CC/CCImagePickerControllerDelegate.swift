//
//  CCImagePickerControllerDelegate.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit

/**
 CC图片选择控制器协议
 */
open class CCImagePickerControllerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// 完成图片选择
    var finishPickingMediaWithInfoBlock: (UIImage?)->Void = {_ in}
    /// 取消图片选择
    var cancelBlock: ()->Void = {}
    
    // MARK: - UIImagePickerControllerDelegate
    
    /**
     完成
     */
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var photo: UIImage?
        
        switch info[UIImagePickerController.InfoKey.mediaType] {
            
        case let string as String:
            
            if string == "public.image" {
                
                var key = UIImagePickerController.InfoKey.originalImage
                
                if picker.allowsEditing {
                    
                    key = UIImagePickerController.InfoKey.editedImage
                }
                
                switch info[key] {
                    
                case let image as UIImage:
                    
                    photo = image
                    
                default:
                    break
                }
            }
            
        default:
            break
        }
        
        finishPickingMediaWithInfoBlock(photo)
    }
    
    /**
     取消
     */
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        cancelBlock()
    }
    
    // MARK: - deinit
    
    deinit {
        #if DEBUG
        print("deinit: \(self)")
        #endif
    }
}
