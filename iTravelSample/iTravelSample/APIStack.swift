//
//  APIStack.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 10.06.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation

let BASE_URL = "http://77.220.215.26:8080/"


class APIStack {
    // Обращаемся к серверу в первую загрузку для получения idUser и последующей идентификации хозяина программы!!!
    
    func getThings() {
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: BASE_URL)!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        //Implement your logic
                        print(json)
                    }
                } catch {
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    }
    
    func getThingsByPOST() {
        // Create the URLSession on the default configuration
        let defaultSession = URLSession.shared
        
        // Setup the request with URL
        let url = URL(string: BASE_URL)
        var urlRequest = URLRequest(url: url!)
        
        // Convert POST string parameters to data using UTF8 Encoding
        let customDict = [
            "country" : "Ukraine",
            "city": "Texas",
            "transport" : "Auto",
            "data1" : "1-02-2107",
            "data2": "1-02-2107",
            "Peopl": [
                "age": 12,
                "sex": "m"
            ]
            ] as Dictionary<String, Any>
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: customDict, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // Set the httpMethod and assign httpBody
        urlRequest.httpMethod = "POST"
        
        let task = defaultSession.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    // handle json...
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}

