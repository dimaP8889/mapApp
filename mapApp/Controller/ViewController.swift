//
//  ViewController.swift
//  mapApp
//
//  Created by dmitriy1 on 14.09.2018.
//  Copyright © 2018 dmitriy1. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    
    var locationManager = CLLocationManager.init()
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    
    let weatherData = WeatherDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let location = locationManager.location else { return }
        
        centerMapOnLocation(location: location)
        
        //Create gesture Recognizer
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleTap(gestureReconizer:)))
        
        gestureRecognizer.delegate = self as? UIGestureRecognizerDelegate
        
        //Add gesture Recognizer to Map View
        mapView.addGestureRecognizer(gestureRecognizer)
        
        checkLocationAuthorizationStatus()
    }
    
    //MARK: - get weather button pressed
    @IBAction func getWeatherButton(_ sender: Any) {
        
        performSegue(withIdentifier: "Weather", sender: self)
    }
    
    //MARK: - prepare for segue to Weather
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Weather" {
        
            let weatherViewController = segue.destination as! TemperatureViewController
            
            weatherViewController.weatherDataModule = self.weatherData
        }
    }
    
    //MARK: - Search button Pressed in NavigationController Bar
    @IBAction func searchButton(_ sender: Any) {
        
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
        
    }
    
    //MARK: Search button Clicked Search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //Hide searchbar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //Show progress Bar
        SVProgressHUD.show()
        
        //Create search request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        //start Search on map
        activeSearch.start { (response, error) in
            if error != nil {
                print("ERROR")
                SVProgressHUD.dismiss()
            } else {
                
                // Remove annotations
                self.mapView.removeAnnotations(self.mapView.annotations)
                
                //Getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                
                
                //Create annotation
                self.setAnnotation(with : coordinate)
                
                //send API requst
                self.getTemparature(with: coordinate)
                SVProgressHUD.dismiss()
                
                //Zoom in on annotation
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span)

                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
   //MARK: - Handle tap on the map
    @objc func handleTap(gestureReconizer: UILongPressGestureRecognizer) {


        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)

        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate

        getTemparature(with: coordinate)
    }
    
    //MARK: - Send API requst to get temperature
    func getTemparature(with coortdinates : CLLocationCoordinate2D) {
        
        let params : [String : String] = ["lat" : "\(coortdinates.latitude)", "lon" : "\(coortdinates.longitude)", "appid" : APP_ID]
        weatherData.getWeatherData(url: WEATHER_URL, parameters: params)
        
        setAnnotation(with: coortdinates)
    }
    
    //MARK: - set annitation to map
    func setAnnotation (with coordinate : CLLocationCoordinate2D) {
        
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
    }
    
    
    //MARK: - Check autorization
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    //MARK: - Center your location
    func centerMapOnLocation(location: CLLocation) {

        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
