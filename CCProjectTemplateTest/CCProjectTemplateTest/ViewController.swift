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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            
            let vc = CCTabBarCollectionViewController.storyboard()
            vc.tabBarCollectionView = CCTabBarCollectionView.xib()
            vc.tabBarCollectionView?.frame = CGRect.init(x: 0, y: 44, width: vc.view.bounds.width, height: 60)
            vc.tabBarCollectionView?.visibleTabBarNumber = 5
            vc.tabBarCollectionView?.cellNibName = "CCTabBarCollectionViewCell"
            vc.view.addSubview(vc.tabBarCollectionView!)
            vc.list = Array.init(repeating: CCViewController.storyboard(), count: 6)
            vc.source = Array.init(repeating: JSONValue(["title": "title"]), count: vc.list.count).json
            
            self.present(vc, animated: true, completion: nil)
        }
    }


}

