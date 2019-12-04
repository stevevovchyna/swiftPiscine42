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
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController, MKMapViewDelegate, GMSAutocompleteFetcherDelegate {
    
    var fetcher: GMSAutocompleteFetcher?
    var placesClient: GMSPlacesClient?
    var token: GMSAutocompleteSessionToken?
    
    let locationManager = CLLocationManager()
    var chosenStartLocation: GMSPlace?
    var chosenEndLocation: GMSPlace?
    var startAnnotation: MKAnnotation?
    var endAnnotation: MKAnnotation?
    
    var currentUserLocation : CLLocationCoordinate2D?
    
    var startIsCurrentActiveTextField: Bool?

    @IBOutlet weak var map: MKMapView!
    
    var addressTableView : AddressTableView?
    
    @IBOutlet weak var startPointText: UITextField!
    @IBOutlet weak var endPointText: UITextField!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var buildRouteButton: UIButton!
    @IBOutlet weak var sideStartTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomStartTextFieldCOnstraint: NSLayoutConstraint!
    @IBOutlet weak var navigationLabelsView: UIView!
    
    var accessoryDoneButton: UIBarButtonItem!
    let accessoryToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        overrideUserInterfaceStyle = .dark
        token = GMSAutocompleteSessionToken.init()
        fetcher = GMSAutocompleteFetcher()
        fetcher?.delegate = self
        fetcher?.provide(token)
        placesClient = GMSPlacesClient()

        accessoryDoneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.donePressed))
        accessoryToolBar.items = [self.accessoryDoneButton]
        startPointText.inputAccessoryView = self.accessoryToolBar
        endPointText.inputAccessoryView = self.accessoryToolBar
        
        startPointText.backgroundColor = #colorLiteral(red: 0.8191205538, green: 0.8191205538, blue: 0.8191205538, alpha: 0.8)
        endPointText.backgroundColor = #colorLiteral(red: 0.8191205538, green: 0.8191205538, blue: 0.8191205538, alpha: 0.8)
        
        buildRouteButton.layer.cornerRadius = 5
        currentLocationButton.layer.cornerRadius = 5

        buildRouteButton.isHidden = true

        addressTableView = AddressTableView(frame: CGRect(), style: UITableView.Style.plain)
        
        map.delegate = self
        map.showsUserLocation = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

    }
    
    @objc func donePressed() {
        view.endEditing(true)
    }
    
    @IBAction func buildRouteButtonPressed(_ sender: UIButton) {
        if chosenStartLocation == chosenEndLocation {
            let alert = UIAlertController(title: "Error", message: "Please fill in two different locations", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Got it", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: chosenStartLocation!.coordinate, addressDictionary: nil))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: chosenEndLocation!.coordinate, addressDictionary: nil))
            request.requestsAlternateRoutes = false
            request.transportType = .automobile

            let directions = MKDirections(request: request)

            directions.calculate { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }
                for route in unwrappedResponse.routes {
                    self.map.addOverlay(route.polyline)
                    for step in route.steps {
                        
                        
                        
//                        print(step.instructions)
                        
                        
                        
                    }
                    self.map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1.0)
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else {
            let annotationView = MKMarkerAnnotationView()
            annotationView.animatesWhenAdded = true
            annotationView.markerTintColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1.0)
            annotationView.glyphImage = UIImage(named: "cybertruck")
            annotationView.selectedGlyphImage = UIImage(named: "cybertruck")
            return annotationView
        }
    }
    
    @IBAction func startPointEditingDidEnd(_ sender: UITextField) {
        startIsCurrentActiveTextField = nil
    }
    
    @IBAction func startPointEditingDidChange(_ sender: UITextField) {
        if startPointText.text! != "" {
            startIsCurrentActiveTextField = true
            fetcher?.sourceTextHasChanged(startPointText.text!)
        } else {
            if let annotaionToDelete = startAnnotation {
                map.removeAnnotation(annotaionToDelete)
                startAnnotation = nil
            }
            map.removeOverlays(map.overlays)
            
            buildRouteButton.isHidden = true
            startIsCurrentActiveTextField = nil
            addressTableView?.removeFromSuperview()
        }
    }
    
    @IBAction func startPointEdidtingDidBegin(_ sender: UITextField) {
        showAddressTable(addresses: [], textField: startPointText, isStartLocation: true)
    }
    
    @IBAction func endPointEditingDidBegin(_ sender: UITextField) {
        showAddressTable(addresses: [], textField: endPointText, isStartLocation: false)
    }
    
    
    @IBAction func endPointEditingDidEnd(_ sender: UITextField) {
        startIsCurrentActiveTextField = nil
    }
    
    @IBAction func endPointEditingDidChange(_ sender: UITextField) {
        if endPointText.text! != "" {
            startIsCurrentActiveTextField = false
            fetcher?.sourceTextHasChanged(endPointText.text!)
        } else {
            if let annotaionToDelete = endAnnotation {
                map.removeAnnotation(annotaionToDelete)
                endAnnotation = nil
            }
            map.removeOverlays(map.overlays)
            
            buildRouteButton.isHidden = true
            startIsCurrentActiveTextField = nil
            addressTableView?.removeFromSuperview()
        }
    }
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        if let booleanCheck = startIsCurrentActiveTextField {
            let textField = booleanCheck ? startPointText! : endPointText!
            showAddressTable(addresses: predictions, textField: textField, isStartLocation: booleanCheck)
        }
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        print(error.localizedDescription)
    }
    
    func showAddressTable(addresses: [GMSAutocompletePrediction], textField: UITextField, isStartLocation: Bool) {
        
        let x = sideStartTextFieldConstraint.constant
        var y = endPointText.frame.origin.y + navigationLabelsView.frame.origin.y
        let width = startPointText.bounds.width
        var height = CGFloat((55 * addresses.count) + 110)
        
        if !isStartLocation {
            y = endPointText.frame.origin.y + navigationLabelsView.frame.origin.y + endPointText.frame.size.height + 8
        }
        
        if addresses.count == 0 {
            height = 110
        }
        
        let boundRect = CGRect(x: x, y: y, width: width, height: height)
        
        addressTableView?.removeFromSuperview()
        addressTableView = AddressTableView(frame: boundRect, style: UITableView.Style.plain)
        addressTableView!.addresses = addresses
        addressTableView!.placesClient = placesClient
        addressTableView!.delegate = addressTableView
        addressTableView!.dataSource = addressTableView
        addressTableView!.currentUserLocation = currentUserLocation
        addressTableView!.textField = textField
        addressTableView!.isStartLocation = isStartLocation ? true : false
        addressTableView?.delegator = self
        view.addSubview(addressTableView!)
    }
    
    func focusMapViewAndSetPin(placemarkID: String, textField: UITextField, isStartLocation: Bool) {
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.all.rawValue))!
        placesClient!.fetchPlace(fromPlaceID: placemarkID, placeFields: fields, sessionToken: nil) { (fetchedPlacemark, error) in
            if let error = error {
              print("An error occurred: \(error.localizedDescription)")
              return
            }
            if let currentPlacemark = fetchedPlacemark {
                let latitude = currentPlacemark.coordinate.latitude
                let longitude = currentPlacemark.coordinate.longitude
                if isStartLocation {
                    if let annotaionToDelete = self.startAnnotation {
                        self.map.removeAnnotation(annotaionToDelete)
                    }
                } else {
                    if let annotaionToDelete = self.endAnnotation {
                        self.map.removeAnnotation(annotaionToDelete)
                    }
                }
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                annotation.title = currentPlacemark.name
                annotation.subtitle = currentPlacemark.formattedAddress
                self.map.addAnnotation(annotation)
                if isStartLocation {
                    self.startAnnotation = annotation
                    self.chosenStartLocation = currentPlacemark
                } else {
                    self.endAnnotation = annotation
                    self.chosenEndLocation = currentPlacemark
                }
                let mapCenter = CLLocationCoordinate2DMake(latitude, longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let region = MKCoordinateRegion(center: mapCenter, span: span)
                self.map.setRegion(region, animated: true)
                if isStartLocation {
                    self.startPointText.resignFirstResponder()
                } else {
                    self.endPointText.resignFirstResponder()
                }
                if let _ = self.startAnnotation, let _ = self.endAnnotation {
                    self.buildRouteButton.isHidden = false
                } else {
                    self.buildRouteButton.isHidden = true
                }
            }
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
            
            currentUserLocation = location.coordinate
            
            locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }

}


