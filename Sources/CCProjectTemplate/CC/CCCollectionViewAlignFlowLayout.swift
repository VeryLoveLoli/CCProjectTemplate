//
//  CCCollectionViewAlignFlowLayout.swift
//  
//
//  Created by 韦烽传 on 2021/4/14.
//

import Foundation
import UIKit

/**
 CC对齐流布局
 */
open class CCCollectionViewAlignFlowLayout: UICollectionViewFlowLayout {
    
    /**
     对齐方式
     */
    public enum Align {
        
        /// 默认UICollectionViewFlowLayout对齐
        case none
        /// 竖向滑动左对齐
        case left
        /// 竖向滑动右对齐
        case right
        /// 横向滑动上对齐
        case top
        /// 横向滑动下对齐
        case bottom
    }
    
    /// 对齐方式
    open var align: CCCollectionViewAlignFlowLayout.Align = .none
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let array = super.layoutAttributesForElements(in: rect)
        
        guard let list = array else { return array }
        
        guard list.count > 1 else { return array }
        
        if align == .none {
            
            return array
        }
        
        /// 上一个
        var previous = list[0]
        
        switch align {
        case .right, .bottom:
            previous = list[list.count-1]
        default:
            break
        }
        
        var previousFrame = previous.frame
        
        switch align {
        case .left:
            previousFrame.origin.x = sectionInset.left
        case .right:
            if let width = collectionView?.frame.size.width {
                previousFrame.origin.x = width - sectionInset.right - previousFrame.size.width
            }
        case .top:
            previousFrame.origin.y = sectionInset.top
        case .bottom:
            if let height = collectionView?.frame.size.height {
                previousFrame.origin.y = height - sectionInset.bottom - previousFrame.size.height
            }
        default:
            break
        }
        
        previous.frame = previousFrame
        
        for i in 1..<list.count {
            
            var index = i
            
            switch align {
            case .right, .bottom:
                index = list.count - i
            default:
                break
            }
            
            /// 下一个
            let next = list[index]
            
            /// 忽略组头、组尾
            if next.representedElementKind == UICollectionView.elementKindSectionHeader || next.representedElementKind == UICollectionView.elementKindSectionFooter {
                
                continue
            }
            
            var nextFrame = next.frame
            
            switch align {
            case .left:
                if previous.frame.origin.y == next.frame.origin.y {
                    nextFrame.origin.x = previous.frame.origin.x + previous.frame.size.width + minimumInteritemSpacing
                }
                else {
                    nextFrame.origin.x = sectionInset.left
                }
            case .right:
                if previous.frame.origin.y == next.frame.origin.y {
                    nextFrame.origin.x = previous.frame.origin.x - next.frame.size.width - minimumInteritemSpacing
                }
                else {
                    if let width = collectionView?.frame.size.width {
                        nextFrame.origin.x = width - sectionInset.right - nextFrame.size.width
                    }
                }
            case .top:
                if previous.frame.origin.x == next.frame.origin.x {
                    nextFrame.origin.y = previous.frame.origin.y + previous.frame.size.height + minimumInteritemSpacing
                }
                else {
                    nextFrame.origin.y = sectionInset.top
                }
            case .bottom:
                if previous.frame.origin.x == next.frame.origin.x {
                    nextFrame.origin.y = previous.frame.origin.y - next.frame.size.height - minimumInteritemSpacing
                }
                else {
                    if let height = collectionView?.frame.size.height {
                        nextFrame.origin.y = height - sectionInset.bottom - nextFrame.size.height
                    }
                }
            default:
                break
            }
            
            next.frame = nextFrame
            
            previous = next
        }
        
        return array
    }
}
