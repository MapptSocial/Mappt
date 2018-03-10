//
//  ProfileMarker.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 27/05/17.
//
//

import UIKit

class ProfileMarker: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commomInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commomInit()
    }
    
    private func commomInit() {
        Bundle.main.loadNibNamed("ProfileMarker", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
