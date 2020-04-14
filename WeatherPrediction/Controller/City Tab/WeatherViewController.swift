//
//  ViewController.swift
//  WeatherPrediction
//
//  Created by Autumn Li on 4/8/20.
//  Copyright © 2020 Autumn Li. All rights reserved.
//

import UIKit
import Foundation

var timer = Timer()
class WeatherViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet var searchBar: UITextField!
    @IBOutlet weak var cityCollectionView: UICollectionView!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cityData.cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let index = indexPath.item
        let city = cityData.cities[index]
        
//        dateLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none)
        
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cityCell", for: indexPath) as? CityCollectionViewCell {
            
            cell.timezone = city.timezone
            let currentDate = Date()
            let format = DateFormatter()
            format.timeZone = TimeZone(secondsFromGMT: city.timezone)
            format.dateFormat = "h:mm a"
            let dateString = format.string(from: currentDate)

            cell.time.text = dateString
            cell.startTimer()
            cell.cityName.text = city.name
            
            if let temp = city.weatherStat["temp"] as? Double {
                cell.temperature.text = String(temp)+"°"
            }
            
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    

    @IBAction func pressSearchButton(_ sender: UIButton) {
        if let location = searchBar.text {
            cityData.fetchData(city: location) {
                DispatchQueue.main.async {
                    if cityData.error {
                        self.showAlert(title: "Sorry...", message: "This is an invalid city name:( Please try gain.")
                    }
                    let range = Range(uncheckedBounds: (0, self.cityCollectionView.numberOfSections))
                    let indexSet = IndexSet(integersIn: range)
                    self.cityCollectionView.reloadSections(indexSet)
                    self.searchBar.text = ""

                }
            }
        }
    }
    
    func clearSearchBar(alert: UIAlertAction!){
        self.searchBar.text = ""
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action2 = UIAlertAction(title: "I got it", style: .default, handler: clearSearchBar)
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let layout = self.cityCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: (self.cityCollectionView.frame.size.width - 20)/2, height: self.cityCollectionView.frame.size.height/3)
        self.cityCollectionView.allowsSelection = false
    }
    


}

