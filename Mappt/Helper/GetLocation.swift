//
//  GetLocation.swift
//  DressHook
//
//  Created by Suraj Gaikwad on 12/04/17.
//
//

import Foundation
import MapKit

struct Typealiases {
    typealias JSONDict = [String:Any]
}

class GetLocation {
    
    let locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    func getAdress(completion: @escaping (Typealiases.JSONDict) -> ()) {
        
        locManager.requestWhenInUseAuthorization()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){

            currentLocation = locManager.location
            
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) -> Void in
                
                if error != nil {
                    print("Error getting location: \(error)")
                } else {
                    let placeArray = placemarks as [CLPlacemark]!
                    var placeMark: CLPlacemark!
                    placeMark = placeArray?[0]
                    
                    var dict : [String:Any] = placeMark.addressDictionary as! [String : Any]
                    dict.updateValue(self.currentLocation.coordinate.latitude, forKey: "latitude")
                    dict.updateValue(self.currentLocation.coordinate.longitude, forKey: "longitude")
                    
                    completion(dict)
                }
            }
        }
        
        }
}
