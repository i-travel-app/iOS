//
//  WeatherTemplateVC.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 01.10.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

let forecastDict = ["light rain" : "легкий дождь",
                    "sky is clear" : "чистое небо",
                    "broken clouds" : "облачно",
                    "moderate rain" : "умеренный дождь",
                    "scattered clouds" : "переменная облачность",
                    "few clouds" : "малооблачно",
                    "heavy intensity rain" : "Ливень"]

class WeatherTemplateVC: UIViewController {
    
    // MARK: - Properties -
    var itemIndex: Int = 0
    var contentModel: Trip?
    var forecasts = [Weather]()
    
    //city data
    var cloud:String?
    var rain:String?
    var wind:String?
    var citydatas = [String]()
    var icons = [String]()
    
    // MARK: - Outlets -
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var forecast: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        displayCityWeather()
    }
    
    func displayCityWeather() {
        
        let day:Int = 0
        
        //new array with cloudiness, rain volume and wind speed information
        self.citydatas = loadWeatherData()
        
        //date change
        self.displayDate(self.forecasts[0].day)
        
        //(5-day weather forecast) - changeWeatherDataTo()
        delay(seconds: 5.0, completion: { () -> () in
            self.changeWeatherDataTo(day)
            //self.animateTable()
            
        })
        
        //animate Table
        //self.animateTable()
        
    }
    
    func loadWeatherData() -> [String] {
        
        var newArray = [String]()
        if let array = Array((contentModel?.weather)!) as? [Weather] {
            let sorted = array.sorted(by: { (param1, param2) -> Bool in
                return param1.day < param2.day
            })
            self.forecasts = sorted
        }
        
        for (index, i) in forecasts.enumerated() {
            print("\(index) -> \(i.day) -> \(i.temperature) -> \(i.title)")
        }
        
        //display weather for day 1 = Today
        self.cityName.text = self.contentModel?.targetPlace?.city?.capitalized
        self.forecast.text = forecastDict[self.forecasts[0].title!]?.capitalized
        
        let f = self.forecasts[0].temperature
        let temperatureString = NSString(format: "%.0f", f)
        
        self.tempLabel.text = "\(temperatureString as String)°"
        
        //self.cloud = self.forecasts[0].cloud
        //self.wind = self.forecasts[0].wind
        //self.rain = self.forecasts[0].rain
        
        //new array with cloudiness, rain volume and wind speed information
        //newArray = [self.cloud!, self.rain!, self.wind!]
        
        return newArray
        
    }
    
    func displayDate(_ value: Double) {
        
        let date = Date(timeIntervalSince1970: value)
        let now = Date()
        
        let months = ["Декабря", "Января", "Февраля", "Марта", "Апреля", "Мая", "Июня", "Июля", "Августа", "Сентября", "Октября", "Ноября"];
        let weekDays = ["Суббота", "Воскресенье", "Понедельник", "Вторник", "Среда", "Четверг", "Пятница"];
        
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.month, .weekday, .day], from: date)
        let todayComponents = (calendar as NSCalendar).components([.day], from: now)
        let day = components.day
        let today = todayComponents.day
        let monthIndex = components.month
        var weekdayIndex = components.weekday
        
        if weekdayIndex == weekDays.count {
            weekdayIndex = 0
        }
        
        let month = months[monthIndex!]
        let weekday = weekDays[weekdayIndex!]
        
        if (day == today) {
            self.date.text = "Сегодня"
        } else {
            self.date.text = "\(weekday), \(day!) \(month)"
        }
    }
}

func delay(seconds: Double, completion:@escaping ()->()) {
    let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
    
    DispatchQueue.main.asyncAfter(deadline: popTime) {
        completion()
    }
}
