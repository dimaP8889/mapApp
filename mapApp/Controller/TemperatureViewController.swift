//
//  TemperatureViewController.swift
//  mapApp
//
//  Created by dmitriy1 on 16.09.2018.
//  Copyright © 2018 dmitriy1. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TemperatureViewController: UIViewController {

    var weatherDataModule = WeatherDataModel()
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUIWeatherData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UI Updates
    /***************************************************************/
    
    func updateUIWeatherData() {
        
        if (weatherDataModule.city != ""){
            cityLabel.text = weatherDataModule.city
        } else {
            cityLabel.text = "Unavaible"
        }
        temperatureLabel.text = String(weatherDataModule.temperature) + "°"
        weatherIcon.image = UIImage(named: weatherDataModule.weatherIconName)
    }

}
