//
//  LoginResponse.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 23/05/17.
//
//

import UIKit
import ObjectMapper

class LoginResponse: Mappable {
    
    var status : Int?
    var message : String?
    var data : User?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
    }

}
