//
//  GenericResponse.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 23/06/17.
//
//

import Foundation
import ObjectMapper

class GenericResponse<T: Mappable>: Mappable {
    
    var status : Int?
    var message : String?
    var data : T?
    var arrayData: [T]?
    var error : String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
        arrayData <- map["data"]
        error <- map["error"]
    }
}
