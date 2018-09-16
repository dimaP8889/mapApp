//
//  ViewController.swift
//  mapApp
//
//  Created by dmitriy1 on 14.09.2018.
//  Copyright © 2018 dmitriy1. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    
    var locationManager = CLLocationManager.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let location = locationManager.location else { return }
        centerMapOnLocation(location: location)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleTap(gestureReconizer:)))
        gestureRecognizer.delegate = self as? UIGestureRecognizerDelegate
        mapView.addGestureRecognizer(gestureRecognizer)
        checkLocationAuthorizationStatus()
    }
    
    // Search button Pressed
    @IBAction func searchButton(_ sender: Any) {
        
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
        
    }
    
    // Search button Ckicked Search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //Activity indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        //Hide searchbar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //Create search request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activityIndicator.stopAnimating()
        activeSearch.start { (response, error) in
            if error != nil {
                print("ERROR")
            } else {
                
                
                // Remove annotations
                self.mapView.removeAnnotations(self.mapView.annotations)
                
                //Getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                //Create annotation
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                
                self.mapView.addAnnotation(annotation)
                
                //Zoom in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span)

                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    // Handle tap on the map
    @objc func handleTap(gestureReconizer: UILongPressGestureRecognizer) {

        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)

        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate

        var locationPoint = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        sleep(1/2)
        Alamofire.request(url, method : .get).responseJSON {
            
        }
        
//        fetchCityAndCountry(from: locationPoint) { city, country, error in
//            
//            if (error == nil) {
//                
//                guard let city = city, let country = country, error == nil else { return }
//                print(city + ", " + country)  // Rio de Janeiro, Brazil
//                annotation.title = city
//            }
//        }
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    
    
    
    
    // Check autorization
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // Center your location
    func centerMapOnLocation(location: CLLocation) {

        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

}
