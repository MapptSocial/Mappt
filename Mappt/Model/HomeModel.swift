//
//  HomeModel.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 27/06/17.
//
//

import Foundation
import ObjectMapper


class Home: Mappable {
    
    var caption : String?
    var city : String?
    var continent : String?
    var country : String?
    var formatted_address : String?
    var id : Int = 0
    var iso_code : String?
    var latitude : Double?
    var longitude : Double?
    var source_file : String?
    var source_file_type : Int = 0
    var state : String?
    var user_id : Int = 0
    var wishlistCount: Int = 0
    var profile_pic : String?
    var full_name : String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        caption <- map ["caption"]
        city <- map ["city"]
        continent <- map ["continent"]
        country <- map ["country"]
        formatted_address <- map ["formatted_address"]
        id <- map ["id"]
        iso_code <- map ["iso_code"]
        latitude <- map ["latitude"]
        longitude <- map ["longitude"]
        source_file <- map ["source_file"]
        source_file_type <- map ["source_file_type"]
        state <- map ["state"]
        user_id <- map ["user_id"]
        wishlistCount <- map ["wishlistCount"]
        full_name <- map ["full_name"]
        profile_pic <- map ["profile_pic"]

    }

}
