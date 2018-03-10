//
//  PageVC2.swift
//  Mappt
//
//  Created by Suraj Gaikwad on 12/05/17.
//
//

import UIKit
import Pager

class PageVC2: PagerController, PagerDelegate, PagerDataSource, ButtonDelegate {
    
    @IBOutlet weak var titleName: OutlineLabel!

    var searchString = ""
    var controller1 = WishlistVC()
    var controller2 = AddedWishlistVC()
    var customView = SearchBarView()
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addStatusBar()
        titleName.addDropShadow()
        self.addHorizontalLine()
        
        self.delegate = self
        self.dataSource = self
        
        self.customView = SearchBarView(frame: CGRect(x: 0, y: 74, width: self.view.frame.width , height: 36))
        customView.delegate = self
        self.view.addSubview(customView)
        customizeTab()
        print(searchString)
        
        // Instantiating Storyboard ViewControllers
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.controller1 = storyboard.instantiateViewController(withIdentifier: "WishlistVC") as! WishlistVC
        
        self.controller2 = storyboard.instantiateViewController(withIdentifier: "AddedWishlistVC") as! AddedWishlistVC
        
        self.setupPager(tabNames: ["New", "Added"],
                        tabControllers: [controller1, controller2])
    }
    
    func didChangeTabToIndex(_ pager: PagerController, index: Int) {

        self.index = index
        if index == 0{
            customView.textField.placeholder = "Studios"
            customView.textField.text = ""
        } else if index == 1 {
            customView.textField.placeholder = "Studios"
            customView.textField.text = ""
        }
    }
    
    func onButtonTap(_ sender: String) {
        if self.index == 0 {
            self.controller1.onTextChange(sender)
        } else if self.index == 1 {
            self.controller2.onTextChange(sender)
        }
    }
    
    @IBAction func cancelClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Customising the Tab's View
    func customizeTab() {
        indicatorColor = UIColor.init(red: 68, green: 174, blue: 255)
        tabsViewBackgroundColor = .white
        startFromSecondTab = false
        centerCurrentTab = true
        tabLocation = PagerTabLocation.top
        tabHeight = 40
        tabOffset = 36
        tabWidth = self.view.frame.width/2
        fixFormerTabsPositions = false
        fixLaterTabsPosition = false
        animation = PagerAnimation.during
        selectedTabTextColor = UIColor.init(red: 68, green: 174, blue: 255)
        tabsTextFont = UIFont(name: "Nunito-Bold", size: 18)!
        tabTopOffset = 102
        tabsTextColor = UIColor.gray
    }
}
