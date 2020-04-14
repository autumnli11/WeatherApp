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
    var name: String //Beijing
    var weatherDescription: String //overcast clouds
    var timezone: Int //28800
    var weatherStat: [String: Any] // {"humidity": 81, "temp": "286.87"}
    var sun: [String: Any] // {"sunrise": 1586813878, "sunset": 1586861455}
    var coord: [String: Any] // {"lat" = 39.91, "lon" = 116.4}
    
    init(name: String, weatherDescription: String, timezone: Int, weatherStat: [String: Any], sun: [String: Any], coord: [String: Any]) {
        self.name = name
        self.weatherDescription = weatherDescription
        self.timezone = timezone
        self.weatherStat = weatherStat
        self.sun = sun
        self.coord = coord
    }
    
}

class CityData {
    var cities = [City]();
    var error = false;
    
    func fetchData(city: String, completion: @escaping () -> Void) {
        var urlString = "http://api.openweathermap.org/data/2.5/weather?q=" + city + "&appid=df9a9d56a28dff1eaa5c354658257615&units=metric"
        urlString = urlString.replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            if err != nil {
                print(err!)
                self.error = true
                return
            }
            
            guard let cityData = data else { return }
            let json = try? JSONSerialization.jsonObject(with: cityData, options: [])
            guard let dictionary = json as? [String: Any] else { return }
            
            guard let cod = dictionary["cod"] as? Any? else { return }
            let code = String(describing: cod!)
            if (code == "404") {
                self.error = true
            } else {
                self.error = false
                guard let weather = dictionary["weather"] as? [Any] else { return }
                guard let weatherObj = weather[0] as? [String: Any] else { return }
                guard let name = dictionary["name"] as? String else { return }
                guard let timezone = dictionary["timezone"] as? Int else { return }
                guard let main = dictionary["main"] as? [String: Any] else { return }
                guard let sys = dictionary["sys"] as? [String: Any] else { return }
                guard let coord = dictionary["coord"] as? [String: Any] else { return }
                guard let description = weatherObj["description"] as? String else { return }

                self.cities.append(City(name: name, weatherDescription: description, timezone: timezone, weatherStat: main, sun:sys , coord: coord))
            }
            
            completion()
        }.resume()
    }
        
}

