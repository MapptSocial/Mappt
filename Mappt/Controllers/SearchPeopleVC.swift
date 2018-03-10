//
//  SearchPeopleVC.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 12/05/17.
//
//

import UIKit
import ObjectMapper

class SearchPeopleVC: UIViewController {
    
    var users: [PeopleSearch] = []
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ApiClient.isInternetAvailable() {
            getPeopleList(ApiClient.shared.user)
        } else {
            self.view.makeToast("Internet connection available", duration: 0.3, position: .bottom)
        }
    }

    func onTextChange(_ input: String) {
        let trimInput = input.trimmingCharacters(in: .whitespaces)
        if trimInput.characters.count > 0  {
            let url = ApiClient.shared.searchUser + "/" + trimInput
            getPeopleList(url)
        }else {
            getPeopleList(ApiClient.shared.user)
        }
    }
    
    func getPeopleList(_ url: String) {
        self.showLoader()
        
        ApiClient.shared.getPeople(url) { (response) in
            print(response)
            let result: GenericResponse = Mapper<GenericResponse<PeopleSearch>>().map(JSONObject: response)!
            DispatchQueue.main.async {
                self.dismissLoader()
            }
            if result.status ==  1 {
                DispatchQueue.main.async {
                    self.users = result.arrayData!
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func followUser(_ sender: UIButton) {
        self.showLoader()
        
        let url = ApiClient.shared.follow + "/" + String(self.users[sender.tag].id!)
        ApiClient.shared.followApi(url, params: [:]) { (response) in
            print(response)
            self.dismissLoader()
            self.users[sender.tag].isFollowing = true
            self.tableView.reloadData()
        }
    }
}

extension SearchPeopleVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchPeople", for: indexPath) as! SearchPeopleCell
        cell.statusButton.addTarget(self, action: #selector(followUser(_:)), for: .touchUpInside)
        cell.statusButton.tag = indexPath.row
        
        if self.users.count > 0 {
            cell.user = self.users[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: ProfileVC = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        vc.userId = self.users[indexPath.row].id!
        CustomTransition.customPresent(self)
        self.present(vc, animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
