//
//  CityData.swift
//  WeatherPrediction
//
//  Created by Autumn Li on 4/9/20.
//  Copyright © 2020 Autumn Li. All rights reserved.
//

import Foundation
var cityData = CityData()

class City {
    var name: String
    var weather: String
    var time: String
    var temperature: String
    
    init(name: String, weather: String, time: String, temperature: String) {
        self.name = name
        self.weather = weather
        self.time = time
        self.temperature = temperature
    }
    
}

class CityData {
    var cities: [City] = [
        City(name: "Berkeley", weather: "Sunny", time: "8:00AM", temperature: "38°C")
    ]
}
