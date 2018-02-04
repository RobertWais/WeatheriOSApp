//
//  WeatherVC.swift
//  WeatherApp
//
//  Created by Robert Wais on 1/21/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit
import CoreLocation
//change later
import Alamofire
class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    
    @IBOutlet var currDateLbl: UILabel!
    @IBOutlet var currTempLbl: UILabel!
    @IBOutlet var locationLbl: UILabel!
    @IBOutlet var mainImage: UIImageView!
    @IBOutlet var mainImageLbl: UILabel!
    @IBOutlet var tableView: UITableView!

    var conditions = [String:Int]()
    let locationManager = CLLocationManager()
    var currLocation: CLLocation!
    var currentWeather: CurrWeather!
    
    var forecasts = [FutureForecast]()
    var sectionsOfDay = [FutureForecast]()
    var tempDay = ""
    var count = 0
    
    var tempAverage = [Int]()
    var weatherAverage = 0
    
    
    @IBAction func pressBtn(_ sender: Any) {
        forecasts.removeAll(keepingCapacity: false)
        tempDay = ""
        locationAuthorized()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        //Location
        //
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //only used when screen is active and using app
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
     
        
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        //print(FULL_URL_Weather)
        currentWeather = CurrWeather()
        print(FULL_URL_Weather)
        
    }
    
    //before viewDidLoad
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthorized()
        
    }
    
    func downloadFutureForecast(completed: @escaping DownloadComplete){
        //Downloading for tableView
        //print("Future URL DOWNload.....")
        //print("Future URL: \(FUTURE_URL_WEATHER)")
        let futureURL = URL(string: FUTURE_URL_WEATHER)
        
        Alamofire.request(futureURL!).responseJSON { response in
            let result = response.result
            //take value and put it in dict
            if let dict = result.value as? Dictionary<String,AnyObject>{
                
                if let list = dict["list"] as? [Dictionary<String,AnyObject>]{
                    
                    for index in list{
                        let forecast = FutureForecast(weatherDict: index)
                       // print("DayOfWeek: \(forecast.date)")
                        
                        //SAME DAY
                        if self.tempDay == "" {
                            //Set First Day
                            self.sectionsOfDay.append(forecast)
                            self.tempDay = forecast.date
                        }else if forecast.date == self.tempDay {
                            
                            //Add this other section in day to other sections
                            self.sectionsOfDay.append(forecast)
                            
                        //NEW DAY
                        } else {
                            ///Get average forecast for specific day
                            let addForecast = self.getAverageForecast()
                            self.forecasts.append(addForecast)
                            
                            //Prepare for new set of days
                            self.tempDay = forecast.date
                            self.sectionsOfDay.removeAll(keepingCapacity: false)
                            self.sectionsOfDay.append(forecast)
                        }
                    }
                    self.sectionsOfDay.removeAll(keepingCapacity: false)
                    self.forecasts.remove(at: 0)
                    self.tableView.reloadData()
                }
            }
            completed()
        }
    }

    //Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell") as? weathCell{
            let theForecast = forecasts[indexPath.row]
            cell.setCell(forecast: theForecast)
            return cell
        }else{
            return weathCell()
        }
        
    }
//
    func updateUI(){
        //class that was originally intialized
        currDateLbl.text = currentWeather.date
        locationLbl.text = currentWeather.cityName
        
        currTempLbl.text = "\(currentWeather.currTemp)°F"
        
        mainImageLbl.text = currentWeather.weatherAction
        mainImage.image = UIImage(named: currentWeather.weatherAction)
    }

    func locationAuthorized(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currLocation = locationManager.location
            
            print("Lat: \(currLocation.coordinate.latitude)")
            print("Long: \(currLocation.coordinate.longitude)")
            
            Location.sharedInstance.latitude = currLocation.coordinate.latitude
            Location.sharedInstance.longitude = currLocation.coordinate.longitude
            
          
            currentWeather.downloadWeather {
                //Change UI for downloaded data
                self.downloadFutureForecast {
                    self.updateUI()
                }
            }
        } else {
            //repeat because we cannot go on until authorization
            locationManager.requestWhenInUseAuthorization()
            locationAuthorized()
        }
    }
    
    func getNumIndex(string: String)->Int{
        var num = 0
        switch string{
        case "Sunday":
            num = 0
        case "Monday":
            num = 1
        case "Tuesday":
            num = 2
        case "Wednesday":
            num = 3
        case "Thursday":
            num = 4
        case "Friday":
            num = 5
        case "Sunday":
            num = 6
        default:
            num = 0
            
        }
        return num
    }
    
    func getAverageForecast()->FutureForecast{
        var finalWeather = ""
        var finalNum = 0
        count += 1
        print("Count \(count)")
        var averageHigh = 0.0
        var averageLow = 400.0
        var typeOfWeather = ""
        
        //Loop to find highs, lows, and put weather counts in conditions(dictionary)
        for index in 0..<(self.sectionsOfDay.count){
            let tempForecast = self.sectionsOfDay[index]
            var tempHigh = Double(tempForecast.highT)!
            var tempLow = Double(tempForecast.lowT)!
            if tempHigh > averageHigh{
                averageHigh = tempHigh
            }
            if tempLow < averageLow{
                averageLow = tempLow
            }
            if let val = conditions[tempForecast.weatherAction]{
                conditions[tempForecast.weatherAction] = val + 1
            }else{
                conditions[tempForecast.weatherAction] = 1
                
            }
        }
        
        //Find the weather that will be seen the most throughout the day
        for (key,number) in conditions {
            if number > finalNum{
                finalWeather = key
                finalNum = number
            }
        }
        conditions.removeAll(keepingCapacity: false)
        return FutureForecast(date: self.tempDay, highTemp: Double(averageHigh), lowTemp: Double(averageLow), weatherType: finalWeather)
    }
}
