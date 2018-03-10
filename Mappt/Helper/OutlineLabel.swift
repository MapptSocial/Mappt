//
//  OutlineLabel.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 28/06/17.
//
//

import UIKit

class OutlineLabel: UILabel {

    var outlineWidth: CGFloat = 2
    var outlineColor: UIColor = UIColor.white
    
    override func drawText(in rect: CGRect) {
        
        let strokeTextAttributes = [
            NSStrokeColorAttributeName : outlineColor,
            NSStrokeWidthAttributeName : -1 * outlineWidth,
            ] as [String : Any]
        
        self.attributedText = NSAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
        super.drawText(in: rect)
    }
}
