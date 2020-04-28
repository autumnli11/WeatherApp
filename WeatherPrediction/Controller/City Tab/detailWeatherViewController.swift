//
//  PreviewViewController.swift
//  WeatherPrediction
//
//  Created by Autumn Li on 4/8/20.
//  Copyright © 2020 Autumn Li. All rights reserved.
//

import UIKit

class detailWeatherViewController: UIViewController {

    //Interface Builder
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherSymbol: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunset: UILabel!
    
    // Properties
    var selectedCity: City?
    
    // ViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //Configure data on detail page
        if let city = selectedCity {
            cityName.text = city.name
            weather.text = city.weatherDescription
            if let humidty = city.weatherStat["humidity"] as? String {
                 humidity.text = humidty
            }
            weatherSymbol.image = UIImage(named: selectedCity!.weatherDescription)
            if let temp = selectedCity!.weatherStat["temp"] as? Double {
                temperature.text = String(temp)+"°C"
            }
        }
    }
}
