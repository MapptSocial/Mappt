
//
//  SignupVC.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 23/05/17.
//
//

import UIKit
import Firebase
import ObjectMapper

class SignupVC: UIViewController {
    
    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmpassword: UITextField!
    @IBOutlet weak var titleName: OutlineLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addStatusBar()
        titleName.addDropShadow()
        self.addHorizontalLine()
    }
    
    @IBAction func signupClicked(_ sender: UIButton) {
        
        if fullname.text == "" {
            print("enter username")
        }
        else if email.text == "" {
            print("enter email")
        }
        else if password.text == "" {
            print("enter password")
        }
        else if confirmpassword.text == ""  {
            print("enter confirm password")
            
        }
        else {
            if !self.validateEmail(enteredEmail: email.text!) {
                print("enter valid email")
                return
            }
            if password.text != confirmpassword.text {
                print("Passwords didn't matched")
                return
            }
            
            let params : [String: Any] = [
                "full_name": fullname.text!,
                "email": email.text!,
                "password": password.text!,
                "device_type":1,
                "login_type":3,
                "device_version": UIDevice.current.systemVersion
                ]
            register(params)
        }
        
    }
    
    @IBAction func backClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func register(_ params: [String: Any]) {
        self.showLoader()
        ApiClient.shared.registerUser(ApiClient.shared.signUp, params: params, completioHandler: { (response) in
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

extension UIViewController {
    
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
    }
}


