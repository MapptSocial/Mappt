//
//  UserNotification.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 23/05/17.
//
//

import UIKit
import ObjectMapper

class UserNotification: Mappable {

    var message : String?
    var notification_type : Int?
    var userMetadata: String?
    var postMetadata: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        message <- map["message"]
        notification_type <- map["notification_type"]
        userMetadata <- map["metadata"]
        postMetadata <- map["metadata"]
    }
}
