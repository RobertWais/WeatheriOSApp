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

    let locationManager = CLLocationManager()
    var currLocation: CLLocation!
    var currentWeather: CurrWeather!
    
    var forecasts = [FutureForecast]()
    
    
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
        print("Future URL DOWNload.....")
        print("Future URL: \(FUTURE_URL_WEATHER)")
        let futureURL = URL(string: FUTURE_URL_WEATHER)
        
        Alamofire.request(futureURL!).responseJSON { response in
            let result = response.result
            //take value and put it in dict
            if let dict = result.value as? Dictionary<String,AnyObject>{
                
                if let list = dict["list"] as? [Dictionary<String,AnyObject>]{
                    
                    for index in list{
                        let forecast = FutureForecast(weatherDict: index)
                        self.forecasts.append(forecast)
                    }
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
        print("Date: \(currentWeather.date)")
        locationLbl.text = currentWeather.cityName
        print("Location: \(currentWeather.cityName)" )
        //This value is double
        //Easy cast to string
        currTempLbl.text = "\(currentWeather.currTemp)°F"
        print("Weather: \(currentWeather.weatherAction)")
        mainImageLbl.text = currentWeather.weatherAction
        mainImage.image = UIImage(named: currentWeather.weatherAction)
    }

    func locationAuthorized(){
        print("Entered Location Authorized")
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currLocation = locationManager.location
            print("Lat: \(currLocation.coordinate.latitude)")
            print("Long: \(currLocation.coordinate.longitude)")
            Location.sharedInstance.latitude = currLocation.coordinate.latitude
            Location.sharedInstance.longitude = currLocation.coordinate.longitude
            
            //To ensure it has been downloaded
            print("In authorized...")
            print("Full: \(FULL_URL_Weather)")
            print("Fu: \(FUTURE_URL_WEATHER)")
            
            currentWeather.downloadWeather {
                //Change UI for downloaded data
                self.downloadFutureForecast {
                    self.updateUI()
                }
            }
            print("Ended call")
        } else {
            locationManager.requestWhenInUseAuthorization()
            //repeat because we cannot go on until authorization
            locationAuthorized()
        }
    }
}

