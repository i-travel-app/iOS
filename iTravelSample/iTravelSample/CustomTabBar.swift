//
//  CustomTabBar.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 07.09.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import TabPageViewController

class CustomTabBar: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
//        if item.title == "Вещи" {
//            let tc = TabPageViewController.create()
//            let vc1 = UIViewController()
//            vc1.view.backgroundColor = UIColor.red
//            let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThingsTVC")
//            tc.tabItems = [(vc1, "First"), (vc2, "Second")]
//            var option = TabPageOption()
//            option.tabWidth = view.frame.width / CGFloat(tc.tabItems.count)
//            option.hidesTopViewOnSwipeType = .all
//            tc.option = option
//        }
        print("Selected item")
    }
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
}
