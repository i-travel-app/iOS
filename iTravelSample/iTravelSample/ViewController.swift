//
//  ViewController.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 04.05.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var clothesArray = [Cloth]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.isHidden = true
        self.maskView.alpha = 0
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var maskView: UIView!
    func makeGetCall() {

        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: "http://localhost:8080/greeting?type=Зимнее".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        //Implement your logic
                        let cloth = Cloth()
                        cloth.title = json["context"] as! String
                        cloth.id = json["id"] as! Int
                        self.clothesArray.append(cloth)
                        self.startIndicator()
                        //self.openTableViewController()
                    }
                } catch {
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    }
    
    func openTableViewController() {
        DispatchQueue.main.async(execute: {
            self.stopIndicator()
            let tableViewController = self.storyboard?.instantiateViewController(withIdentifier: "SiSTableViewController") as! SiSTableViewController
            tableViewController.clothesSet = Set(self.clothesArray)
            self.navigationController!.pushViewController(tableViewController, animated: true)
            
            return
        })
    }
    
    func startIndicator() {
        DispatchQueue.main.async(execute: {
            self.maskView.alpha = 0.75
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.openTableViewController()
            }
        })
    }
    
    func stopIndicator() {
        DispatchQueue.main.async(execute: {
            self.maskView.alpha = 0
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        })
    }

    @IBAction func getClothesArray(_ sender: Any) {
        makeGetCall()
    }
    
}

class Cloth: NSObject {
    var title = ""
    var id = 0
}









