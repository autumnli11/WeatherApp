//
//  MapViewController.swift
//  WeatherPrediction
//
//  Created by Autumn Li on 4/8/20.
//  Copyright © 2020 Autumn Li. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var popOver: UIView!
    @IBOutlet var alertPopOver: UIView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var alertLabel: UILabel!
    
    var selectedCity : City!
    var selectedCord : CLLocationCoordinate2D!
    
    var currentLocation: CLLocation!
    var locationManager = CLLocationManager()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let initialLocation = CLLocation(latitude: 37.8719, longitude: -122.2585)
        mapView.centerToLocation(initialLocation)
//
//        let oahuCenter = CLLocation(latitude: 37.8719, longitude: -122.2585)
//        let region = MKCoordinateRegion(
//          center: oahuCenter.coordinate,
//          latitudinalMeters: 50000,
//          longitudinalMeters: 60000)
//        mapView.setCameraBoundary(
//          MKMapView.CameraBoundary(coordinateRegion: region),
//          animated: true)
        
//        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
//        mapView.setCameraZoomRange(zoomRange, animated: true)
        
//        // Show location on map
//        let artwork = Location(
//          title: "UC Berkeley",
//          locationName: "weather prediction",
//          discipline: "University",
//          coordinate: CLLocationCoordinate2D(latitude: 37.8719, longitude: -122.2585))
//        mapView.addAnnotation(artwork)
//        mapView.delegate = self
        
        // make the map recognize long tap
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(longTapGesture)
        
        popOver.layer.cornerRadius = 15
        alertPopOver.layer.cornerRadius = 15
        
        saveButton.layer.cornerRadius = 12
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.darkGray.cgColor
        
        cancelButton.layer.cornerRadius = 12
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.darkGray.cgColor
        
    }
    
    @objc func longTap(sender: UIGestureRecognizer){
        if sender.state == .began {
            let location = sender.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            self.selectedCord = coordinate
            fetchData(lat: coordinate.latitude, lon: coordinate.longitude) {
                DispatchQueue.main.async {
                    self.descriptionLabel.text = self.selectedCity.weatherDescription
                    if let temp = self.selectedCity.weatherStat["temp"] as? Double {
                        self.tempLabel.text = String(temp)+"°"
                    }
                    self.nameLabel.text = self.selectedCity.name
                    self.view.addSubview(self.popOver)
                    self.popOver.center = self.view.center
                }
            }
        }
    }

    
    func fetchData(lat: Double, lon: Double, completion: @escaping () -> Void) {
        let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=df9a9d56a28dff1eaa5c354658257615&units=metric"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if err != nil {
                print(err!)
                return
            }
            
            guard let cityData = data else { return }
            let json = try? JSONSerialization.jsonObject(with: cityData, options: [])
            guard let dictionary = json as? [String: Any] else { return }
            
            guard let cod = dictionary["cod"] as? Any? else { return }
            let code = String(describing: cod!)
            if (code == "404") {
//                self.error = true
            } else {
//                self.error = false
                guard let weather = dictionary["weather"] as? [Any] else { return }
                guard let weatherObj = weather[0] as? [String: Any] else { return }
                guard let name = dictionary["name"] as? String else { return }
                guard let timezone = dictionary["timezone"] as? Int else { return }
                guard let main = dictionary["main"] as? [String: Any] else { return }
                guard let sys = dictionary["sys"] as? [String: Any] else { return }
                guard let coord = dictionary["coord"] as? [String: Any] else { return }
                guard let description = weatherObj["description"] as? String else { return }
                guard let imageDescription = weatherObj["main"] as? String else { return }
                self.selectedCity = City(name: name, weatherDescription: description, timezone: timezone, weatherStat: main, sun:sys , coord: coord, imageDescription: imageDescription)
            }
        
            completion()
        }.resume()
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action2 = UIAlertAction(title: "I got it", style: .default, handler: reset)
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil)
    }
    
    func reset(alert: UIAlertAction!) {
        selectedCity = nil
        selectedCord = nil
    }
    

    func addAnnotation(){
        let annotation = MKPointAnnotation()
        annotation.coordinate = selectedCord
        annotation.title = selectedCity.name
        annotation.subtitle = selectedCity.weatherDescription
        self.mapView.addAnnotation(annotation)
    }
    

    @IBAction func pressCancelButton(_ sender: UIButton) {
        self.popOver.removeFromSuperview()
    }

    
    @IBAction func pressSaveButton(_ sender: UIButton) {
        for city in cityData.cities {
            if (city.name == selectedCity.name) {
                showAlert(title: "Save Failed", message: "This city has already been saved!")
                self.popOver.removeFromSuperview()
                return
            }
        }
        cityData.cities.append(selectedCity)
        addAnnotation()
        showSavedAlert()
        self.popOver.removeFromSuperview()
    }
    
    func showSavedAlert() {
        alertLabel.text = "Saved Successfully!"
        alertPopOver.center = self.view.center

      self.view.addSubview(alertPopOver)

      Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.dismissAlert), userInfo: nil, repeats: false)
    }

    @objc func dismissAlert(){
      if alertPopOver != nil { // Dismiss the view from here
        alertPopOver.removeFromSuperview()
      }
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

private extension MKMapView {
  func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}




