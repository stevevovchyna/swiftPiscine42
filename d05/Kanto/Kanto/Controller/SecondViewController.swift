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

class SecondViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
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
        map.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        map.showsUserLocation = false
        if let availablePlaces = places {
            map.addAnnotations(availablePlaces)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let place = selectedPlace, fromList {
            focusMapView(lat: place.coordinate.latitude, lon: place.coordinate.longitude)
            fromList = false
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let customAnnotation = annotation as? Place else {
            return nil
        }
        var annotationView = MKMarkerAnnotationView()
        if let dequedView = mapView.dequeueReusableAnnotationView( withIdentifier: "") as? MKMarkerAnnotationView {
            annotationView = dequedView
        } else {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "")
        }
        mapView.userLocation.title = ""
        annotationView.markerTintColor = customAnnotation.pinColor
        annotationView.canShowCallout = true
        return annotationView
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
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            map.showsUserLocation = true
            focusMapView(lat: currentLatitude ?? 30.0, lon: currentLongitude ?? 50.0)
            break
        case .authorizedAlways:
            map.showsUserLocation = true
            focusMapView(lat: currentLatitude ?? 30.0, lon: currentLongitude ?? 50.0)
            break
        case .denied:
            showLocationUnavailableAlert()
            break
        case .restricted:
            showLocationUnavailableAlert()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            self.currentLatitude = Double(location.coordinate.latitude)
            self.currentLongitude = Double(location.coordinate.longitude)
        }
    }
    
    func focusMapView(lat : Double, lon : Double) {
        let mapCenter = CLLocationCoordinate2DMake(lat, lon)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: mapCenter, span: span)
        self.map.region = region
    }
    
    func showLocationUnavailableAlert() {
        let alert = UIAlertController(title: "Alert", message: "Please provide the app access to your location", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Go to Settings", style: UIAlertAction.Style.default, handler: { (alert: UIAlertAction!) in
            let url = NSURL(string:UIApplication.openSettingsURLString)! as URL
            UIApplication.shared.open(url)
        }))
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
