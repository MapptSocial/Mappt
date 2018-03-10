//
//  WishlistVC.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 12/05/17.
//
//

import UIKit
import ObjectMapper

class WishlistVC: UIViewController {

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
        getWishlist(ApiClient.shared.newWishList)
        self.post = [Home]()
    }

    func onTextChange(_ input: String) {
        
        let trimInput = input.trimmingCharacters(in: .whitespaces)
        if trimInput.characters.count > 0  {
            let url = ApiClient.shared.newWishList + trimInput
            getWishlist(url)
        }else {
            getWishlist(ApiClient.shared.newWishList)
        }
    }
    
    func getWishlist(_ url: String) {
        self.showLoader()
        ApiClient.shared.getWishlist(url) { (response) in
            DispatchQueue.main.async {
                self.dismissLoader()
            }
            let home: GenericResponse = Mapper<GenericResponse<Home>>().map(JSONObject: response)!
            if home.status ==  1 {
                DispatchQueue.main.async {
                    self.post = home.arrayData!
                    print(self.post.count)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func addWishList(_ sender: UIButton) {
        self.showLoader()
        let url = ApiClient.shared.addWishList + "/" + String(self.post[sender.tag].id)
        
        ApiClient.shared.addToWishlist(url) {(response) in
            self.dismissLoader()
            self.post.remove(at: sender.tag)
            self.tableView.reloadData()
        }
    }
}

extension WishlistVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.post.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wishListCell", for: indexPath) as! WishListCell

        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: #selector(addWishList(_:)), for: .touchUpInside)

        if self.post.count > 0 {
            cell.wishlistPlace.text = self.post[indexPath.row].caption!
            cell.wishlistAdress.text = self.post[indexPath.row].formatted_address!
            cell.wishlistCount.text = String(self.post[indexPath.row].wishlistCount) + " added"
        }
        return cell
    }
    
}

extension UIViewController  {
    
    func addHorizontalLine() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.5))
        label.backgroundColor = UIColor.gray
        self.view.addSubview(label)
        label.addDropShadow()
    }
}
