//
//  ViewController.swift
//  CCProjectTemplateTest
//
//  Created by 韦烽传 on 2019/6/2.
//  Copyright © 2019 韦烽传. All rights reserved.
//

import UIKit
import JSONValue

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        testCCBannerCollectionView(true)
    }

    
    // MARK - Test
    
    /**
     测试标签栏集合视图控制器
     */
    func testCCTabBarCollectionViewController(_ isVerticalScroll: Bool = false) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            
            let vc = CCTabBarCollectionViewController.storyboard()
            vc.tabBarCollectionView = CCTabBarCollectionView.xib()
            
            if isVerticalScroll {
                
                (vc.tabBarCollectionView?.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .vertical
                vc.tabBarCollectionView?.collectionView.isVerticalScroll = true
                vc.tabBarCollectionView?.frame = CGRect.init(x: 0, y: 44, width: 60, height: vc.view.bounds.height)
            }
            else {
                
                vc.tabBarCollectionView?.frame = CGRect.init(x: 0, y: 44, width: vc.view.bounds.width, height: 60)
            }
            
            vc.tabBarCollectionView?.visibleTabBarNumber = 5
            vc.tabBarCollectionView?.cellNibName = "CCTabBarCollectionViewCell"
            vc.view.addSubview(vc.tabBarCollectionView!)
            vc.list = Array.init(repeating: CCViewController.storyboard(), count: 6)
            vc.source = Array.init(repeating: JSONValue(["title": "title"]), count: vc.list.count).json
            
            self.present(vc, animated: true, completion: nil)
        }
    }

    /**
     测试Banner集合视图
     */
    func testCCBannerCollectionView(_ isVerticalScroll: Bool = false) {
        
        let v = CCBannerCollectionView.xib()
        
        v.cellNibName = "CCBannerCollectionViewCell"
        
        if isVerticalScroll {
            
            (v.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .vertical
            v.collectionView.isVerticalScroll = true
        }
        else {
            
        }
        
        v.frame = CGRect.init(x: 0, y: 44, width: 200, height: 100)
        v.collectionView.frame = v.bounds
        view.addSubview(v)
        
        for i in 0..<10 {
            
            v.list.append(JSONValue(["title": i, "icon": "CC_web_reload"]))
        }
    }
}

