//
//  CCCollectionViewWaterfallsFlowLayoutDelegate.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import Foundation
import UIKit

/**
 瀑布流协议
 */
public protocol CCCollectionViewWaterfallsFlowLayoutDelegate {
    
    /**
     列数
     */
    func numberOfColumn(_ waterfallsFlowLayout: CCCollectionViewWaterfallsFlowLayout) -> Int
    
    /**
     格子高度
     */
    func waterfallsFlowLayout(_ waterfallsFlowLayout: CCCollectionViewWaterfallsFlowLayout, heightForItemAt indexPath: IndexPath) -> CGFloat
}
