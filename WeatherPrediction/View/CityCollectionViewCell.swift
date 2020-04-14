//
//  CityCollectionViewCell.swift
//  WeatherPrediction
//
//  Created by Autumn Li on 4/8/20.
//  Copyright © 2020 Autumn Li. All rights reserved.
//

import UIKit


class CityCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var symbol: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet var deleteButton: UIButton!
    var timezone = 0
    var timer = Timer()
    
    
    @objc func tick() {
        let currentDate = Date()
        let format = DateFormatter()
        format.timeZone = TimeZone(secondsFromGMT: self.timezone)
        format.dateFormat = "h:mm a"
        let dateString = format.string(from: currentDate)
        time.text = dateString
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(tick) , userInfo: nil, repeats: true)
    }

}
