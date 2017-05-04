//
//  ViewController.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 04.05.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var clothesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
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
                        let cloth : String = json["context"] as! String
                        self.clothesArray.append(cloth)
                        self.openTableViewController()
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
            let tableViewController = self.storyboard?.instantiateViewController(withIdentifier: "SiSTableViewController") as! SiSTableViewController
            tableViewController.clothesSet = Set(self.clothesArray)
            self.navigationController!.pushViewController(tableViewController, animated: true)
            
            return
        })
    }

    @IBAction func getClothesArray(_ sender: Any) {
        makeGetCall()
    }
    
}

