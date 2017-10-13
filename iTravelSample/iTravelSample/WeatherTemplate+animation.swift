//
//  WeatherTemplate+animation.swift
//  iTravelSample
//
//  Created by Stanly Shiyanovskiy on 02.10.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import UIKit

enum AnimationDirection: Int {
    case positive = 1
    case negative = -1
}

extension WeatherTemplateVC {
    
    func changeWeatherDataTo(_ day:Int, animated: Bool = true) {
        var day = day
        
        if animated {
            
            //weather info
            self.cityName.text = self.contentModel?.targetPlace?.city?.capitalized
            self.forecast.text = forecastDict[self.forecasts[day].title!]?.capitalized
            
            let f = self.forecasts[day].temperature
            let temperatureString = NSString(format: "%.0f", f)
            self.tempLabel.text = "\(temperatureString as String)°"
            
            //city datas
            //self.cloud = self.forecasts[day].cloud
            //self.wind = self.forecasts[day].wind
            //self.rain = self.forecasts[day].rain
            
            if (day == forecasts.count-1) {
                day = 0
            } else {
                day += 1
            }
            
            //self.citydatas = [self.cloud!,self.rain!, self.wind!]
            
            //animate day and forecast change
            daySwitchTo(self.forecasts[day].day)
            forecastSwitchTo((forecastDict[self.forecasts[day].title!]?.capitalized)!)
            
            
            //cubeTransition()
            self.cubeTransition(label: self.tempLabel, text: "\(temperatureString as String)°", direction: .positive)
            
        }
        
        //switch to next day
        delay(seconds: 5.0) {
            
            //changeWeatherDataTo()
            self.changeWeatherDataTo(day)
            print(day)
            //self.animateTable()
            
        }
    }
    
    func cubeTransition(label: UILabel, text: String, direction: AnimationDirection) {
        
        let auxLabel = UILabel(frame: label.frame)
        auxLabel.text = text
        auxLabel.font = label.font
        auxLabel.textAlignment = label.textAlignment
        auxLabel.textColor = label.textColor
        auxLabel.backgroundColor = .clear
        
        let auxLabelOffset = CGFloat(direction.rawValue) *
            label.frame.size.height/2
        
        auxLabel.transform = CGAffineTransform(scaleX: 1.0, y: 0.1).concatenating(CGAffineTransform(translationX: 0.0, y: auxLabelOffset))
        
        label.superview!.addSubview(auxLabel)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
            
            auxLabel.transform = CGAffineTransform.identity
            label.transform = CGAffineTransform(scaleX: 1.0, y: 0.1).concatenating(CGAffineTransform(translationX: 0.0, y: -auxLabelOffset))
        }, completion: {_ in
            label.text = auxLabel.text
            label.transform = CGAffineTransform.identity
            
            auxLabel.removeFromSuperview()
        })
        
    }
    
    func daySwitchTo(_ date: Double) {
        
        UIView.animateKeyframes(withDuration: 1.0, delay: 0.0, options:[], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.80, animations: {
                self.date.alpha = 0.0
                
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.80, relativeDuration: 0.01, animations: {
                
                self.date.alpha = 1.0
                
            })
            
        }, completion: nil)
        
        delay(seconds: 0.5, completion: {
            
            //switching date
            self.displayDate(date)
            
        })
    }
    
    func forecastSwitchTo(_ forecast: String) {
        
        UIView.animateKeyframes(withDuration: 1.0, delay: 0.0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.80, animations: {
                
                self.forecast.alpha = 0.0
                
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.60, relativeDuration: 0.01, animations: {
                
                self.forecast.alpha = 1.0
                
            })
            
        }, completion: nil)
        
        delay(seconds: 0.5, completion: {
            
            //switching forecast
            self.forecast.text = forecast
            
        })
        
    }
}
