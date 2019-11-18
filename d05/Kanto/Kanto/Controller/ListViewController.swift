//
//  ListViewController.swift
//  Kanto
//
//  Created by Steve Vovchyna on 15.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import UIKit
import MapKit

class ListViewController: UITableViewController {
    
    var places : [Place] = [Place(title: "42", subtitle: "School 42", coordinate: CLLocationCoordinate2D(latitude: 48.896607, longitude: 2.318501), pinColor: .black), Place(title: "New-York", subtitle: "Best city ever", coordinate: CLLocationCoordinate2D(latitude: 40.741895, longitude: -73.989308), pinColor: .blue), Place(title: "Kyiv", subtitle: "The best city ever", coordinate: CLLocationCoordinate2D(latitude: 50.4500336, longitude: 30.5241361), pinColor: .green), Place(title: "Stonehenge", subtitle: "Mysterious one", coordinate: CLLocationCoordinate2D(latitude: 51.1788293, longitude: -1.826183), pinColor: .cyan)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mapTab = tabBarController?.viewControllers![1] as! SecondViewController
        mapTab.places = places
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath)

        cell.textLabel?.text = places[indexPath.row].title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapTab = tabBarController?.viewControllers![1] as! SecondViewController
        mapTab.fromList = true
        mapTab.selectedPlace = places[indexPath.row]
        tabBarController?.selectedIndex = 1
    }
}
