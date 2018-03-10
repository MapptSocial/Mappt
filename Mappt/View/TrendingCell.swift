//
//  TrendingCell.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 12/05/17.
//
//

import UIKit

class TrendingCell: UITableViewCell {
    
    @IBOutlet weak var trendingPlace: UILabel!
    @IBOutlet weak var trendingAdress: UILabel!
    @IBOutlet weak var trendingCount: UILabel!
    @IBOutlet weak var locationButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
