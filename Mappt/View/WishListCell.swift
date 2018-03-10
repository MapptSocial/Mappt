//
//  WishListCell.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 12/05/17.
//
//

import UIKit

class WishListCell: UITableViewCell {
    
    @IBOutlet weak var wishlistPlace: UILabel!
    @IBOutlet weak var wishlistAdress: UILabel!
    @IBOutlet weak var wishlistCount: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if deleteButton != nil {
            deleteButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            deleteButton.addDropShadow()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
