//
//  Location.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 27/06/17.
//
//

import Foundation

class LocationModel {
    
    var latitude: Double
    var longitude: Double
    var formatted_address: String
    var city: String
    var state: String
    var country: String
    var iso_code: String
    
    init(latitude: Double, longitude: Double, formatted_address: String, city: String, state: String, country: String, iso_code: String) {
    
        self.latitude = latitude
        self.longitude = longitude
        self.formatted_address = formatted_address
        self.city = city
        self.state = state
        self.country = country
        self.iso_code = iso_code
    }
}
