//
//  UnderlinedTextView.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 12/05/17.
//
//

import UIKit

class UnderlinedTextView: UITextView {
    
    var lineHeight: CGFloat = 15

    
    override var font: UIFont? {
        didSet {
            if let newFont = font {
                lineHeight = newFont.lineHeight
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        
        let numberOfLines = Int(rect.height / lineHeight)
        let topInset = textContainerInset.top
        
        for i in 1...numberOfLines {
            let y = topInset + CGFloat(i) * lineHeight
            
            let line = CGMutablePath()
            line.move(to: CGPoint(x: 0.0, y: y))
            line.addLine(to: CGPoint(x: rect.width, y: y))
            ctx?.addPath(line)
        }
        ctx?.setStrokeColor(UIColor(red: 236, green: 29, blue: 41).cgColor)
        ctx?.strokePath()
        
        super.draw(rect)
    }
}
