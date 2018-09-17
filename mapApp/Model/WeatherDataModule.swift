//
//  WeatherDataModule.swift
//  mapApp
//
//  Created by dmitriy1 on 16.09.2018.
//  Copyright © 2018 dmitriy1. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WeatherDataModel {
    
    //Declare model variables here
    
    var temperature = 0
    var condition = 0
    var city = ""
    var weatherIconName = ""
    
    //This method turns a condition code into the name of the weather condition image
    
    func updateWeatherIcon(condition: Int) -> String {
        
        switch (condition) {
            
        case 0...300 :
            return "tstorm1"
            
        case 301...500 :
            return "light_rain"
            
        case 501...600 :
            return "shower3"
            
        case 601...700 :
            return "snow4"
            
        case 701...771 :
            return "fog"
            
        case 772...799 :
            return "tstorm3"
            
        case 800 :
            return "sunny"
            
        case 801...804 :
            return "cloudy2"
            
        case 900...903, 905...1000  :
            return "tstorm3"
            
        case 903 :
            return "snow5"
            
        case 904 :
            return "sunny"
            
        default :
            return "dunno"
        }
        
    }
    
    //MARK: - Networking
    /***************************************************************/
    func getWeatherData(url: String, parameters: [String : String]) {
        
        Alamofire.request(url, method : .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Succes! Got the weather data")
                
                let weatherJson : JSON = JSON(response.result.value!)
                
                self.updateWeatherData(json: weatherJson)
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.city = ""
            }
        }
    }
    //Write the getWeatherData method here:
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    
    //Write the updateWeatherData method here:
    func updateWeatherData(json : JSON) {
        
        if let tempResult = json["main"]["temp"].double {
            self.temperature = Int(tempResult - 273.15)
            
            self.city = json["name"].stringValue
            
            self.condition = json["weather"][0]["id"].intValue
            
            self.weatherIconName = self.updateWeatherIcon(condition: self.condition)
        }
    }
}
