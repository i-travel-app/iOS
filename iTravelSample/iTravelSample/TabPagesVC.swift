//
//  TabPagesVC.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 07.09.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import TabPageViewController

class TabPagesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tc = TabPageViewController.create()
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor.red
        let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThingsTVC")
        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor.blue
        tc.tabItems = [(vc1, "Советуем"), (vc2, "Удалено"), (vc3, "Взяли")]
        var option = TabPageOption()
        option.tabWidth = view.frame.width / CGFloat(tc.tabItems.count)
        option.hidesTopViewOnSwipeType = .all
        option.tabBackgroundColor = Constants.blueColor
        tc.option = option
        
        self.addChildViewController(tc)
        
        view.addSubview(tc.view)
        
        tc.view.frame = view.bounds
        tc.view.frame.origin.y += (navigationController?.navigationBar.frame.size.height)! + option.currentBarHeight + option.tabHeight
        print(tc.view.frame.origin.y)
        tc.view.frame.size.height = 200
        print(tc.view.frame.size)
        tc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }
}
