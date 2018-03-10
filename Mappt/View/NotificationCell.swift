//
//  NotificationCell.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 12/05/17.
//
//

import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var notificationImage: UIImageView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
