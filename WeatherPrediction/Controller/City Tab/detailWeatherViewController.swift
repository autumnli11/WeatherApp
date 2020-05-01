//
//  PreviewViewController.swift
//  WeatherPrediction
//
//  Created by Autumn Li on 4/8/20.
//  Copyright © 2020 Autumn Li. All rights reserved.
//

import UIKit
import Charts

class detailWeatherViewController: UIViewController {
    
    //Interface Builder
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherSymbol: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var feels_like: UILabel!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunset: UILabel!
    @IBOutlet var chart: LineChartView!
    
    // Properties
    var selectedCity: City?
    var predictionData = PredictionData()
    
    // ViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        predictionData.fetch(city: selectedCity!.name) {
            DispatchQueue.main.async {
                print("here")
                self.setupChart()
            }
        }
        //Configure data on detail page
        if let city = selectedCity {
            cityName.lineBreakMode = .byWordWrapping
            cityName.text = city.name
            weather.text = city.weatherDescription
            weather.textAlignment = .center
            if let humidty = city.weatherStat["humidity"] as? Int {
                 humidity.text = "Humidity \(humidty) %"
            }
            if let pre = city.weatherStat["pressure"] as? Int {
                 pressure.text = "Pressure \(pre) hPa"
            }
            if let feels = city.weatherStat["feels_like"] as? Double {
                feels_like.text = "Feels like \(feels) °C"
            }
            weatherSymbol.image = UIImage(named: selectedCity!.imageDescription)
            if let temp = selectedCity!.weatherStat["temp"] as? Double {
                temperature.text = String(temp)+"°C"
                temperature.textAlignment = .center
            }
        }
    }
    
    func setupChart() {
            let data = predictionData.toLineData()
            chart.data = data
            
            chart.chartDescription?.enabled = false

            chart.dragEnabled = false
            chart.setScaleEnabled(false)
            chart.pinchZoomEnabled = false


            chart.legend.enabled = false

            chart.leftAxis.enabled = true
            chart.leftAxis.drawAxisLineEnabled = false
            chart.leftAxis.spaceTop = 0.4
            chart.leftAxis.spaceBottom = 0.4
            chart.leftAxis.axisMinimum = 0

            chart.rightAxis.enabled = false

            chart.xAxis.labelPosition = XAxis.LabelPosition.bottom
            chart.xAxis.drawGridLinesEnabled = false
        
        let sortedDates = predictionData.tempToDate.keys.sorted()
        var dateStrings = [String]()
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MM-dd"
        for date in sortedDates {
            let cur_date = dateFormatter1.string(from: date)
            dateStrings.append(cur_date)
        }
            chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateStrings)
        chart.xAxis.granularity = 1
            
        chart.animate(xAxisDuration: 2)
    }
    
}
