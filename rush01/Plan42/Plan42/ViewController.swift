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

class ViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var startPointText: UITextField!
    @IBOutlet weak var endPointText: UITextField!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var buildRouteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildRouteButton.isHidden = true
        // Do any additional setup after loading the view.
    }


}

