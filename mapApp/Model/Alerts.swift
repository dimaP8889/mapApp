//
//  Alerts.swift
//  mapApp
//
//  Created by dmitriy1 on 17.09.2018.
//  Copyright © 2018 dmitriy1. All rights reserved.
//

import Foundation
import UIKit

class Alerts {
    
    //MARK: Show alert bad connection
    func showConnectionAlert() -> UIAlertController{
        
        let alert = UIAlertController(title: "Connection Error", message: "Check your internet connection", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(action)
        
        return alert
    }
    
    func showAnnotationAlert() -> UIAlertController{
        
        let alert = UIAlertController(title: "Annotation Error", message: "Please add a point", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(action)
        
        return alert
    }
}
