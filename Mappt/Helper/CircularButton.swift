
//
//  CircularButton.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 18/07/17.
//
//

import UIKit

class CircularButton: UIButton {

    override func awakeFromNib() {
        layer.cornerRadius = bounds.width / 2
        layer.masksToBounds = true
    }

}
