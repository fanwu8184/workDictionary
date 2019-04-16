//
//  PopoverController.swift
//  workDictionary
//
//  Created by Fan Wu on 9/12/18.
//  Copyright © 2018 8184. All rights reserved.
//

import UIKit

protocol ButtonsPopoverControllerDelegate { func popoverButtonAction(sender: UIButton) }

class ButtonsPopoverController: UIViewController {
    
    //arrangeSubview will be added to Content View if it is setted
    var arrangeSubview: UIView?
    //buttons will be added to Content View if it is setted
    var buttonTitles = [String]()
    //get the bar button item from presented view controller so that we can set things on it in here
    var popoverBarButtonItem: UIBarButtonItem?
    var delegate: ButtonsPopoverControllerDelegate?
    
    // MARK: Popover Contentview
    lazy var contentView: UIStackView = {        
        
        let arrangedSubviews = buttonTitles.map({ (title) -> UIButton in
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            return button
        })

        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        if let arrSubview = arrangeSubview {
            stackView.addArrangedSubview(arrSubview)
        }

        //STACK VIEW SETTING
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        //add padding
        let padding: CGFloat = 8
        stackView.spacing = padding
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        //enable autolayout
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    //adjust the size of popover view
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        preferredContentSize = contentView.sizeThatFits(UIView.layoutFittingCompressedSize)
    }
    
    @objc func buttonAction(sender: UIButton) {
        popoverBarButtonItem?.title = sender.currentTitle
        popoverBarButtonItem?.image = sender.currentImage
        //auto dismiss popover after a button clicked
        presentingViewController?.dismiss(animated: true)
        delegate?.popoverButtonAction(sender: sender)
    }
}
