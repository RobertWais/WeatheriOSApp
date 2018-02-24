//
//  currWeather.swift
//  WeatherApp
//
//  Created by Robert Wais on 1/21/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class CurrWeather{
    var _cityName: String!
    var _date: String!
    var _weatherAction: String!
    var _currTemp: Double!
    
    //safety
    var cityName: String{
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var weatherAction: String {
        if _weatherAction == nil{
            _weatherAction = ""
        }
        return _weatherAction
    }
    
    var currTemp: Double {
        if _currTemp == nil{
            _currTemp = 0.0
        }
        return _currTemp
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let currentDate = dateFormatter.string(from: Date())
        self._date = "\(currentDate)"
        return _date
    }
    
    func downloadWeather(completed : @escaping DownloadComplete){
        //Download using Alamofire
        let currWeatherURL = URL(string: OTHER_URL)
        Alamofire.request(currWeatherURL!).responseJSON{ response in
            let result = response.result
            
            //Read values in as dictionaries
            if let dict = result.value as? Dictionary<String,AnyObject>{
                
                if let name = dict["name"] as? String {
                    self._cityName = name
                }
                
                if let weather = dict["weather"] as? [Dictionary<String,AnyObject>]{
                    //look at JSON, O index, there are no other members in array
                    if let weatherType = weather[0]["main"] as? String{
                        self._weatherAction = weatherType
                    }
                    
                }
                
                if let temperature = dict["main"] as? Dictionary<String,AnyObject> {
                    
                    if var temp = temperature["temp"] as? Double{
                        temp = ((temp)*(9/5) - 459.67)
                        temp = Double(round(10 * temp/10))
                        self._currTemp = temp
                    }
                    
                }
            }
            completed()
        }
    }
}
