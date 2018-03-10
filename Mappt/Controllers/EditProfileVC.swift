//
//  EditProfileVC.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 12/05/17.
//
//

import UIKit
import ObjectMapper
import Firebase

class CustomTransition: NSObject {
    
    class func customPresent(_ vc: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        transition.subtype = kCATransitionFromRight
        vc.view.window?.layer.add(transition, forKey: nil)
    }
    
    class func customDismiss(_ vc: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        transition.subtype = kCATransitionFromLeft
        vc.view.window?.layer.add(transition, forKey: nil)
        vc.dismiss(animated: false, completion: nil)
    }
}

class EditProfileVC: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleName: OutlineLabel!

    var profile: User! = nil
    let picker = UIImagePickerController()
    var base64 : String = ""
    var imageToShare: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addStatusBar()
        titleName.addDropShadow()
        self.addHorizontalLine()

        textView.delegate = self
        name.delegate = self
        email.delegate = self
        picker.delegate = self
        
        if profile != nil {
            if let email = profile.email, email == "" {
                self.email.isUserInteractionEnabled = true
            }else {
                self.email.isUserInteractionEnabled = false
            }
            setupUI()
        }
    }
    
    func setupUI() {
        self.name.text = self.profile.full_name!
        self.email.text = self.profile.email!
        self.textView.text = self.profile.bio!
        self.imageView.sd_setImage(with: URL(string: ApiClient.shared.imageBaseUrl + self.profile.profile_pic!))
    }
    
    @IBAction func updateProfile(_ sender: UIButton) {
        self.update()
    }
    
    @IBAction func addPicture(_ sender: UIButton) {
        self.presentAlert()
    }
    
    @IBAction func backPressesd(_ sender: UIButton) {
        CustomTransition.customDismiss(self)
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "Select Image", message: "", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.openPicker(true)
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { (_) in
            self.openPicker(false)
        }
        
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    
    func openPicker(_ isCamera: Bool) {
        picker.allowsEditing = true
        
        if isCamera {
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
                picker.sourceType = .camera
                picker.cameraCaptureMode = .photo
                self.present(picker, animated: true, completion: nil)
                
            }else {
                print("cant open camera")
            }
        } else {
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
            
        }
    }
    
    func update() {
        var params: [String: Any] = [:]
        
        if (self.name.text?.characters.count)! > 0 {
            params.updateValue(self.name.text!, forKey:"full_name")
            
        }else {
            self.view.makeToast("Enter Name", duration: 0.4, position: .bottom)
            return
        }
        
        if (self.email.text?.characters.count)! > 0 {
            params.updateValue(self.email.text!, forKey:"email")
        }
        
        if (self.textView.text?.characters.count)! > 0 {
            params.updateValue(self.textView.text!, forKey:"bio")
        }
        if let token = FIRInstanceID.instanceID().token() {
            params.updateValue(token, forKey: "fcm_token")
        }
        
        if imageToShare != nil {
            self.showLoader()
            DispatchQueue.global().async {
                let imageData = UIImagePNGRepresentation(self.imageToShare!)
                self.base64 = (imageData?.base64EncodedString(options: .init(rawValue: 0)))!
                DispatchQueue.main.async {
                    params.updateValue(self.base64, forKey:"profile_pic")
                    if ApiClient.isInternetAvailable() {
                        self.updateApi(params)
                    } else {
                        self.view.makeToast("Internet connection available", duration: 0.3, position: .bottom)
                    }
                }
            }
        }else {
            if ApiClient.isInternetAvailable() {
                self.showLoader()
                self.updateApi(params)
            } else {
                self.view.makeToast("Internet connection available", duration: 0.3, position: .bottom)
            }
        }
    }
    
    func updateApi(_ params: [String: Any]) {

        ApiClient.shared.updateProfileApi(ApiClient.shared.updateProfile, params: params) { (response) in
            
            self.dismissLoader()
            print(response)
            if response is Error {
                self.view.makeToast("Server problem")
            }else {
                let reponse: GenericResponse = Mapper<GenericResponse<User>>().map(JSONObject: response)!
                if reponse.status == 1 {
                    let userString = self.jsonObjectToString(response as! [String : Any])
                    UserDefaults.standard.set(userString, forKey: "savedUser")
                    CustomTransition.customDismiss(self)
                }
            }
        }
    }
}

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            let scaledImage = image.resizeImageWith(CGSize(width: 200, height: 200))
            self.imageView.image = scaledImage
            self.imageToShare = scaledImage
            
        } else{
            print("Something went wrong")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
