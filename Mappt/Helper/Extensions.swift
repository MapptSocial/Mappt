//
//  Extensions.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 12/05/17.
//
//

import UIKit
import SpinKit
import MapKit

extension UIView {
    
    func addDropShadow() {
        self.layer.masksToBounds =  false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 0.5

    }
}

extension UIImageView {
    
    func addImageShadow() {
        let shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shadowColor   = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowOpacity = 0.4
        self.layer.masksToBounds = true
        self.layer.shadowPath = shadowPath
        self.layer.cornerRadius = 65
        self.layer.shadowRadius = 2

        
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
extension UIViewController {
    
    func registerKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height
                })
            }
        }
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.view.frame.origin.y += keyboardSize.height
                })
            }
        }
    }

    func showLoader() {
//        let spinner = RTSpinKitView(style: .style9CubeGrid, color: UIColor.red)
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.isUserInteractionEnabled = true
//        hud.bezelView.color = UIColor.clear
//        hud.bezelView.style = .solidColor
//        hud.mode = .customView
//        hud.customView = spinner
//        hud.animationType = .zoom
//        spinner?.startAnimating()
    }
    
    func dismissLoader() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func addStatusBar() {
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let statusBarView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(UIScreen.main.bounds.size.width), height: statusBarHeight))
        statusBarView.backgroundColor = UIColor(red: 236, green: 29, blue: 41)
        self.view.addSubview(statusBarView)
    }
    
    
    func stringToJsonObject(_ stringToconvert: String) -> [String: Any] {
        do {
            if let data = stringToconvert.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                do {
                    return try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        return [:]
    }
    
    func jsonObjectToString(_ objectToconvert:  [String: Any]) -> NSString {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: objectToconvert, options: .prettyPrinted)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            return jsonString as NSString
        } catch {
            print(error.localizedDescription)
        }
        return NSString()
    }
    
    func openMap(_ lat: Double, long: Double) {
        let coords = CLLocationCoordinate2DMake(lat,long)
        let place = MKPlacemark(coordinate: coords)
        let mapItem = MKMapItem(placemark: place)
        mapItem.openInMaps(launchOptions: nil)
    }

}

extension UIViewController : UITextFieldDelegate {
    

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}

extension UIViewController: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        return numberOfChars < 160
    }
    
}
