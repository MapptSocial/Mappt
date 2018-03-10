//
//  PlacesSearch.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 04/07/17.
//
//

import Foundation
import ObjectMapper

class PlacesSearch: Mappable {
    
    var id : Int?
    var source_file : String?
    var source_file_type : Int?
    var caption : String?
    var formatted_address : String?
    var latitude : Double?
    var longitude : Double?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map ["id"]
        source_file <- map ["source_file"]
        source_file_type <- map ["source_file_type"]
        caption <- map ["caption"]
        formatted_address <- map ["formatted_address"]
        latitude <- map ["latitude"]
        longitude <- map ["longitude"]
    }
}
