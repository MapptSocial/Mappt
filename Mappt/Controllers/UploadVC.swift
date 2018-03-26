//
//  UploadVC.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 11/05/17.
//
//

import UIKit
import SDWebImage
import CoreLocation

class UploadVC: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var imageVideoView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleName: OutlineLabel!
    @IBOutlet weak var scrollView: UIScrollView!

    var imageToShare: UIImage? = nil
    var youtubeUrl: String = ""
    let picker = UIImagePickerController()
    var type = 0 // 1 for youtube
    var base64 : String = ""
    let loc = GetLocation()
    lazy var locationManager = CLLocationManager()
    var locationModel : LocationModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addStatusBar()
        titleName.addDropShadow()
        self.addHorizontalLine()
        
        self.imageVideoView.layer.borderColor = UIColor(red: 206, green: 207, blue: 208).cgColor
        self.imageVideoView.layer.borderWidth = 1
        
        picker.delegate = self
        textView.delegate = self
        addStatusBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    @IBAction func addPopup(_ sender: UIButton) {
        self.loadPopup()
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func createPost(_ sender: UIButton) {
        let hasCaption = !textView.text.isEmpty
        let hasPostContent = imageToShare != nil || !youtubeUrl.isEmpty
        if !(hasCaption && hasPostContent) {
            view.makeToast("Add a caption and a photo/video", duration: 0.4, position: .bottom)
            return
        }
        
        if self.locationModel != nil {
            var params : [String: Any] = [
                "source_file_type": type,
                "caption" : textView.text,
                "latitude": self.locationModel.latitude,
                "longitude":self.locationModel.longitude,
                "formatted_address": self.locationModel.formatted_address,
                "city": self.locationModel.city,
                "state":self.locationModel.state,
                "country": self.locationModel.country,
                "iso_code": self.locationModel.iso_code
            ]
            
            if type == 0 {
                self.showLoader()
                DispatchQueue.global().async {
                    if let imageToShare = self.imageToShare,
                        let imageData = UIImagePNGRepresentation(imageToShare) {
                        let encodedImage = imageData.base64EncodedString()
                        DispatchQueue.main.async {
                            self.base64 = encodedImage
                            params.updateValue(self.base64, forKey:"source_file")
                        }
                    }
                    self.createPostApi(params)
                }
            }else {
                self.showLoader()
                params.updateValue(self.youtubeUrl, forKey:"source_file")
                self.createPostApi(params)
            }

        } else {
            self.view.makeToast("Select location", duration: 0.4, position: .bottom)
        }
    }
    
    func createPostApi(_ params: [String: Any]) {
        ApiClient.shared.createPost(ApiClient.shared.post, params: params) { (response) in
            DispatchQueue.main.async {
                self.dismissLoader()
            }
            self.dismiss(animated: true, completion: nil)
            print(response)
        }

    }
    
    @IBAction func setYourLocation(_ sender: Any) {
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            self.showLoader()
            loc.getAddress { result in
                guard let result = result else {
                    self.view.makeToast("Unable to get your current location", duration: 0.4, position: .bottom)
                    return
                }
                if let city = result["City"] as? String {
                    
                    let latitude = result["latitude"] as! Double
                    let longitude = result["longitude"] as! Double
                    let state = result["State"] as! String
                    let country = result["Country"] as! String
                    let iso_code = result["CountryCode"] as! String
                    let formatted_address_array: [String] = result["FormattedAddressLines"] as! [String]
                    let formatted_address = formatted_address_array.joined(separator: " ")
                    self.locationModel = LocationModel(latitude: latitude, longitude: longitude, formatted_address: formatted_address, city: city, state: state, country: country, iso_code: iso_code)
                    self.locationLbl.text = formatted_address
                    DispatchQueue.main.async {
                        self.dismissLoader()
                    }
                }
            }
        case .notDetermined:
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            
            let alert = UIAlertController(title: "Error!", message: "GPS access is restricted. In order to use tracking, please enable GPS in the Settigs app under Privacy, Location Services.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
            
        case .restricted:
            // Nothing you can do, app cannot use location services
            break
        }
    }
    
    override func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue else { return }
        scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height + 20
    }
    
    override func keyboardWillHide(_ notification: NSNotification) {
        scrollView.contentOffset = .zero
    }

    func loadPopup() {
        let popUpVC = CameraView(nibName: "CameraView", bundle: nil)
        popUpVC.delegate = self
        self.presentPopupViewController(popUpVC, animationType: MJPopupViewAnimationFade)
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "YouTube URL", message: "Please input youtube video url", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                if let url = field.text, (field.text?.characters.count)! > 0 {
                    if self.isYoutubeLink(url) {
                        self.youtubeUrl = url
                        let youTubeId = self.getYoutubeId(url)
                        let urlString = "http://img.youtube.com/vi/\(youTubeId)/0.jpg"
                        self.imageView.sd_setImage(with: URL(string: urlString))
                    }
                }
                // store your data
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = image
            let scaledImage = image.resizeImageWith(CGSize(width: 100, height: 100))
            self.imageToShare = scaledImage
        } else{
            print("Something went wrong")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK : Youtube
    
    func getYoutubeId(_ youtubeUrl: String) -> String {
        return (URLComponents(string: youtubeUrl)?.queryItems?.first(where: { $0.name == "v" })?.value)!
    }
    
    func isYoutubeLink(_ checkString: String) -> Bool {
        let youtubeRegex = "(http(s)?:\\/\\/)?(www\\.|m\\.)?youtu(be\\.com|\\.be)(\\/watch\\?([&=a-z]{0,})(v=[\\d\\w]{1,}).+|\\/[\\d\\w]{1,})"
        let youtubeCheckResult = NSPredicate(format: "SELF MATCHES %@", youtubeRegex)
        return youtubeCheckResult.evaluate(with: checkString)
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
}

extension UIImage{
    
    func resizeImageWith(_ newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}


extension UploadVC :PopUpViewControllerDelegate {
    
    func galleryClicked() {
        self.type = 0
        openPicker(false)
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
    }
    
    func cameraClicked() {
        self.type = 0
        openPicker(true)
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
    }
    
    func youtubeClicked() {
        self.type = 1
        self.presentAlert()
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
    }
}
