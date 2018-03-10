//
//  NotificationsVC.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 12/05/17.
//
//

import UIKit
import ObjectMapper

class NotificationsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    var notifications: [UserNotification] = []
    @IBOutlet weak var titleName: OutlineLabel!
    var user: User?
    var post: Home?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addStatusBar()
        titleName.addDropShadow()
        self.addHorizontalLine()
        topView.addDropShadow()
        
        addStatusBar()
        tableView.rowHeight = 70
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        if ApiClient.isInternetAvailable() {
            self.getNotifications()
        } else {
            self.view.makeToast("Internet connection available", duration: 0.3, position: .bottom)
        }
    }
    
    func getNotifications() {
        ApiClient.shared.getNotificationsList(ApiClient.shared.notificationList) { (response) in
            self.dismissLoader()
            print(response)
            if response is Error {
                self.view.makeToast("Server problem")
            }else {
                let notification: GenericResponse = Mapper<GenericResponse<UserNotification>>().map(JSONObject: response)!
                if notification.status == 1 {
                    self.notifications = notification.arrayData!
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension NotificationsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationCell
        DispatchQueue.main.async {

            if self.notifications[indexPath.row].notification_type! == 1 {
                let user = self.stringToJsonObject(self.notifications[indexPath.row].userMetadata!)
                self.user = Mapper<User>().map(JSON: user)
                cell.notificationLabel.text = self.notifications[indexPath.row].message!
                cell.address.text = ""
                
                if let profile = self.user?.profile_pic {
                    let url = ApiClient.shared.imageBaseUrl + profile
                    print(url)
                    cell.notificationImage.sd_setImage(with: URL(string: url))
                }
            } else if self.notifications[indexPath.row].notification_type! == 2 {
                

                let post = self.stringToJsonObject(self.notifications[indexPath.row].postMetadata!)
                self.post = Mapper<Home>().map(JSON: post)
                cell.notificationLabel.text = self.notifications[indexPath.row].message!
                cell.address.text = self.post?.formatted_address!
                
                if let profile = self.post?.source_file {
                    let url = ApiClient.shared.imageBaseUrl + profile
                    print(url)
                    cell.notificationImage.sd_setImage(with: URL(string: url))
                }
            } else {
                
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.notifications[indexPath.row].notification_type! == 1 {
            let user = self.stringToJsonObject(self.notifications[indexPath.row].userMetadata!)
            self.user = Mapper<User>().map(JSON: user)
            openMap((self.user?.latitude)!, long: (self.user?.latitude)!)

        } else if self.notifications[indexPath.row].notification_type! == 2 {
            let post = self.stringToJsonObject(self.notifications[indexPath.row].postMetadata!)
            self.post = Mapper<Home>().map(JSON: post)
            openMap((self.post?.latitude)!, long: (self.post?.latitude)!)
        } else {
            
        }
    }
}
