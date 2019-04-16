//
//  WKMenuPageViewController.swift
//  workDictionary
//
//  Created by Fan Wu on 11/13/18.
//  Copyright © 2018 8184. All rights reserved.
//

import UIKit

class WKMenuPageViewController: UIViewController {
    
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
    
    lazy var wkMenuPageView = WKMenuPageView(menuPages: [aaa, bbb, ccc, ddd, eee])

    var wkMenuPageViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(wkMenuPageView)
        wkMenuPageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        wkMenuPageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        wkMenuPageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        wkMenuPageViewBottomConstraint = wkMenuPageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        wkMenuPageViewBottomConstraint?.isActive = true
        
        //Add Bar Buttons
        let customView = UIBarButtonItem(title: "CCV", style: .done, target: self, action: #selector(changeCV))
        let cvVPosition = UIBarButtonItem(title: "V", style: .done, target: self, action: #selector(verticalP))
        let cvHPosition = UIBarButtonItem(title: "H", style: .done, target: self, action: #selector(horizontalP))
        let cvFactor = UIBarButtonItem(title: "F", style: .done, target: self, action: #selector(changeCVFactor))
        let menuItemHeight = UIBarButtonItem(title: "MH", style: .done, target: self, action: #selector(changeMIH))
        let menuItems = UIBarButtonItem(title: "MI", style: .done, target: self, action: #selector(changeMI))
        let indicator = UIBarButtonItem(title: "I", style: .done, target: self, action: #selector(changeI))
        let pageLayout = UIBarButtonItem(title: "PL", style: .done, target: self, action: #selector(changePL))
        navigationItem.rightBarButtonItems  = [customView, cvVPosition, cvHPosition, cvFactor, menuItemHeight, menuItems, indicator, pageLayout]
    }
    
    var switchStatus = true
    
    @objc func changeCV() {
        if switchStatus {
            let a = UIView()
            a.backgroundColor = .yellow
            wkMenuPageView.menuViewCustomView = a
        } else {
            let b = UIView()
            b.backgroundColor = .blue
            wkMenuPageView.menuViewCustomView = b
        }
        switchStatus = !switchStatus
    }
    
    @objc func verticalP() {
        if switchStatus {
            wkMenuPageView.menuCustomContainerPosition = .bottom
        } else {
            wkMenuPageView.menuCustomContainerPosition = .top
        }
        switchStatus = !switchStatus
    }

    @objc func horizontalP() {
        if switchStatus {
            wkMenuPageView.menuCustomContainerPosition = .right
        } else {
            wkMenuPageView.menuCustomContainerPosition = .left
        }
        switchStatus = !switchStatus
    }
    
    @objc func changeCVFactor() {
        if switchStatus {
            wkMenuPageView.menuCustomContainerFactor = 0.75
        } else {
            wkMenuPageView.menuCustomContainerFactor = 0.25
        }
        switchStatus = !switchStatus
    }
    
    @objc func changeMIH() {
        if switchStatus {
            wkMenuPageView.menuItemHeight = 100
        } else {
            wkMenuPageView.menuItemHeight = 50
        }
        switchStatus = !switchStatus
    }
    
    @objc func changeMI() {
        if switchStatus {
            wkMenuPageView.menuPages = []
        } else {
            wkMenuPageView.menuPages = [aaa, bbb, ccc, ddd, eee]
        }
        switchStatus = !switchStatus
    }
    
    @objc func changeI() {
        if switchStatus {
            wkMenuPageView.menuIndicationView.backgroundColor = .yellow
        } else {
            wkMenuPageView.menuIndicationView.backgroundColor = .lightGray
        }
        switchStatus = !switchStatus
    }
    
    @objc func changePL() {
        if switchStatus {
            wkMenuPageView.pageScrollDirection = .horizontal
        } else {
            wkMenuPageView.pageScrollDirection = .vertical
        }
        switchStatus = !switchStatus
    }
}
