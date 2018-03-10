//
//  AppDelegate.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 11/05/17.
//
//

import UIKit
import GoogleMaps
import Firebase
import UserNotifications
import FBSDKCoreKit

import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        configureFCM(application)
        GMSServices.provideAPIKey("AIzaSyAl9P5Ab-2--ryPXMD7uWjspD1nJD03yg4")
        
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        UIApplication.shared.statusBarStyle = .lightContent
        
        checkSession()

        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if url.scheme == "fb430387657326033" {
            return FBSDKApplicationDelegate.sharedInstance().application(
                application,open: url as URL!,sourceApplication: sourceApplication,annotation: annotation)
        }
        else{
            return GIDSignIn.sharedInstance().handle(url,sourceApplication: sourceApplication,annotation: annotation)
        }
    }
    
    // MARK: Notification handling methods for ios < 10
    private func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                             fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("%@", userInfo)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        debugPrint("didFailToRegisterForRemoteNotificationsWithError: \(error)")
    }
    
    // MARK: FCM connection methods
    
    func tokenRefreshNotification(_ notification: NSNotification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        connectToFcm()
    }
    
    
    func connectToFcm() {
        FIRMessaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(String(describing: error))")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        FIRMessaging.messaging().disconnect()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
        connectToFcm()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func configureFCM(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            FIRMessaging.messaging().remoteMessageDelegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        FIRApp.configure()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification(_:)), name: NSNotification.Name.firInstanceIDTokenRefresh, object: nil)
    }
    
    func checkSession() {
        if (UserDefaults.standard.bool(forKey: "isUserLoggedIn") != true) {
            self.window?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC")
        } else {
            self.window?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeVC")
        }
    }
    
}

extension AppDelegate : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices.
    
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        let response = remoteMessage.appData
        let jsonText = response[AnyHashable("body")] as! String
        var userData: [String: String] = [:]
        
        if let data = jsonText.data(using: String.Encoding.utf8) {
            do {
                let dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                if let myDictionary = dictonary
                {
                    if myDictionary["body_type"] as! Int == 1 {
                        userData["image"] = myDictionary["image"] as? String
                        userData["title"] = myDictionary["title"] as? String
                        userData["subtitle"] = ""
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "localNotication"), object: nil, userInfo: userData)
                    } else {
                        userData["image"] = myDictionary["image"] as? String
                        userData["title"] = myDictionary["title"] as? String
                        userData["subtitle"] = myDictionary["subtitle"] as? String
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "localNotication"), object: nil, userInfo: userData)
                    }
                }
            } catch let error as NSError {
                print(error)
            }
        }
    }
}
// [END ios_10_message_handling]

extension UNNotificationAttachment {
    
    /// Save the image to disk
    static func create(imageFileIdentifier: String, data: NSData, options: [NSObject : AnyObject]?) ->UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL!, withIntermediateDirectories: true, attributes: nil)
            let fileURL = tmpSubFolderURL?.appendingPathComponent(imageFileIdentifier)
            try data.write(to: fileURL!, options: [])
            let imageAttachment = try UNNotificationAttachment(identifier: imageFileIdentifier, url: fileURL!, options: options)
            return imageAttachment
        } catch let error {
            print("error \(error)")
        }
        return nil
    }
}

extension HomeVC {
    
    func sendNotification(_ notification: Notification) {
        
        let userdata = notification.userInfo as! [String: String]
        let content = UNMutableNotificationContent()
        
        guard let title =  userdata["title"]! as? String else {
            return
        }
        content.title = title
        if let address =  userdata["subtitle"]! as? String, address != "" {
            content.body = address
        } else {
            let modifiedTitle = title.replacingOccurrences(of: "started following you", with: "")
            content.title = modifiedTitle
            content.body = title
        }
        content.sound = UNNotificationSound.default()
        content.subtitle = ""
        
        guard let url = ApiClient.shared.imageBaseUrl + userdata["image"]! as? String else {
            return
        }
        guard let imageData = NSData(contentsOf:NSURL(string: url)! as URL) else {
            return
        }
        guard let attachment = UNNotificationAttachment.create(imageFileIdentifier: "image.jpg", data: imageData, options: nil) else { return
        }
        
        content.attachments = [attachment]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.6,
                                                        repeats: false)
        let identifier = "MapptLocaNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if error != nil {
                print("fuck you")
                // Something went wrong
            }
        })
    }
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension HomeVC : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        performSegue(withIdentifier: "fromNotification", sender: self)
        
//        UIApplication.shared.delegate?.window??.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationsVC")
        completionHandler()
    }
}








