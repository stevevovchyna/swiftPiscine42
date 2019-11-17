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
    var places : [Place]?
    var selectedPlace : Place?
    var fromList : Bool = false
  
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var selector: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        map.showsUserLocation = false
        if let availablePlaces = places {
            for place in availablePlaces {
                addPin(place: place)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let place = selectedPlace, fromList {
//            addPin(place: place)
            focusMapView(lat: place.latitude, lon: place.longitude)
            fromList = false
        }
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
    
    @IBAction func getUserLocation(_ sender: UIButton) {
        
        map.showsUserLocation = true
        focusMapView(lat: currentLatitude ?? 30.0, lon: currentLongitude ?? 40.0)

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            self.currentLatitude = Double(location.coordinate.latitude)
            self.currentLongitude = Double(location.coordinate.longitude)
        }
    }
    
    func addPin(place: Place) {
        let point = MKPointAnnotation()
        point.title = place.name
        point.coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        point.subtitle = place.subtitle
        self.map.addAnnotation(point)
    }
    
    func focusMapView(lat : Double, lon : Double) {
        let mapCenter = CLLocationCoordinate2DMake(lat, lon)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: mapCenter, span: span)
        self.map.region = region
    }
}

