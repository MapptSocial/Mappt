
//
//  LocalLoginVC.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 01/08/17.
//
//

import UIKit
import ObjectMapper

class LocalLoginVC: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var titleName: OutlineLabel!


    override func viewDidLoad() {
        super.viewDidLoad()

        addStatusBar()
        titleName.addDropShadow()
        self.addHorizontalLine()
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        if email.text == "" {
            print("enter email")
        }
        else if password.text == "" {
            print("enter password")
        }
        else {
            if !self.validateEmail(enteredEmail: email.text!) {
                print("enter valid email")
                return
            }

            let params : [String: Any] = [
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
