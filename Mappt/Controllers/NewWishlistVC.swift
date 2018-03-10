//
//  NewWishlistVC.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 07/07/17.
//
//

import UIKit

class NewWishlistVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onTextChange(_ input: String) {
        print("im here in places")
        let trimInput = input.trimmingCharacters(in: .whitespaces)
        if trimInput.characters.count > 0  {
            let url = ApiClient.shared.placesSearch + trimInput
            //getPlacesList(url)
        } else {
            //getPlacesList(ApiClient.shared.placesSearch)
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
