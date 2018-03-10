//
//  ProfileVC.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 13/05/17.
//
//

import UIKit
import GoogleMaps
import ObjectMapper

class ProfileVC: UIViewController {

    @IBOutlet weak var mapView: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var editBlock: UIButton!

    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var cities: UILabel!
    @IBOutlet weak var states: UILabel!
    @IBOutlet weak var countries: UILabel!
    @IBOutlet weak var continent: UILabel!
    @IBOutlet weak var placesCount: UILabel!
    @IBOutlet weak var username: OutlineLabel!

    var profile: User!
    var map: GMSMapView?
    var userId: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addHorizontalLine()
        addStatusBar()
        username.addDropShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.profileImage.addImageShadow()

        if userId != nil {
            self.followButton.isHidden = false
            self.editBlock.setTitle("Block", for: .normal)
            self.editBlock.setTitleColor(.red, for: .normal)
            let url = ApiClient.shared.profile + "/" + String(describing: userId!)
            if ApiClient.isInternetAvailable() {
                getProfile(url)
            } else {
                self.view.makeToast("Internet connection available", duration: 0.3, position: .bottom)
            }
        }
        else {
            self.followButton.isHidden = true
            showCacheProfile()
        }
    }
    
    func showCacheProfile() {
        let response: String = UserDefaults.standard.value(forKey: "savedUser") as! String
        let responseObject = self.stringToJsonObject(response)
        let user: GenericResponse = Mapper<GenericResponse<User>>().map(JSONObject: responseObject)!
        if user.status == 1 {
            self.profile = user.data
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    func getProfile(_ url: String) {
        self.showLoader()
        ApiClient.shared.getProfile(url) { (response) in
            print(response)
            self.dismissLoader()
            if response is Error {
                self.view.makeToast("Server problem")
            }else {
                let user: GenericResponse = Mapper<GenericResponse<User>>().map(JSONObject: response)!
                if user.status == 1 {
                    self.profile = user.data
                    DispatchQueue.main.async {
                        self.updateUI()
                    }
                }
            }
        }
    }
    
    func updateUI() {
        let imageUrl = ApiClient.shared.imageBaseUrl + self.profile.profile_pic!
        self.profileImage.sd_setImage(with: URL(string: imageUrl))
        self.username.text = self.profile.full_name!
        self.bioLabel.text = self.profile.bio!
        self.followersButton.setTitle(String(describing: self.profile.followers_count!) + "\n" + "Followers", for: .normal)
        self.followingButton.setTitle(String(describing: self.profile.following_count!) + "\n" + "Following", for: .normal)
        followersButton.titleLabel?.textAlignment = NSTextAlignment.center
        followingButton.titleLabel?.textAlignment = NSTextAlignment.center
        
        profile.isFollowing == true ? self.followButton.setTitle("Unfollow", for: .normal) : self.followButton.setTitle("Follow", for: .normal)

        self.cities.text = String(describing: self.profile.city_count!) + "\n" + "Cities"
        self.countries.text = String(describing: self.profile.country_count!) + "\n" + "Countries"
        self.continent.text = String(describing: self.profile.continent_count!) + "\n" + "Continents"
        self.states.text = String(describing: self.profile.state_count!) + "\n" + "States"
        self.placesCount.text = String(describing: self.profile.place_count!) + " Places"
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(self.profile.latitude!), longitude: Double(self.profile.longitude!), zoom: 12.0)

        self.map = GMSMapView.map(withFrame: self.mapView.bounds, camera: camera)
        self.map?.settings.scrollGestures = false
        self.map?.settings.rotateGestures = false
        self.map?.settings.tiltGestures = false
        self.mapView.addSubview(self.map!)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: Double(self.profile.latitude!), longitude: Double(self.profile.longitude!))
        marker.map = self.map! 
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        CustomTransition.customDismiss(self)
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
        
        if sender.titleLabel?.text! == "Block" {
            if ApiClient.isInternetAvailable() {
                self.blockUser()
            } else {
                self.view.makeToast("Internet connection available", duration: 0.3, position: .bottom)
            }
        } else if sender.titleLabel?.text! == "Edit" {
            let vc : EditProfileVC = storyboard!.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
            vc.profile = self.profile
            CustomTransition.customPresent(self)
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    @IBAction func followAction(_ sender: UIButton) {
        if sender.titleLabel?.text! == "Follow" {
            if ApiClient.isInternetAvailable() {
                followUser(ApiClient.shared.follow, status: "follow")
            } else {
                self.view.makeToast("Internet connection available", duration: 0.3, position: .bottom)
            }
            print("follow")
        } else if sender.titleLabel?.text! == "Unfollow" {
            print("Unfollow")
            if ApiClient.isInternetAvailable() {
                followUser(ApiClient.shared.unfollow, status: "unfollow")
            } else {
                self.view.makeToast("Internet connection available", duration: 0.3, position: .bottom)
            }
        }
    }
    
    func followUser(_ url: String, status: String) {
        self.showLoader()
        
        let url = url + "/" + String(describing: self.profile.id!)
        ApiClient.shared.followApi(url, params: [:]) { (response) in
            self.dismissLoader()
            print(response)

            DispatchQueue.main.async {
                if status == "follow" {
                    self.followButton.setTitle("Unfollow", for: .normal)
                }else if status == "unfollow" {
                    self.followButton.setTitle("Follow", for: .normal)
                }
            }
        }
    }
    
    func blockUser() {
        self.showLoader()
        let url = ApiClient.shared.blockUser + String(profile.id!)
        
        ApiClient.shared.postMethod(url, headers: ApiClient.shared.headers, params: [:]) { (response) in
            print(response)
            DispatchQueue.main.async {
                self.dismissLoader()
                CustomTransition.customDismiss(self)
            }
        }
    }
}

extension UIViewController {
    
    func returnUserId() -> String {
        if let userId: String = UserDefaults.standard.value(forKey: "user_id") as? String {
            return userId
        }
        return ""
    }
}
