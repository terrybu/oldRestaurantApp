//
//  Venue.swift
//  Tastii
//
//  Created by Terry Bu on 1/5/16.
//  Copyright © 2016 Tastii. All rights reserved.
//

import MapKit
import Contacts

class Venue: NSObject, MKAnnotation {
    
    let name: String
    
    var id: String?
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var address: String?
    
    init(name: String, id: String) {
        self.name = name
        self.id = id
        self.coordinate = CLLocationCoordinate2D()
    }
    
    init(name: String, coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.name = name
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        super.init()
    }
    
    // annotation callout info button opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(CNPostalAddressStreetKey): self.subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
    
}