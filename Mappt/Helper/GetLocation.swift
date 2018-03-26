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

class GetLocation: NSObject {

    let locManager = CLLocationManager()
    var callback: ((Typealiases.JSONDict?) -> ())!

    override init() {
        super.init()
        locManager.delegate = self
    }

    func getAddress(completion: @escaping (Typealiases.JSONDict?) -> ()) {
        locManager.requestWhenInUseAuthorization()
        guard CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse else {
            completion(nil)
            return
        }
        self.callback = completion
        locManager.requestLocation()
    }
}

extension GetLocation: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let callback = callback else {
            return
        }
        let geoCoder = CLGeocoder()
        guard let currentLocation = locations.first else {
            callback(nil)
            return
        }
        geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) -> Void in
            if let error = error {
                print("Error getting location: \(error.localizedDescription)")
                callback(nil)
            } else if let placemark = placemarks?.first {
                var dict : [String:Any] = placemark.addressDictionary as! [String : Any]
                dict["latitude"] = currentLocation.coordinate.latitude
                dict["longitude"] = currentLocation.coordinate.longitude

                callback(dict)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let callback = callback else {
            return
        }
        print("Error getting location: \(error.localizedDescription)")
        callback(nil)
    }

}
