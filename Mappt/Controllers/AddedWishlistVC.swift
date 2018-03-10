//
//  AddedWishlistVC.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 07/07/17.
//
//

import UIKit
import ObjectMapper

class AddedWishlistVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var post: [Home] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getWishlist(ApiClient.shared.addWishList)
    }
    
    func onTextChange(_ input: String) {
//        print("im here in places")
//        let trimInput = input.trimmingCharacters(in: .whitespaces)
//        if trimInput.characters.count > 0  {
//            let url = ApiClient.shared.newWishList + input
//            getWishlist(url)
//        }else {
//            getWishlist(ApiClient.shared.newWishList)
//        }
    }
    
    func getWishlist(_ url: String) {
        if ApiClient.isInternetAvailable() {
            self.showLoader()
            ApiClient.shared.getWishlist(url) { (response) in
                DispatchQueue.main.async {
                    self.dismissLoader()
                }
                let home: GenericResponse = Mapper<GenericResponse<Home>>().map(JSONObject: response)!
                if home.status ==  1 {
                    DispatchQueue.main.async {
                        self.post = home.arrayData!
                        self.tableView.reloadData()
                    }
                }
            }
        } else {
            self.view.makeToast("Internet connection available", duration: 0.3, position: .bottom)
        }
    }
    
    func deleteWishlist(_ sender: UIButton) {
        if ApiClient.isInternetAvailable() {
            self.showLoader()
            let url = ApiClient.shared.addWishList + "/" + String(self.post[sender.tag].id)
            
            ApiClient.shared.deleteFromWishlist(url, params: [:]) { (reponse) in
                self.dismissLoader()
                self.post.remove(at: sender.tag)
                self.tableView.reloadData()
            }
            
        } else {
            self.view.makeToast("Internet connection available", duration: 0.3, position: .bottom)
        }
    }
}

extension AddedWishlistVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.post.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wishListCell", for: indexPath) as! WishListCell
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteWishlist(_:)), for: .touchUpInside)
        
        if cell.wishlistCount == nil && cell.addButton == nil {
            if self.post.count > 0 {
                cell.wishlistPlace.text = self.post[indexPath.row].caption!
                cell.wishlistAdress.text = self.post[indexPath.row].formatted_address!
            }
        }
        
        return cell
    }
    
}
