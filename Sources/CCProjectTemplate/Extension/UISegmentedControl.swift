//
//  File.swift
//  
//
//  Created by 韦烽传 on 2020/12/2.
//

import Foundation
import UIKit

// MARK: - iOS12的样式

public extension UISegmentedControl {
    
    /**
     iOS12的样式
     */
    func ensureiOS12Style() {
        
        if #available(iOS 13, *) {
            
            let tintColorImage = UIImage.color(tintColor)
            // Must set the background image for normal to something (even clear) else the rest won't work
            setBackgroundImage(UIImage.color(backgroundColor ?? .clear), for: .normal, barMetrics: .default)
            setBackgroundImage(tintColorImage, for: .selected, barMetrics: .default)
            setBackgroundImage(UIImage.color(tintColor.withAlphaComponent(0.2)), for: .highlighted, barMetrics: .default)
            setBackgroundImage(tintColorImage, for: [.highlighted, .selected], barMetrics: .default)
            setTitleTextAttributes([.foregroundColor: tintColor ?? UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)], for: .normal)
            setTitleTextAttributes([.foregroundColor: backgroundColor ?? .clear, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)], for: .selected)
            setDividerImage(tintColorImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
            layer.borderWidth = 1
            layer.borderColor = tintColor.cgColor
        }
    }
}
