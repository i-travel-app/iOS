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
    
    // Singleton
    static let instance = APIStack()
    private init() {}
    
    
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
    
    func getThingsByPOST(weather: Int, sex: Int, tripKind: Int, callback:@escaping ([String])->()) {
        
        // Create the URLSession on the default configuration
        let defaultSession = URLSession.shared
        
        // Setup the request with URL
        let url = URL(string: BASE_URL)
        var urlRequest = URLRequest(url: url!)
        
        // Convert POST string parameters to data using UTF8 Encoding
        // weather winter = 1, sex.man = 1, trip.kind.relax = 1
        let customDict = [
            "id_weather" : String(weather),
            "id_sex": String(sex),
            "id_tip" : String(tripKind)
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
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String] {
                    print(json)
                    // handle json...
                    callback(json)
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }
}

