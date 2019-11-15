//
//  SecondViewController.swift
//  Kanto
//
//  Created by Steve Vovchyna on 15.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit
import MapKit

class SecondViewController: UIViewController {
  
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var selector: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addPin(latitude: 48.896607, longitude: 2.318501, title: "Ecole 42", subtitle: "There's no place like home")
        focusMapView(lat: 48.896607, lon: 2.318501)
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
    
    func addPin(latitude: Double, longitude: Double, title: String, subtitle : String) {
        let point = MKPointAnnotation()
        point.title = title
        point.subtitle = subtitle
        point.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        map.addAnnotation(point)
    }
    
    func focusMapView(lat : Double, lon : Double) {
        let mapCenter = CLLocationCoordinate2DMake(lat, lon)
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: mapCenter, span: span)
        map.region = region
    }
    
}

