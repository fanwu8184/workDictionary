//
//  MenuPageViewController.swift
//  workDictionary
//
//  Created by Fan Wu on 11/7/18.
//  Copyright © 2018 8184. All rights reserved.
//

import UIKit

class CustomMenuView: BasicView, CustomMenuItem {
    
    var isSelected: Bool = false {
        didSet {
            backgroundColor = isSelected ? .black : .green
        }
    }
    
    override func setupViews() {
        super.setupViews()
    }
}


class MenuPageViewController: UIViewController {
    
    let menuPage = MenuPageView()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "calendar")
        return iv
    }()
    
    let button: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "calendar"), for: .normal)
        b.setTitle("Button", for: .normal)
        return b
    }()
    
    let customMenuView = CustomMenuView()
    
    let pageView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    let pageView2: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    let pageView3: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    let pageView4: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    let pageView5: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    lazy var aaa = MenuPage(title: "AAA", pageView: pageView)
    lazy var bbb = MenuPage(title: "BBB", pageView: pageView2)
    lazy var ccc = MenuPage(title: "CCC", menuView: button, pageView: pageView3)
    lazy var ddd = MenuPage(title: "DDD", menuView: imageView, pageView: pageView4)
    lazy var eee = MenuPage(title: "EEE", menuView: customMenuView, pageView: pageView5)
    
    var menuPageBottomAnchorConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        menuPage.menuPages = [aaa, bbb, ccc, ddd, eee]
    }
    
    func setupViews() {
        view.addSubview(menuPage)
        menuPage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        menuPage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        menuPage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        menuPageBottomAnchorConstraint = menuPage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        menuPageBottomAnchorConstraint?.isActive = true
        
        //Add Bar Buttons
        let maxMenuItems = UIBarButtonItem(title: "M", style: .done, target: self, action: #selector(max))
        let menuPosition = UIBarButtonItem(title: "P", style: .done, target: self, action: #selector(position))
        let updateMenu = UIBarButtonItem(title: "U", style: .done, target: self, action: #selector(update))
        let heightOfMenu = UIBarButtonItem(title: "H", style: .done, target: self, action: #selector(height))
        let changeColor = UIBarButtonItem(title: "C", style: .done, target: self, action: #selector(change))
        let menuPageHeight = UIBarButtonItem(title: "MH", style: .done, target: self, action: #selector(menuHeight))
        let horizontalBar = UIBarButtonItem(title: "UH", style: .done, target: self, action: #selector(updateBar))
        let padding = UIBarButtonItem(title: "UP", style: .done, target: self, action: #selector(updatePadding))
        let indicator = UIBarButtonItem(title: "I", style: .done, target: self, action: #selector(changeI))
        let swipingMode = UIBarButtonItem(title: "SW", style: .done, target: self, action: #selector(swiping))
        navigationItem.rightBarButtonItems  = [maxMenuItems, menuPosition, updateMenu, heightOfMenu, changeColor, menuPageHeight, horizontalBar, padding, indicator, swipingMode]
    }
    
    var switchStatus = true
    
    @objc func max() {
        if switchStatus {
            menuPage.columnsOfMenuOnScreen = 3
        } else {
            menuPage.columnsOfMenuOnScreen = 5
        }
        switchStatus = !switchStatus
    }
    
    @objc func position() {
        menuPage.isMenuBarAtTop = !menuPage.isMenuBarAtTop
    }
    
    @objc func update() {
        if switchStatus {
            menuPage.menuPages = [aaa, bbb, ccc, ddd, eee]
        } else {
            menuPage.menuPages = [ddd, ccc, eee, aaa]
        }
        switchStatus = !switchStatus
    }
    
    @objc func height() {
        if switchStatus {
            menuPage.menuBarHeight = 30
        } else {
            menuPage.menuBarHeight = 100
        }
        switchStatus = !switchStatus
    }
    
    @objc func change() {
        menuPage.menuBarBackgroundColor = .orange
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.menuPage.menuBarBackgroundColor = .clear
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.menuPage.selectedMenuColor = .black
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.menuPage.selectedMenuColor = .red
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.menuPage.notSelectedMenuColor = .yellow
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.menuPage.notSelectedMenuColor = .blue
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.menuPage.horizontalMenuBarColor = .red
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.menuPage.horizontalMenuBarColor = .lightGray
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.menuPage.menuBarExpandIndicatorColor = .red
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            self.menuPage.menuBarExpandIndicatorColor = .black
        }
    }
    
    @objc func menuHeight() {
        if switchStatus {
            menuPageBottomAnchorConstraint?.constant = -320
        } else {
            menuPageBottomAnchorConstraint?.constant = 0
        }
        switchStatus = !switchStatus
    }
    
    @objc func updateBar() {
        if switchStatus {
            menuPage.heightOfHorizontalBarInMenuBar = 0
        } else {
            menuPage.heightOfHorizontalBarInMenuBar = 4
        }
        switchStatus = !switchStatus
    }
    
    @objc func updatePadding() {
        if switchStatus {
            menuPage.paddingBetweenHorizontalBarAndMenuBarItem = 0
        } else {
            menuPage.paddingBetweenHorizontalBarAndMenuBarItem = 4
        }
        switchStatus = !switchStatus
    }
    
    @objc func changeI() {
        if switchStatus {
            menuPage.menuBarIndicationView.backgroundColor = .yellow
        } else {
            menuPage.menuBarIndicationView.backgroundColor = .lightGray
        }
        switchStatus = !switchStatus
    }
    
    @objc func swiping() {
        menuPage.swipeFactor = 0.3
        menuPage.isSwipingOutModeOn = switchStatus
        switchStatus = !switchStatus
    }
}
