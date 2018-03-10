//
//  SearchPeopleCell.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 12/05/17.
//
//

import UIKit

class SearchPeopleCell: UITableViewCell {

    @IBOutlet weak var peopleImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    
    var user: PeopleSearch? {
        didSet{
            nameLbl.text = user?.full_name
            peopleImage.sd_setImage(with: URL(string: ApiClient.shared.imageBaseUrl + (user?.profile_pic)!))
            _ = (user?.isFollowing)! ? drawFollowing() : drawFollow()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        peopleImage.layer.cornerRadius = 20
        peopleImage.clipsToBounds = true

        statusButton.layer.cornerRadius = 15
        statusButton.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func drawFollow() {
        statusButton.backgroundColor = UIColor.init(red: 68, green: 174, blue: 255)
        statusButton.setTitle("Follow", for: UIControlState())
        statusButton.setTitleColor(UIColor.white, for: UIControlState())
        statusButton.layer.borderWidth = 1.0
        statusButton.layer.borderColor = UIColor.white.cgColor
        statusButton.addDropShadow()
        statusButton.isUserInteractionEnabled = true
    }
    
    func drawFollowing() {
        statusButton.backgroundColor = UIColor.white
        statusButton.setTitle("Following", for: UIControlState())
        statusButton.setTitleColor(UIColor.gray, for: UIControlState())
        statusButton.layer.borderColor = UIColor.clear.cgColor
        statusButton.layer.shadowOpacity = 0.0
        statusButton.isUserInteractionEnabled = false
    }
    

}
