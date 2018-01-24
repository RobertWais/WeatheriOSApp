//
//  FutureForecast.swift
//  WeatherApp
//
//  Created by Robert Wais on 1/21/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//
//Using weatherAPI

import Foundation
import Alamofire

class FutureForecast{
    var _date: String!
    var _weatherAction: String!
    var _highT: String!
    var _lowT: String!
    var _dateAndTime: String!
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    var dateAndTime: String {
        if _dateAndTime == nil {
            _dateAndTime = ""
        }
        return _dateAndTime
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        return _date
    }
    
    var weatherAction: String {
        if _weatherAction == nil {
            _weatherAction = ""
        }
        return _weatherAction
    }
    
    var highT: String {
        if _highT == nil {
            _highT = ""
        }
        return _highT
    }
    
    var lowT: String {
        if _lowT == nil{
            _lowT = ""
        }
        return _lowT
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    init(weatherDict: Dictionary<String,AnyObject>){
        if let dateTime = weatherDict["dt_txt"] as? String {
            self._dateAndTime = dateTime
        }
        if let temp = weatherDict["main"] as? Dictionary<String,AnyObject> {
            //key value***
            //past kelving temp change
            if let min = temp["temp_min"] as? Double {
                self._lowT = "\(min)°F"
                print("Low min: \(lowT)°F")
            }
            
            if let max = temp["temp_max"] as? Double {
                self._highT = "\(max)°F"
                print("Max temp: \(highT)°F")
            }
            
            
        }
        
        if let weather = weatherDict["weather"] as? [Dictionary<String,AnyObject>]{
            if let mainWeather = weather[0]["main"] as? String {
                self._weatherAction = mainWeather
            }
        }
        
        if let date = weatherDict["dt"] as? Double {
            let convertedDate = Date(timeIntervalSince1970: date)
            let dateFormat = DateFormatter();
            dateFormat.dateStyle = .full
            dateFormat.dateFormat = "EEE"
            dateFormat.timeStyle = .none
            self._date = convertedDate.dayWeek()
        }
    }
}

//conversion UNIX
extension Date {
    func dayWeek() -> String {
        let dateFormat = DateFormatter()
        //FULL NAME of Week
        dateFormat.dateFormat = "EEEE"
        return dateFormat.string(from: self)
    }
}
