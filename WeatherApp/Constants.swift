//
//  Constants.swift
//  WeatherApp
//
//  Created by Robert Wais on 1/21/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import Foundation

let FULL_URL_Weather = "http://api.openweathermap.org/data/2.5/weather?lat=\(Location.sharedInstance.latitude)&lon=\(Location.sharedInstance.longitude)&appid=656d0979a432420fabe35721711f37e2"
let FUTURE_URL_WEATHER = "http://api.openweathermap.org/data/2.5/forecast?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&units=imperial&appid=656d0979a432420fabe35721711f37e2"

let OTHER_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&appid=656d0979a432420fabe35721711f37e2"

let main_URL = "http://samples.openweathermap.org/data/2.5/weather?"
let LAT = "lat="
let LONG = "&lon="
let API_ID = "&appid="
let API_KEY = "656d0979a432420fabe35721711f37e2"
//let FULL_URL_Weather = "\(main_URL)\(LAT)\(Location.sharedInstance.latitude)\(LONG)\(Location.sharedInstance.longitude)\(API_ID)\(API_KEY)"

//When complete
typealias DownloadComplete = () -> ()
