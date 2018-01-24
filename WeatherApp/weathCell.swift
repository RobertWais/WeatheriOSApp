//
//  weathCell.swift
//  WeatherApp
//
//  Created by Robert Wais on 1/22/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit

class weathCell: UITableViewCell {

    
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var dayOfWeek: UILabel!
    @IBOutlet var lowTemp: UILabel!
    @IBOutlet var highTemp: UILabel!
    @IBOutlet var weatherAction: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //maybe take out
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func setCell(forecast: FutureForecast){
        lowTemp.text = "\(forecast.lowT)"
        highTemp.text = "\(forecast.highT)"
        weatherAction.text = forecast.weatherAction
        dayOfWeek.text = forecast.date
        weatherImage.image = UIImage(named: forecast.weatherAction)
    }
}
