//
//  SearchPlacesCell.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 12/05/17.
//
//

import UIKit

class SearchPlacesCell: UITableViewCell {
    
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeAddress: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    
    var place: PlacesSearch? {
        didSet{
            placeName.text = place?.caption!
            if place?.source_file_type == 1 {
                let urlString = "http://img.youtube.com/vi/\(String(describing: place?.source_file!))/0.jpg"
                placeImage.sd_setImage(with: URL(string: urlString))
            }else {
                placeImage.sd_setImage(with: URL(string: ApiClient.shared.imageBaseUrl + (place?.source_file)!))
            }
            placeAddress.text = place?.formatted_address!
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        locationButton.addDropShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
