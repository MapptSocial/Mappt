//
//  ApiClient.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 22/05/17.
//
//

import UIKit
import Alamofire
import SystemConfiguration

let serverUrl = "http://stagging.awseriously.com/mappt"
let baseUrl = serverUrl + "/v2/"

class ApiClient: NSObject {
    
    static let shared = ApiClient()
    let imageBaseUrl = serverUrl + "/assets/uploads/"
    
    var headers: HTTPHeaders = ["Content-type" : "application/json"]
    var token: String = ""

    override init() {
        if UserDefaults.standard.value(forKey: "token") != nil {
            if let token: String = UserDefaults.standard.value(forKey: "token") as! String? {
                self.headers.updateValue(token, forKey: "Authorization")
            }
        }
    }

    let login: String = {
        return (baseUrl + "user/Login")
    }()
    
    let register: String = {
        return (baseUrl + "user/register")
    }()
    
    let updateLocation: String = {
        return (baseUrl + "user/location")
    }()
    
    let updateProfile: String = {
        return (baseUrl + "user/profile")
    }()
    
    let follow: String = {
        return (baseUrl + "user/follow")
    }()
    
    let unfollow: String = {
        return (baseUrl + "user/unfollow")
    }()
    
    let getNotification: String = {
        return (baseUrl + "user/notifications/count/2")
    }()
    
    let notificationList: String = {
        return (baseUrl + "user/notifications")
    }()
    
    let post: String = {
        return (baseUrl + "post")
    }()

    let postData: String = {
        return (baseUrl + "post/followingList")
    }()

    let userData: String = {
        return (baseUrl + "user/followingList")
    }()

    let profile: String = {
        return (baseUrl + "user/profile")
    }()
    
    let user: String = {
        return (baseUrl + "users")
    }()
    
    let searchUser: String = {
        return (baseUrl + "user")
    }()
    
    let blockUser = baseUrl + "user/block/"

    let placesSearch = baseUrl + "post/search/"
    let newWishList = baseUrl + "post/wishlist/top/"
    let addWishList = baseUrl + "post/wishlist"
    let trendingList = baseUrl + "post/trending"
    let normalLogin = baseUrl + "user/login"
    let signUp = baseUrl + "user/normal/register"

    func getTrendingList(_ url: String, completioHandler: @escaping (Any) -> ()) {
        getMethod(url, headers: self.headers) { (response) in
            completioHandler(response)
        }
    }

    func getNotificationsList(_ url: String, completioHandler: @escaping (Any) -> ()) {
        print(url)
        getMethod(url, headers: self.headers) { (response) in
            completioHandler(response)
        }
    }

    func deleteFromWishlist(_ url: String, params: [String: Any], completioHandler: @escaping (Any) -> ()) {
        
        deleteMethod(url, headers: self.headers, params: params) {  (response) in
            completioHandler(response)
        }
    }

    
    func addToWishlist(_ url: String, completioHandler: @escaping (Any) -> ()) {
        
        postMethod(url, headers: self.headers, params: [:]) { (response) in
            completioHandler(response)
        }
    }

    func getWishlist(_ url: String, completioHandler: @escaping (Any) -> ()) {
        getMethod(url, headers: self.headers) { (response) in
            completioHandler(response)
        }
    }
    
    func followApi(_ url: String, params: [String: Any], completioHandler: @escaping (Any) -> ()) {
        postMethod(url, headers: self.headers, params: params) { (response) in
            completioHandler(response)
        }
    }
    
    func updateProfileApi(_ url: String, params: [String: Any], completioHandler: @escaping (Any) -> ()) {
        putMethod(url, headers: self.headers, params: params) { (response) in
            completioHandler(response)
        }
    }
    
    func getPlaces(_ url: String, completioHandler: @escaping (Any) -> ()) {
        getMethod(url, headers: self.headers) { (response) in
            completioHandler(response)
        }
    }

    func getPeople(_ url: String, completioHandler: @escaping (Any) -> ()) {
        getMethod(url, headers: self.headers) { (response) in
            completioHandler(response)
        }
    }
    
    func upadateLocationApi(_ url: String, params: [String: Any], completioHandler: @escaping (Any) -> ()) {
        putMethod(url, headers: self.headers, params: params) { (response) in
            completioHandler(response)
        }
    }
    
    func getProfile(_ url: String, completioHandler: @escaping (Any) -> ()) {
        getMethod(url, headers: self.headers) { (response) in
            completioHandler(response)
        }
    }
    
    func getAllPosts(_ url: String, completioHandler: @escaping (Any) -> ()) {
        getMethod(url, headers: self.headers) { (response) in
            completioHandler(response)
        }
    }

    func createPost(_ url: String, params: [String: Any], completioHandler: @escaping (Any) -> ()) {
        
        postMethod(url, headers: self.headers, params: params) { (response) in
            completioHandler(response)
        }
    }
    
    func registerUser(_ url: String, params: [String: Any], completioHandler: @escaping (Any) -> ()) {
        
        let header = ["Content-type" : "application/json"]
        
        postMethod(url, headers: header, params: params) {(response) in
            completioHandler(response)
        }
    }
    
    func getMethod(_ url: String, headers: HTTPHeaders, completionHandler: @escaping (Any) -> ()) {
        
        Alamofire.request(url, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: headers).responseJSON { (response: DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                completionHandler(response.result.value!)
                break
            case .failure(_):
                print(response.result.error!)
                break
            }
        }
    }
    
    func postMethod(_ url: String, headers: HTTPHeaders, params: [String: Any], completionHandler: @escaping (Any) -> ()) {
        
        Alamofire.request(url, method: .post, parameters: params,encoding: JSONEncoding.default, headers: self.headers).responseJSON { (response: DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                completionHandler(response.result.value!)
                break
            case .failure(_):
                print(response.result.error!)
                break
            }
        }
    }
    
    func putMethod(_ url: String, headers: HTTPHeaders, params: [String: Any], completionHandler: @escaping (Any) -> ()) {
        
        Alamofire.request(url, method: .put, parameters: params,encoding: JSONEncoding.default, headers: self.headers).responseJSON { (response: DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                completionHandler(response.result.value!)
                break
            case .failure(_):
                print(response.result.error!)
                break
            }
        }
    }
    
    func deleteMethod(_ url: String, headers: HTTPHeaders, params: [String: Any], completionHandler: @escaping (Any) -> ()) {
        
        Alamofire.request(url, method: .delete, parameters: params,encoding: JSONEncoding.default, headers: self.headers).responseJSON { (response: DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                completionHandler(response.result.value!)
                break
            case .failure(_):
                print(response.result.error!)
                break
            }
        }
    }



    
    static func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

}
