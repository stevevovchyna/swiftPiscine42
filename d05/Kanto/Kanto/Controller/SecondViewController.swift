//
//  SecondViewController.swift
//  Kanto
//
//  Created by Steve Vovchyna on 15.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SecondViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var currentLatitude : Double?
    var currentLongitude : Double?
  
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var selector: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        map.showsUserLocation = false

        // Do any additional setup after loading the view.
        addPin(latitude: 48.896607, longitude: 2.318501, title: "Ecole 42", subtitle: "There's no place like home")
        focusMapView(lat: 48.896607, lon: 2.318501)
    }

    @objc func stopLocating() {
        map.showsUserLocation = false
    }
    
    @IBAction func changeMapView(_ sender: UISegmentedControl) {
        switch selector.selectedSegmentIndex {
        case 0:
            map.mapType = .standard
        case 1:
            map.mapType = .satellite
        case 2:
            map.mapType = .hybrid
        default:
            return
        }
    }
    @IBAction func getUserLocation(_ sender: UIButton) {
        
        map.showsUserLocation = true
        focusMapView(lat: currentLatitude ?? 30.0, lon: currentLongitude ?? 40.0)

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            
            currentLatitude = Double(location.coordinate.latitude)
            currentLongitude = Double(location.coordinate.longitude)
            
        }
    }
    
    func addPin(latitude: Double, longitude: Double, title: String, subtitle : String) {
        let point = MKPointAnnotation()
        point.title = title
        point.subtitle = subtitle
        point.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        map.addAnnotation(point)
    }
    
    func focusMapView(lat : Double, lon : Double) {
        let mapCenter = CLLocationCoordinate2DMake(lat, lon)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: mapCenter, span: span)
        map.region = region
    }
    
}

