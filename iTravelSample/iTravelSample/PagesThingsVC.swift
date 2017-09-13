//
//  PagesThingsVC.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 08.09.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class PagesThingsVC: UIViewController, CAPSPageMenuDelegate {
    
    var pageMenu : CAPSPageMenu?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Вещи"
        
        self.view.backgroundColor = Constants.blueColor

        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []
        
        let vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecommendedThingsTVC")
        //vc1.view.backgroundColor = .red
        vc1.title = "Советуем"
        let vc2 = UIViewController()
        vc2.view.backgroundColor = .green
        vc2.title = "Удалено"
        let vc3 = UIViewController()
        vc3.view.backgroundColor = .blue
        vc3.title = "Взяли"
        
        controllerArray.append(vc1)
        controllerArray.append(vc2)
        controllerArray.append(vc3)
        
        // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
        // Example:
        let parameters: [CAPSPageMenuOption] = [
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorPercentageHeight(0.1),
            .menuHeight(40),
            .scrollMenuBackgroundColor(Constants.blueColor),
            .centerMenuItems(false),
            .selectedMenuItemLabelColor(UIColor.white),
            .unselectedMenuItemLabelColor(UIColor.white),
            .selectionIndicatorColor(UIColor.white),
            .bottomMenuHairlineColor(Constants.blueColor)

        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        let topFramesHeight = (navigationController?.navigationBar.frame.size.height)! + 20
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x:0.0, y:topFramesHeight, width:self.view.frame.width, height:self.view.frame.height), pageMenuOptions: parameters)
        
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.view.addSubview(pageMenu!.view)
        
        // Optional delegate
        pageMenu!.delegate = self
    }
    
    // MARK: - CASPageMenuDelegate -
    func willMoveToPage(_ controller: UIViewController, index: Int){
    
    }
    
    func didMoveToPage(_ controller: UIViewController, index: Int){
    
    }

}
