//
//  SearchBarView.swift
//  DressHook
//
//  Created by Suraj Gaikwad on 18/04/17.
//
//

import UIKit

protocol ButtonDelegate: class {
    func onButtonTap(_ sender: String)
}

class SearchBarView: UIView, UITextFieldDelegate {
    
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searchButton: UIButton!

    var view : UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetUp()
        
        UITextField.appearance().tintColor = UIColor.init(red: 68, green: 174, blue: 255)
        roundView.layer.cornerRadius = 18
        roundView.layer.masksToBounds = true
        roundView.layer.borderColor = UIColor.init(red: 68, green: 174, blue: 255).cgColor
        roundView.layer.borderWidth = 1
        searchButton.contentEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func xibSetUp() {
        view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() ->UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SearchBarView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    weak var delegate: ButtonDelegate?
    
    @IBAction func searchPressed(_ sender: UIButton) {
        if delegate != nil {
            if textField.text != "" {
                delegate?.onButtonTap(textField.text!)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
}
