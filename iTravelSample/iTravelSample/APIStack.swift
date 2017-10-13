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
    
    // MARK: - Weather -
    
    func getCityData(latitude: String, longitude: String, completion: @escaping (_ array: [Weather]) -> ()) {
        
        let moc = CoreDataStack.instance.persistentContainer.viewContext
        
        let url: URL = URL(string: "https://api.openweathermap.org/data/2.5/forecast/daily?lat=\(latitude)&lon=\(longitude)&cnt=16&appid=f98e9a4853b6542f39b4d4bd709c0f99")!
        
        let defaultSession = URLSession.shared
        let urlRequest = URLRequest(url: url)
        let task = defaultSession.dataTask(with: urlRequest) { (data, response, error) in
            
            guard error == nil else { return }
            
            do {
                let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
                
                let datas = jsonDictionary["list"] as! NSArray
                
                var array = [Weather]()
                
                for (index, _) in datas.enumerated() {
                    
                    let cityData = datas[index] as! [String:Any]
                    
                    // получение описания погоды
                    let descArr = cityData["weather"] as! [[String:Any]]
                    let title = descArr[0]["description"] as! String
                    
                    // получение температуры в цельсиях
                    var celsius = 0.0
                    if let temp = cityData["temp"] as? [String:Double] {
                        let tempMax = temp["max"]!
                        let tempMin = temp["min"]!
                        celsius = ((tempMax+tempMin)/2) - 273.15
                    }
                    
                    // получение показателя облачности
                    let cloudNum =  cityData["clouds"] as! NSNumber
                    let cloudString = "\(cloudNum)"
                    
                    // получение данных о скорости ветра
                    let windNum = cityData["speed"] as! NSNumber
                    let windString = "\(windNum)"
                    
                    // получение данных об объеме осадков за последние 3 часа
                    var rainString:String = "0.0"
                    if let rain = cityData["rain"] as? Double {
                        rainString = NSString(format: "%.3f", rain) as String
                    }
                    
                    // получение даты, на которую собран прогноз
                    let date = cityData["dt"] as! Double
                    
                    // сохранение погоды в БД и массиве погод
                    let weather = Weather(context: moc)
                    weather.day = date
                    weather.title = title
                    weather.rain = rainString
                    weather.wind = windString
                    weather.cloud = cloudString
                    weather.temperature = celsius
                    
                    do {
                        try moc.save()
                    } catch {
                        fatalError()
                    }
                    
                    array.append(weather)
                    
                    DispatchQueue.main.async(execute: {
                        completion(array)
                    })
                    
                }
                
            } catch {
                print("invalid json query")
            }
        }
        
        task.resume()
    }
}

