//
//  SearchPlacesVC.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 12/05/17.
//
//

import UIKit
import ObjectMapper

class SearchPlacesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var places: [PlacesSearch] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 90
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if ApiClient.isInternetAvailable() {
            getPlacesList(ApiClient.shared.placesSearch)
        } else {
            self.view.makeToast("Internet connection available", duration: 0.3, position: .bottom)
        }
    }
    
    func onTextChange(_ input: String) {
        let trimInput = input.trimmingCharacters(in: .whitespaces)
        if trimInput.characters.count > 0  {
            let url = ApiClient.shared.placesSearch + trimInput
            getPlacesList(url)
        } else {
            getPlacesList(ApiClient.shared.placesSearch)
        }
    }
    
    func getPlacesList(_ url: String) {
        self.showLoader()
        
        ApiClient.shared.getPlaces(url) { (response) in
            print(response)
            let result: GenericResponse = Mapper<GenericResponse<PlacesSearch>>().map(JSONObject: response)!
            DispatchQueue.main.async {
                self.dismissLoader()
            }
            if result.status ==  1 {
                DispatchQueue.main.async {
                self.places = result.arrayData!
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
                }
            }
        }
    }
    
    func locationTapped(_ sender: UIButton) {
        openMap(self.places[sender.tag].latitude!, long: self.places[sender.tag].longitude!)
    }
}

extension SearchPlacesVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchPlaces", for: indexPath) as! SearchPlacesCell
        
        cell.locationButton.tag = indexPath.row
        cell.locationButton.addTarget(self, action: #selector(locationTapped(_:)), for: .touchUpInside)
        
        if self.places.count > 0 {
            cell.place = self.places[indexPath.row]
        }
        return cell
    }
}
