//
//  AdressTableView.swift
//  Plan42
//
//  Created by Steve Vovchyna on 03.12.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces

class AddressTableView: UITableView {

    var addresses: [GMSAutocompletePrediction] = []
    var textField: UITextField!
    var delegator: ViewController!
    var isStartLocation: Bool!
    var currentUserLocation : CLLocationCoordinate2D?
    var placesClient: GMSPlacesClient?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
//        self.register(UITableViewCell.self, forCellReuseIdentifier: "AddressCell")
        self.register(UINib(nibName: "SearchResultsTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddressTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! SearchResultsTableViewCell

        cell.textLabel?.numberOfLines = 0
        
        if addresses.count > indexPath.row {
            let address = addresses[indexPath.row]
            DispatchQueue.main.async {
                let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.all.rawValue))!
                self.placesClient!.fetchPlace(fromPlaceID: address.placeID, placeFields: fields, sessionToken: nil) {
                    (fetchedPlacemark, error) in
                    if let place = fetchedPlacemark {
                        print(place)
                        cell.titleCellLabel?.text = place.name ?? "Unknown"
                        cell.detailCellLabel?.text = place.formattedAddress ?? "Unknown"
                    }
                }
            }
        } else {
            if indexPath.row == addresses.count + 1 {
                cell.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                cell.titleCellLabel?.text = "Current location"
                cell.titleCellLabel?.text = "Tap here to choose your location"
            } else {
                cell.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
                cell.titleCellLabel?.text = "None of the above"
                cell.detailCellLabel?.text = "Tap here to discard search results"
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count + 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if addresses.count > indexPath.row {
            let address = addresses[indexPath.row]
            let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.all.rawValue))!
            placesClient!.fetchPlace(fromPlaceID: address.placeID, placeFields: fields, sessionToken: nil) {
                (fetchedPlacemark, error) in
                if let place = fetchedPlacemark {
                    guard let placeID = place.placeID else { return }
                    self.textField.text = (place.name ?? "Unknown") + " | " + (place.formattedAddress ?? "Unknown")
                    self.delegator.focusMapViewAndSetPin(placemarkID: placeID, textField: self.textField, isStartLocation: self.isStartLocation)
                }
            }
        } else if indexPath.row == addresses.count + 1 {
            let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.all.rawValue))!
            placesClient!.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: fields) {
                (fetchedPlacemark, error) in
                if let place = fetchedPlacemark {
                    guard let placeID = place[0].place.placeID else { return }
                    self.textField.text = (place[0].place.name ?? "Unknown") + " | " +  (place[0].place.formattedAddress ?? "Unknown")
                    self.delegator.focusMapViewAndSetPin(placemarkID: placeID, textField: self.textField, isStartLocation: self.isStartLocation)
                }
            }
        }
        tableView.removeFromSuperview()
    }
}
