//
//  Location.swift
//  WeatherApp
//
//  Created by Robert Wais on 1/22/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//
//Singleton class
import Foundation
import CoreLocation
class Location {
    static var sharedInstance = Location()
    
    private init(){}
    
    var latitude: Double!
    var longitude: Double!
}
