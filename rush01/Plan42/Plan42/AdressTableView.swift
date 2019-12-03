//
//  AdressTableView.swift
//  Plan42
//
//  Created by Steve Vovchyna on 03.12.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit
import MapKit

class AddressTableView: UITableView {

    var addresses: Array<CLPlacemark> = []
    var textField: UITextField!
    var chosenPointPlacemark: CLPlacemark!
    var delegator: ViewController!
    
    override init(frame: CGRect, style: UITableView.Style) {
      super.init(frame: frame, style: style)
        self.register(UITableViewCell.self, forCellReuseIdentifier: "AddressCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddressTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath)
        cell.textLabel?.numberOfLines = 3
        
        if addresses.count > indexPath.row {
            let address = addresses[indexPath.row]
            cell.textLabel?.text = "\(address.name ?? ""), \(address.administrativeArea ?? ""), \(address.country ?? "")"
        } else {
            cell.textLabel?.text = "None of the above"
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count + 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if addresses.count > indexPath.row {
            let address = addresses[indexPath.row]
            textField.text = "\(address.name ?? ""), \(address.administrativeArea ?? ""), \(address.country ?? "")"
            chosenPointPlacemark = address
            delegator.focusMapViewAndSetPin(placemark: address)
        }
        tableView.removeFromSuperview()
    }
}
