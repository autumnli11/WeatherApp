//
//  ViewController.swift
//  WeatherPrediction
//
//  Created by Autumn Li on 4/8/20.
//  Copyright © 2020 Autumn Li. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var cityCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cityData.cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        let city = cityData.cities[index]
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cityCell", for: indexPath) as? CityCollectionViewCell {
            cell.time.text = city.time
            //TODO: set properties in cell
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let layout = self.cityCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: (self.cityCollectionView.frame.size.width - 20)/2, height: self.cityCollectionView.frame.size.height/3)
    }


}

