
//
//  HomeVC.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 13/05/17.
//
//

import UIKit
import GoogleMaps
import ObjectMapper
import Firebase
import UserNotifications

struct Location {
    let name: String
    let lat: CLLocationDegrees
    let long: CLLocationDegrees
}

class HomeVC: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var dropDown: DropMenuButton!
    
    @IBOutlet weak var profile: OutlineLabel!
    @IBOutlet weak var search: OutlineLabel!
    @IBOutlet weak var add: OutlineLabel!
    @IBOutlet weak var trending: OutlineLabel!
    @IBOutlet weak var wishList: OutlineLabel!
    
    @IBOutlet weak var profileButton: CircularButton!
    @IBOutlet weak var searchButton: CircularButton!
    @IBOutlet weak var addButton: CircularButton!
    @IBOutlet weak var trendingButton: CircularButton!
    @IBOutlet weak var wishListButton: CircularButton!

    var actualMapView: GMSMapView! = nil
    var london: GMSMarker?
    var londonView: UIImageView?
    var profileMrker : ProfileMarker?
    var bounds = GMSCoordinateBounds()
    var locations : [Home] = []
    var locationManager = CLLocationManager()
    var isProfile = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options:
            [[.alert, .sound]], completionHandler: { (granted, error) in
                // Handle Error
        })
        UNUserNotificationCenter.current().delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(sendNotification(_:)), name:  NSNotification.Name(rawValue: "localNotication"), object: nil)
        
        self.addHorizontalLine()
        addStatusBar()
        dropDown.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        dropDown.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 13.0, bottom: 0.0, right: 0.0)

        var params: [String: Any] = [:]
        
        if let token = FIRInstanceID.instanceID().token() {
            params.updateValue(token, forKey: "fcm_token")
        }
        updateApi(params)
        
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        dropDown.initMenu(["Places", "Friends"], actions: [({ () -> (Void) in
            self.isProfile = false
            if ApiClient.isInternetAvailable() {
                self.getData(ApiClient.shared.postData)
            } else {
                self.view.makeToast("Internet connection available", duration: 0.3, position: .bottom)
            }

        }), ({ () -> (Void) in
            self.isProfile = true
            if ApiClient.isInternetAvailable() {
                self.getData(ApiClient.shared.userData)
            } else {
                self.view.makeToast("Internet connection available", duration: 0.3, position: .bottom)
            }

        })])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if ApiClient.isInternetAvailable() {
            getData(ApiClient.shared.postData)
        } else {
            self.view.makeToast("Internet connection available", duration: 0.3, position: .bottom)
        }

    }
    
    func getData(_ url: String) {
        self.showLoader()
        print(url)

        ApiClient.shared.getMethod(url, headers: ApiClient.shared.headers) { (response) in
            print(response)

            DispatchQueue.main.async {
                self.dismissLoader()
            }
            if response is Error {
                self.view.makeToast("Server problem")
            }else {
                let home: GenericResponse = Mapper<GenericResponse<Home>>().map(JSONObject: response)!
                
                DispatchQueue.main.async {
                    if home.status == 1 {
                        self.locations = home.arrayData!
                        self.setupMap()
                    }
                }
            }
        }
    }
    
    
    func setupMap() {
        
        let camera = GMSCameraPosition.camera(withLatitude: 18.366334, longitude: 73.755962, zoom: 12.0)
        
        self.actualMapView = GMSMapView.map(withFrame: self.mapView.frame, camera: camera)
        self.actualMapView.delegate = self
        self.actualMapView.settings.rotateGestures = false
        self.actualMapView.settings.tiltGestures = false

        self.mapView.addSubview(self.actualMapView)
        
        for location in self.locations {
            
            if location.id == 0 {
                break
            }
            
            profileMrker = ProfileMarker(frame: CGRect(x: 0, y: 0, width: 60, height: 60))

            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: Double(location.latitude!), longitude: Double(location.longitude!))
            marker.map = self.actualMapView
            marker.appearAnimation = .pop
            marker.tracksViewChanges = false
            
            if location.source_file_type == 0 {

                if isProfile {
                    let url = ApiClient.shared.imageBaseUrl + location.profile_pic!
                    profileMrker?.profileImage.sd_setImage(with: URL(string: url))
                    createMask((profileMrker?.profileImage)!, frame: (profileMrker?.frame)!,imageName: "maskProfile")
                    marker.title = location.full_name!

                }else {
                    let url = ApiClient.shared.imageBaseUrl + location.source_file!
                    profileMrker?.profileImage.sd_setImage(with: URL(string: url))
                    createMask((profileMrker?.profileImage)!, frame: (profileMrker?.frame)!,imageName: "maskPlace")
                    marker.title = location.caption!
                }
            }
            marker.iconView = profileMrker
            bounds = bounds.includingCoordinate(marker.position)
        }
        let update = GMSCameraUpdate.fit(bounds, withPadding: 10)
        actualMapView.animate(with: update)
    }
    
    func createMask(_ imageView: UIImageView, frame: CGRect, imageName: String) {
        let mask = CALayer()
        mask.contents = UIImage(named: imageName)?.cgImage
        mask.frame = frame
        imageView.layer.mask = mask
        imageView.layer.masksToBounds = true
    }
    
    func updateApi(_ params: [String: Any]) {
        print("no of times")
        
        ApiClient.shared.updateProfileApi(ApiClient.shared.updateProfile, params: params) { (response) in
            print(response)
            if response is Error {
                self.view.makeToast("Server problem")
            }else {
                let reponse: GenericResponse = Mapper<GenericResponse<User>>().map(JSONObject: response)!
                if reponse.status == 1 {
                    let userString = self.jsonObjectToString(response as! [String : Any])
                    UserDefaults.standard.set(userString, forKey: "savedUser")
                }
            }
        }
    }
}

extension HomeVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate

        var params: [String: Any] = [
            "latitude": locValue.latitude,
            "longitude": locValue.longitude,
        ]
        if let token = FIRInstanceID.instanceID().token() {
            params.updateValue(token, forKey: "fcm_token")
        }
        locationManager.stopUpdatingLocation()
        print(params)
        updateApi(params)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}



