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
    var chosenStartLocation: CLPlacemark?
    var startAnnotaion: MKAnnotation?
    var chosenEndLocation: CLPlacemark?

    @IBOutlet weak var map: MKMapView!
    
    var addressTableView : AddressTableView?
    
    @IBOutlet weak var startPointText: UITextField!
    @IBOutlet weak var endPointText: UITextField!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var buildRouteButton: UIButton!
    @IBOutlet weak var sideStartTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomStartTextFieldCOnstraint: NSLayoutConstraint!
    @IBOutlet weak var navigationLabelsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buildRouteButton.isHidden = true
        
        startPointText.clearButtonMode = UITextField.ViewMode.whileEditing
        
        let x = sideStartTextFieldConstraint.constant
        let y = endPointText.frame.origin.y + navigationLabelsView.frame.origin.y
        let width = startPointText.bounds.width
        let height = view.frame.size.height / 2
        let boundRect = CGRect(x: x, y: y, width: width, height: height)
        
        addressTableView = AddressTableView(frame: boundRect, style: UITableView.Style.plain)

        map.delegate = self
        map.showsUserLocation = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }
    
    func showAddressTable(addresses: Array<CLPlacemark>, textField: UITextField, locationPointPlacemark: CLPlacemark?) {
        let x = sideStartTextFieldConstraint.constant
        let y = endPointText.frame.origin.y + navigationLabelsView.frame.origin.y
        let width = startPointText.bounds.width
        let height = view.frame.size.height / 2
        let boundRect = CGRect(x: x, y: y, width: width, height: height)
        
        addressTableView?.removeFromSuperview()
        addressTableView = AddressTableView(frame: boundRect, style: UITableView.Style.plain)
        addressTableView!.addresses = addresses
        addressTableView!.delegate = addressTableView
        addressTableView!.dataSource = addressTableView
        addressTableView!.textField = textField
        addressTableView!.chosenPointPlacemark = locationPointPlacemark
        addressTableView?.delegator = self
        view.addSubview(addressTableView!)
    }
    
    func focusMapViewAndSetPin(placemark: CLPlacemark) {
        let latitude = placemark.location?.coordinate.latitude
        let longitude = placemark.location?.coordinate.longitude
        
        if let annotaionToDelete = startAnnotaion {
            map.removeAnnotation(annotaionToDelete)
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        annotation.title = placemark.name
        annotation.subtitle = "\(placemark.administrativeArea ?? ""), \(placemark.country ?? "")"
        map.addAnnotation(annotation)
        startAnnotaion = annotation
        
        let mapCenter = CLLocationCoordinate2DMake(latitude!, longitude!)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: mapCenter, span: span)
        map.setRegion(region, animated: true)
        
    }
    
    @IBAction func startPointEditingDidEnd(_ sender: UITextField) {
        print("EditingDidEnd", startPointText.text!)
    }
    
    @IBAction func startPointEditingDidChange(_ sender: UITextField) {
//        print("editingDidChange", startPointText.text!)
        if startPointText.text! != "" {
            CLGeocoder().geocodeAddressString(startPointText.text!, completionHandler: {(placemarks: Array<CLPlacemark>?, error: Optional<Error>?) -> Void in
                if let placemarks = placemarks {
                    self.showAddressTable(addresses: placemarks, textField: self.startPointText, locationPointPlacemark: self.chosenStartLocation)
                } else {
                    self.showAddressTable(addresses: [], textField: self.startPointText, locationPointPlacemark: self.chosenStartLocation)
                }
            })
        } else {
            if let annotaionToDelete = startAnnotaion {
                map.removeAnnotation(annotaionToDelete)
                startAnnotaion = nil
            }
            addressTableView?.removeFromSuperview()
        }
    }
    
    @IBAction func startPointEdidtingDidBegin(_ sender: UITextField) {
        print("editingDidbegin", startPointText.text!)
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
        CLGeocoder().reverseGeocodeLocation(locations.last!, completionHandler: {(placemarks: Array<CLPlacemark>?, error:Optional<Error>?) -> () in
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                print(placemark.country!)
            }
        })
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }

}


