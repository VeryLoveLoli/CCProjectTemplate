//
//  CCImagePickerControllerDelegate.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit
import Photos

/**
 CC图片/视频选择控制器协议
 */
open class CCImagePickerControllerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// 完成图片/视频选择
    var finishPickingMediaWithInfoBlock: (UIImage?, URL?)->Void = {_,_ in}
    /// 取消图片/视频选择
    var cancelBlock: ()->Void = {}
    
    // MARK: - UIImagePickerControllerDelegate
    
    /**
     完成
     */
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var photo: UIImage?
        var url: URL?
        
        switch info[UIImagePickerController.InfoKey.mediaType] {
            
        case let string as String:
            
            if string == "public.image" {
                
                var key = UIImagePickerController.InfoKey.originalImage
                
                if picker.allowsEditing {
                    
                    key = UIImagePickerController.InfoKey.editedImage
                }
                
                if let image = info[key] as? UIImage  {
                    
                    photo = image
                }
                
                if #available(iOS 11.0, *) {
                    
                    if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                        
                        url = imageURL
                    }
                    
                } else {
                    
                    if let referenceURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
                        
                        url = referenceURL
                    }
                }
                
                finishPickingMediaWithInfoBlock(photo, url)
            }
            else if string == "public.movie" {
                
                if let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                    
                    url = mediaURL
                }
                
                var asset: PHAsset?
                
                if #available(iOS 11.0, *) {
                    
                    asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset
                }
                else {
                    
                    if let referenceURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
                        
                        let options = PHFetchOptions.init()
                        options.includeHiddenAssets = true
                        options.includeAllBurstAssets = true
                        
                        for kvItem in (referenceURL.query ?? "").components(separatedBy: "&") {
                            
                            let kv = kvItem.components(separatedBy: "=")
                            
                            if kv.count == 2 {
                                
                                if kv[0] == "id" {
                                    
                                    asset = PHAsset.fetchAssets(withLocalIdentifiers: [kv[1]], options: options).lastObject
                                    
                                    break
                                }
                            }
                        }
                    }
                }
                
                if let asset = asset {
                    
                    let options = PHImageRequestOptions.init()
                    options.version = .current
                    options.deliveryMode = .fastFormat
                    PHImageManager.default().requestImage(for: asset, targetSize: CGSize.init(width: CGFloat(asset.pixelWidth)/UIScreen.main.scale, height: CGFloat(asset.pixelWidth)/UIScreen.main.scale), contentMode: .default, options: options) { (image, info) in
                        
                        photo = image
                        
                        self.finishPickingMediaWithInfoBlock(photo, url)
                    }
                }
                else {
                    
                    finishPickingMediaWithInfoBlock(photo, url)
                }
            }
            
        default:
            
            finishPickingMediaWithInfoBlock(photo, url)
        }
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
