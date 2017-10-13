//
//  PagesThingsVC.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 08.09.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class PagesThingsVC: UIViewController, CAPSPageMenuDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var trips: [Trip]? {
        didSet {
            trips = Trip.getCurrentTrips(context: CoreDataStack.instance.persistentContainer.viewContext)
        }
    }
    var currentTrip: Trip?
    
    var pageMenu : CAPSPageMenu?
    var tap: UITapGestureRecognizer!
    var isTableViewShow = false
    
    @IBOutlet weak var tableView: TripsTableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint?
    
    var blackView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuImg = UIImage(named: "menu")
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        menuButton.setBackgroundImage(menuImg, for: .normal)
        menuButton.addTarget(self, action: #selector(PagesThingsVC.tapped), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        trips = { trips }()
        
        if currentTrip == nil {
            currentTrip = trips?.last
        }
        let str = currentTrip == nil ? "Вещи" : "№\((currentTrip?.idTrip)!) - \((currentTrip?.targetPlace?.city)!), \((currentTrip?.targetPlace?.country)!)"
        navigationItem.title = str
        tabBarController?.tabBar.isHidden = false
        
        self.view.backgroundColor = Constants.blueColor
        
        var controllerArray : [UIViewController] = []
        
        let vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecommendedThingsVC") as! RecommendedThingsVC
        vc1.title = "Советуем"
        vc1.currentTrip = currentTrip
        
        controllerArray.append(vc1)
        
        if currentTrip != nil {
            let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChoosedThingsVC") as! ChoosedThingsVC
            vc2.title = "Подготовили"
            vc2.currentTrip = currentTrip
            
            let vc3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InSuitThingsVC") as! InSuitThingsVC
            vc3.title = "Уже взяли"
            vc3.currentTrip = currentTrip
            
            controllerArray.append(vc2)
            controllerArray.append(vc3)
        }
        
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

        let topFramesHeight = (navigationController?.navigationBar.frame.size.height)! + 20
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x:0.0, y:topFramesHeight, width:self.view.frame.width, height:self.view.frame.height), pageMenuOptions: parameters)

        
        self.view.addSubview(pageMenu!.view)
        
        pageMenu!.delegate = self
        
        self.heightConstraint?.constant = CGFloat((trips?.count)!) * 44.0
        self.tableView.alpha = 0
        
    }
    
    // MARK: - CASPageMenuDelegate -
    func willMoveToPage(_ controller: UIViewController, index: Int){
    
    }
    
    func didMoveToPage(_ controller: UIViewController, index: Int){
    
    }
    
    // MARK: - Gestures
    @objc func tapped() {
        print("tap")
        
        if blackView == nil {
            blackView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            blackView?.backgroundColor = UIColor.lightGray
            blackView?.alpha = 0
            self.view.addSubview(blackView!)
        }
        
        if !isTableViewShow && !(trips?.isEmpty)! {
            UIView.animate(withDuration: 0.3) {
                self.tableView.alpha = 1
                self.blackView?.alpha = 0.5
                self.isTableViewShow = true
                self.view.bringSubview(toFront: self.blackView!)
                self.view.bringSubview(toFront: self.tableView)
            }
        } else {
            hideTableView()
        }
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trip = trips![indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = "\(trip.targetPlace!.city!), \(trip.targetPlace!.country!), \(trip.startDate!.toString())"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        currentTrip = trips?[indexPath.row]
        
        hideTableView()
    }
    
    func hideTableView() {
        if self.isTableViewShow {
            UIView.animate(withDuration: 0.3, animations: {
                self.blackView?.alpha = 0
                self.tableView.alpha = 0
            }, completion: { (finish) in
                
                self.isTableViewShow = false
            })
        }
        
        self.viewWillAppear(true)
        self.view.layoutSubviews()
    }
}
