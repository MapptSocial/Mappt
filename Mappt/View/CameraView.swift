//
//  CameraView.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 11/05/17.
//
//

import UIKit

protocol PopUpViewControllerDelegate {
    func galleryClicked()
    func cameraClicked()
    func youtubeClicked()
}

class CameraView: UIViewController {
    
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var galleryBtn: UIButton!
    @IBOutlet weak var youtubeBtn: UIButton!


    @IBOutlet weak var question : UILabel!
    
    var delegate : PopUpViewControllerDelegate?
    var tempQuestion : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cameraBtn.setButtonWithTextBehindImage()
        self.galleryBtn.setButtonWithTextBehindImage()
        self.youtubeBtn.setButtonWithTextBehindImage()
    }
    
    @IBAction func camera(_ sender: UIButton){
        if self.delegate != nil {
            self.delegate?.cameraClicked()
        }
    }
    
    @IBAction func gallery(_ sender: UIButton){
        if self.delegate != nil {
            self.delegate?.galleryClicked()
        }
    }
    
    
    @IBAction func youtube(_ sender: UIButton){
        if self.delegate != nil {
            self.delegate?.youtubeClicked()
        }
    }

}

public extension UIButton {
    
    func setButtonWithTextBehindImage () {
        let spacing = CGFloat(0.0)
        
        let imageSize = self.imageView?.frame.size
        self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -(imageSize?.width)!, -((imageSize?.height)! + spacing), 0.0)
        let titleSize = self.titleLabel?.frame.size
        self.imageEdgeInsets = UIEdgeInsetsMake(-((titleSize?.height)!), 0.0, 0.0, -(titleSize?.width)!)
    }
}


