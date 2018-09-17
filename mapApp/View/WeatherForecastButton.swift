//
//  ZoomButton.swift
//  mapApp
//
//  Created by dmitriy1 on 15.09.2018.
//  Copyright © 2018 dmitriy1. All rights reserved.
//

import UIKit

class WeatherForecastButton: UIButton {
    
    override func awakeFromNib() {
        layer.borderWidth = 2
        layer.cornerRadius = 25
        layer.borderColor = UIColor.black.cgColor
    }
}
