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
class WeatherViewController: UIViewController, UITextFieldDelegate {
    
    //Interface Builder
    @IBOutlet var searchBar: UITextField!
    @IBOutlet weak var cityCollectionView: UICollectionView!
    
    //Properties
    var selectedCity: City?
    
    
    // TODO: add delete button function

    @IBAction func pressSearchButton(_ sender: UIButton) {
        if let location = searchBar.text {
            cityData.fetchData(city: location) {
                DispatchQueue.main.async {
                    if cityData.error {
                        self.showAlert(title: "Sorry...", message: "This is an invalid city name:( Please try gain.")
                    }
                    if cityData.dup {
                        self.showSavedFailAlert(title: "Save Failed", message: "This city has already been saved!")
                        cityData.dup = false
                    }
                    let range = Range(uncheckedBounds: (0, self.cityCollectionView.numberOfSections))
                    let indexSet = IndexSet(integersIn: range)
                    self.cityCollectionView.reloadSections(indexSet)
                    self.searchBar.text = ""
                    self.hideKeyboard()
                }
            }
        }
    }
    
    func clearSearchBar(alert: UIAlertAction!){
        self.searchBar.text = ""
    }
    
    func showSavedFailAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action2 = UIAlertAction(title: "I got it", style: .default, handler: clearSearchBar)
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action2 = UIAlertAction(title: "I got it", style: .default, handler: clearSearchBar)
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        cityCollectionView.allowsSelection = true
        
        let flowLayout = cityCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.sectionInset.left = 20
        flowLayout.sectionInset.right = 20
        
        cityCollectionView.delegate = self
        cityCollectionView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cityCollectionView.reloadData()
    }
    
    func hideKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowlayout = collectionViewLayout as! UICollectionViewFlowLayout
        flowlayout.sectionInset.top = 10
        flowlayout.sectionInset.bottom = 10
        
        let space: CGFloat = (flowlayout.minimumInteritemSpacing ) + (flowlayout.sectionInset.left) + (flowlayout.sectionInset.right)
        let size: CGFloat = (cityCollectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: 200.0)
    }
}

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cityData.cities.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print(cityData.cities)
        
        let index = indexPath.item
        let city = cityData.cities[index]
        
//        dateLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none)
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cityCell", for: indexPath) as? CityCollectionViewCell {
            cell.contentView.layer.cornerRadius = 5.0
            cell.timezone = city.timezone
            let currentDate = Date()
            let format = DateFormatter()
            format.timeZone = TimeZone(secondsFromGMT: city.timezone)
            format.dateFormat = "h:mm a"
            
            let dateString = format.string(from: currentDate)
            let dateArr = dateString.components(separatedBy: " ")
            let dateTime = dateArr[0].components(separatedBy: ":")[0]
            if dateArr[1] == "AM" {
                if (Int(dateTime)! >= 6) && (Int(dateTime)! < 12){
                    cell.contentView.backgroundColor = UIColor(rgb: 0xE4B888)
                        
                } else {
                    cell.contentView.backgroundColor = UIColor(rgb: 0x968788)
                }
            } else {
                if (Int(dateTime)! >= 6) && (Int(dateTime)! < 12){
                    cell.contentView.backgroundColor = UIColor(rgb: 0xAE7467)
                } else {
                    cell.contentView.backgroundColor = UIColor(rgb: 0xDD9863)
                }
            }
                        
            cell.deleteButton?.tag = indexPath.row
            cell.deleteButton?.addTarget(self, action: #selector(deleteCity(sender:)), for: UIControl.Event.touchUpInside)

            cell.time.text = dateString
            cell.startTimer()
            cell.cityName.text = city.name
            cell.symbol.image = UIImage(named: city.imageDescription)

            if let temp = city.weatherStat["temp"] as? Double {
                cell.temperature.text = String(temp)+"°C"
            }

            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        selectedCity = cityData.cities[index]
        performSegue(withIdentifier: "cityBoardtoDetailWeather", sender: self)
    }
    
    @objc func deleteCity(sender:UIButton) {
        let i = sender.tag
        cityData.cities.remove(at: i)
        cityCollectionView.reloadData()
    }
}



// Segue
extension WeatherViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cityBoardtoDetailWeather" {
            let destinationVC = segue.destination as! detailWeatherViewController
            destinationVC.selectedCity = selectedCity
        }
    }
}


extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
