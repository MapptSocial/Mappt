//
//  TrendingVC.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 12/05/17.
//
//

import UIKit
import ObjectMapper
import MapKit

class TrendingVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleName: OutlineLabel!

    var post: [Home] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addStatusBar()
        titleName.addDropShadow()
        self.addHorizontalLine()

        addStatusBar()
        tableView.rowHeight = 80
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getTrending()
    }
    
    func getTrending() {
        self.showLoader()
        ApiClient.shared.getWishlist(ApiClient.shared.trendingList) { (response) in
            self.dismissLoader()
            let home: GenericResponse = Mapper<GenericResponse<Home>>().map(JSONObject: response)!
            
            if home.status ==  1 {
                DispatchQueue.main.async {
                    self.post = home.arrayData!
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func gotoLocation(_ sender: UIButton) {
        openMap(self.post[sender.tag].latitude!, long: self.post[sender.tag].longitude!)
    }

    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension TrendingVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.post.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trendingCell", for: indexPath) as! TrendingCell
        cell.locationButton.addTarget(self, action: #selector(gotoLocation(_:)), for: .touchUpInside)
        cell.locationButton.tag = indexPath.row
        
        if self.post.count > 0 {
            cell.trendingPlace.text = self.post[indexPath.row].caption!
            cell.trendingAdress.text = self.post[indexPath.row].formatted_address!
            cell.trendingCount.text = String(self.post[indexPath.row].wishlistCount) + " added"
        }
 
        return cell
    }

    
}
