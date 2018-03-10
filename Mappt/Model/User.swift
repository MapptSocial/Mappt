//
//  User.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 22/05/17.
//
//

import UIKit
import ObjectMapper

class User: Mappable {
    
    var id : Int?
    var full_name : String?
    var mobile : String?
    var email : String?
    var username : String?
    var password : String?
    var profile_pic : String?
    var gender : Int?
    var latitude : Double?
    var longitude : Double?
    var address : String?
    var is_active : Int?
    var device_type : Int?
    var login_type : Int?
    var fcm_token : String?
    var last_login : Int?
    var modified_at : Int?
    var created_at : Int?
    var token : String!
    var bio : String?
    var city_count: Int? = 0
    var state_count: Int? = 0
    var country_count: Int? = 0
    var continent_count: Int? = 0
    var followers_count: Int? = 0
    var following_count: Int? = 0
    var place_count: Int? = 0
    var isFollowing : Bool? = false

    required convenience init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        full_name <- map["full_name"]
        mobile <- map["mobile"]
        email <- map["email"]
        username <- map["username"]
        password <- map["password"]
        profile_pic <- map["profile_pic"]
        gender <- map["gender"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        address <- map["address"]
        is_active <- map["is_active"]
        device_type <- map["device_type"]
        login_type <- map["login_type"]
        fcm_token <- map["fcm_token"]
        last_login <- map["last_login"]
        modified_at <- map["modified_at"]
        created_at <- map["created_at"]
        token <- map["token"]
        bio <- map["bio"]
        city_count <- map["city_count"]
        state_count <- map["state_count"]
        country_count <- map["country_count"]
        continent_count <- map["continent_count"]
        followers_count <- map["followers_count"]
        following_count <- map["following_count"]
        place_count <- map["place_count"]
        isFollowing <- map["isFollowing"]
    }
}

