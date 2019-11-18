//
//  Place.swift
//  Kanto
//
//  Created by Steve Vovchyna on 15.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import Foundation
import MapKit

class Place: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title : String?
    var subtitle : String?
    var pinColor : UIColor?
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D, pinColor: UIColor?) {
        
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.pinColor = pinColor
        
    }
}
