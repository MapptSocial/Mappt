//
//  LoginVC.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 23/05/17.
//
//

import UIKit
import FBSDKLoginKit
import FirebaseInstanceID
import ObjectMapper

class LoginVC: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.addStatusBar()
        self.addHorizontalLine()

        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance().clientID = "585737309112-qka557ppl9c03aq2ocpbjrbkh5rak2ce.apps.googleusercontent.com"
//        GIDSignIn.sharedInstance().signInSilently()
    }
    
    @IBAction func faceBookLogin(_ sender: UIButton) {
        if ApiClient.isInternetAvailable() {
            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            fbLoginManager.loginBehavior = .web
            
            fbLoginManager.logIn(withReadPermissions: ["public_profile","email"], from: self) { (result, error) in
                if (error == nil){
                    let fbloginresult : FBSDKLoginManagerLoginResult = result!
                    if fbloginresult.grantedPermissions != nil {
                        if(fbloginresult.grantedPermissions.contains("email"))
                        {
                            self.showLoader()
                            self.returnUserData()
                        }
                    }
                }
            }
        } else {
            self.view.makeToast("Internet connection available", duration: 0.3, position: .bottom)
        }
    }
    
    @IBAction func googleLogin(_ sender: UIButton) {
        if ApiClient.isInternetAvailable() {
            GIDSignIn.sharedInstance().signIn()
        } else {
            self.view.makeToast("Internet connection available", duration: 0.3, position: .bottom)
        }
    }

    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,picture.type(large),gender"], tokenString: FBSDKAccessToken.current().tokenString, version: nil, httpMethod: "GET")
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil)
            {
                // Process error
                print("Error: \(String(describing: error))")
            }
            else
            {
                //                ["fields":"email,name,gender,about,birthday,picture"],
                let data = result as! NSDictionary
                print("fetched user: \(String(describing: result))")
                let fullname : NSString = data.value(forKey: "name") as! NSString
                let userEmail : NSString = data.value(forKey: "email") as! NSString
                let gender : NSString = data.value(forKey: "gender") as! NSString
                let facebookId  = data.value(forKey: "id") as! NSString
                let profilePicString: NSString = ((data.value(forKey: "picture") as! NSDictionary).value(forKey: "data") as! NSDictionary).value(forKey: "url") as! NSString
                
                var genderInt = Int()
                if gender == "male" {
                    genderInt = 1
                }
                else if gender == "female" {
                    genderInt = 2
                }
                
                var params : [String: Any] = [
                    "full_name": fullname,
                    "mobile":"",
                    "email": userEmail,
                    "username":"",
                    "password":"password",
                    "profile_pic": profilePicString,
                    "gender": genderInt,
                    "device_type": 2, // 2 ios
                    "login_type": 1, // 1 facebook // 2 gmail
                    "social_id": facebookId,
                    "device_version": UIDevice.current.systemVersion,
                ]
                
                if let token = FIRInstanceID.instanceID().token() {
                    params.updateValue(token, forKey: "fcm_token")
                }
                self.register(params)
            }
        })
    }
    
    // MARK: GIDSignInDelegate
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print(err)
        }
        else {
            self.showLoader()
            let googleId : String = user.userID                  // For client-side use only!
            let fullName : String = user.profile.name
            let email : String = user.profile.email
            let profilePic : NSURL = user.profile.imageURL(withDimension: 500) as NSURL
            let profileString : String = profilePic.absoluteString!
            
            var params : [String : Any] = [
                "full_name": fullName,
                "mobile":"",
                "email": email,
                "username":"",
                "password":"password",
                "profile_pic": profileString,
                "device_type": 2, // 2 ios
                "login_type": 2, // 1 facebook // 2 gmail
                "social_id": googleId,
                "device_version": UIDevice.current.systemVersion
            ]
            
            if let token = FIRInstanceID.instanceID().token() {
                params.updateValue(token, forKey: "fcm_token")
            }
            self.register(params)
        }
    }
    
    func register(_ params: [String: Any]) {
        ApiClient.shared.registerUser(ApiClient.shared.register, params: params, completioHandler: { (response) in
            self.dismissLoader()
            print(response)
            
            if response is Error {
                self.view.makeToast("Server problem")
            }else {
                let user: GenericResponse = Mapper<GenericResponse<User>>().map(JSONObject: response)!
                if user.status == 1 {
                    
                    if let token = user.data?.token {
                        UserDefaults.standard.set(token, forKey: "token")
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                        ApiClient.shared.token = String(describing: token)
                        ApiClient.shared.headers = ["Authorization" : token]
                        let userString = self.jsonObjectToString(response as! [String : Any])
                        UserDefaults.standard.set(userString, forKey: "savedUser")
                        UserDefaults.standard.set(user.data?.id!, forKey: "user_id")
                        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeVC")
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        })
    }


}
