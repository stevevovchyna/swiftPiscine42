//
//  ViewController.swift
//  Plan42
//
//  Created by Steve Vovchyna on 02.12.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()

    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var startPointText: UITextField!
    @IBOutlet weak var endPointText: UITextField!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var buildRouteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buildRouteButton.isHidden = true

        map.delegate = self
        map.showsUserLocation = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showUserLocation(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
        let currentLocation = locationManager.location?.coordinate
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            map.showsUserLocation = true
            focusMapView(latitude: currentLocation?.latitude ?? 30.0, longitude: currentLocation?.longitude ?? 50.0)
            break
        case .authorizedAlways:
            map.showsUserLocation = true
            focusMapView(latitude: currentLocation?.latitude ?? 30.0, longitude: currentLocation?.longitude ?? 50.0)
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
    
    func focusMapView(latitude: Double, longitude: Double) {
        let mapCenter = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: mapCenter, span: span)
        map.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
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

extension ViewController : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            map.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }

}

