//
//  PeopleSearch.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 30/06/17.
//
//

import Foundation
import ObjectMapper

class PeopleSearch: Mappable {
    
    var id : Int?
    var full_name : String?
    var profile_pic : String?
    var isFollowing : Bool?

        required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map ["id"]
        full_name <- map ["full_name"]
        profile_pic <- map ["profile_pic"]
        isFollowing <- map ["isFollowing"]

    }
}
