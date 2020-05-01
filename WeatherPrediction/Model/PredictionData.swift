//
//  PredictionData.swift
//  WeatherPrediction
//
//  Created by Ruochen Liu on 4/30/20.
//  Copyright © 2020 Autumn Li. All rights reserved.
//

import Foundation
import Charts

class PredictionData {
    var tempToDate = [Date: Double]()
    var list = [Any]()
    
    func fetch(city: String, completion: @escaping () -> Void) {
        var urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=df9a9d56a28dff1eaa5c354658257615&units=metric"
        urlString = urlString.replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if err != nil {
                print(err!)
                return
            }
            
            guard let cityData = data else { return }
            let json = try? JSONSerialization.jsonObject(with: cityData, options: [])
            guard let dictionary = json as? [String: Any] else { return }
            guard let list = dictionary["list"] as? [Any] else { return }
            
            var index = 0
            for prediction in list {
                if index % 6 == 0 {
                    guard let cur = prediction as? [String: Any] else { return }
                    guard let cur_date = cur["dt_txt"] as? String else { return }
                    guard let main = cur["main"] as? [String: Any] else { return }
                    guard let temp = main["temp"] as? Double else { return }
                    let dateFormatter1 = DateFormatter()
                    dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let date = dateFormatter1.date(from: cur_date)
                    dateFormatter1.dateFormat = "MM-dd"
                    let clean_date = dateFormatter1.string(from: date!)
                    let final_date = dateFormatter1.date(from: clean_date)
                    self.tempToDate[final_date!] = temp
                }
                index += 1
            }
            print(self.tempToDate)
            completion()
        }.resume()
    }
    
    
    
    func toLineData() -> LineChartData {
        var chartData = [ChartDataEntry]()
        let sortedDates = tempToDate.keys.sorted()
        
        for i in 0 ..< sortedDates.count {
            chartData.append(ChartDataEntry(x: Double(i), y: Double(tempToDate[sortedDates[i]]!)))
        }
        
        let set = LineChartDataSet(entries: chartData, label: "Temperature")
        
        set.lineWidth = 1.75
        set.circleRadius = 5.0
        set.circleHoleRadius = 2.5
        set.setColor(.black)
        set.setCircleColor(.black)
        set.highlightColor = .black
        set.drawValuesEnabled = false
        
        return LineChartData(dataSet: set)
    }
    
    
}

//class ChartFormatter:NSObject,IAxisValueFormatter{
//
//    var months: [String]! = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
//
//    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//    return months[Int(value)]
//    }
//
//}
