//
//  WeatherPageVC.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 01.10.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class WeatherPageVC: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    // MARK: - Properties -
    var content = 0
    var trips: [Trip]? {
        didSet {
            trips = Trip.getCurrentTrips(context: CoreDataStack.instance.persistentContainer.viewContext)
        }
    }
    
    // MARK: - Outlets -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        trips = { trips }()
        
        if trips == nil {
            // получаем погоду для текущего положения
        } else {
            content = (trips?.count)!
        }
        
        if content > 0 {
            let firstController = getItemController(0)!
            let startingViewControllers = [firstController]
            self.setViewControllers(startingViewControllers, direction: .forward, animated: false, completion: nil)
        }
        
        setupPageControl()
    }
    
    func setupPageControl() {
        self.view.backgroundColor = UIColor.white
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.red
        appearance.currentPageIndicatorTintColor = UIColor.blue
        appearance.backgroundColor = UIColor.white
    }
    
    // MARK: - UIPageViewControllerDataSource methods -
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! WeatherTemplateVC
        
        if itemController.itemIndex > 0 {
            
            return getItemController(itemController.itemIndex - 1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let itemController = viewController as? WeatherTemplateVC {
            
            if itemController.itemIndex + 1 < content {
                
                return getItemController(itemController.itemIndex + 1)
            }
        }
        
        return nil
    }
    
    func getItemController(_ itemIndex: Int) -> UIViewController? {
        
        if itemIndex < content {
            let pageItemVC = self.storyboard!.instantiateViewController(withIdentifier: "WeatherTemplateVC") as! WeatherTemplateVC
            pageItemVC.itemIndex = itemIndex
            pageItemVC.contentModel = trips?[itemIndex]
            return pageItemVC
            }
        return nil
    }
    
    // MARK: - Page Indicator -
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return content
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    // MARK: - Additions -
    func currentControllerIndex() -> Int {
        let pageItemController = self.currentController()
        
        if let controller = pageItemController as? WeatherTemplateVC {
            return controller.itemIndex
        }
        
        return -1
    }
    
    func currentController() -> UIViewController? {
        
        if (self.viewControllers?.count)! > 0 {
            return self.viewControllers![0]
        }
        
        return nil
    }

}
