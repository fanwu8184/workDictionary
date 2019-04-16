//
//  SliderWithTextFieldAndLabel.swift
//  workDictionary
//
//  Created by Fan Wu on 10/1/18.
//  Copyright © 2018 8184. All rights reserved.
//

import UIKit

class SliderWithIndicators: UIStackView {
    
    //set this up if you want UISlider to snap to values step by step
    var sliderStep: Float?
    var productName: String = ""
    var balance: Double = 0 {
        didSet {
            updateViews()
            calculateAmount()
        }
    }
    var price: Double = 0 {
        didSet {
            updateViews()
            calculateAmount()
        }
    }
    var amount: Double = 0
    var isBuy: Bool = true
    //1.2345678901234568e+16 if the number too big like this, it will cause problem
    var decimalLimit = 8
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    convenience init(sliderStep: Float, balance: Double, price: Double) {
        self.init(frame: .zero)
        self.sliderStep = sliderStep
        self.balance = balance
        self.price = price
        updateViews()
    }
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let inputValueTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = UIKeyboardType.decimalPad
        textField.placeholder = "Enter Here..."
        textField.addTarget(self, action: #selector(inputValueTextFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let slider: SUISlider = {
        let slider = SUISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.setThumbImage(UIImage(named: "blue_dollar_30"), for: .normal)
        slider.setThumbImage(UIImage(named: "Dollar-30"), for: .highlighted)
        slider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
        return slider
    }()
    
    private let paddingView: SUIView = {
        let view = SUIView()
        return view
    }()
    
    private let percentageTextField: SUITextField = {
        let textField = SUITextField()
        textField.keyboardType = UIKeyboardType.decimalPad
        textField.text = "0"
        textField.textAlignment = .center
        textField.backgroundColor = UIColor.lightGray
        textField.adjustsFontSizeToFitWidth = true
        textField.addTarget(self, action: #selector(percentageTextFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private let percentageLabel: SUILabel = {
        let label = SUILabel()
        label.text = " %"
        return label
    }()
    
    private lazy var sliderStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [slider, paddingView, percentageTextField, percentageLabel])
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        //set up their proportions
        slider.width = 40
        paddingView.width = 2
        percentageTextField.width = 10
        percentageLabel.width = 4
        return stackView
    }()
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        distribution = .fillEqually
        axis = .vertical
        addArrangedSubview(priceLabel)
        addArrangedSubview(inputValueTextField)
        addArrangedSubview(sliderStackView)
        addArrangedSubview(balanceLabel)
    }
    
    private func updateViews() {
        priceLabel.text = "Price: \(price)"
        balanceLabel.text = "\(productName) Balance: \(balance)"
    }
    
    @objc private func sliderValueDidChange(_ slider: UISlider)
    {
        if let step = sliderStep {
            if step != 0 {
                let roundedStepValue = round(slider.value / step) * step
                slider.value = roundedStepValue
            }
        }
        slider.value = (slider.value * 100).rounded() / 100
        percentageTextField.text = "\(slider.value)"
        calculateAmount()
    }
    
    @objc private func percentageTextFieldDidChange(_ textField: UITextField) {
        //make sure the textField no more than 5 charactors
        if let text = textField.text?.suffix(5) {
            if let percentage = Float(text) {
                if percentage > 100 {
                    textField.text = "100"
                } else {
                    textField.text = String(text)
                }
                slider.value = percentage
            } else {
                slider.value = 0
                textField.text = String(text)
            }
            calculateAmount()
        }
    }
    
    @objc private func inputValueTextFieldDidChange(_ textField: UITextField) {
        if price > 0 {
            guard var text = textField.text else { return }
            
            //apply decimal limit
            if let _ = Double(text) {
                let split = text.components(separatedBy: ".")
                let integer = split.first ?? ""
                let decimal = (split.count == 2) ? (split.last ?? "") : ""
                if decimal.count > decimalLimit {
                    text = "\(integer).\(decimal.prefix(decimalLimit))"
                    textField.text = text
                }
            }
            
            let number = Double(text) ?? 0
            
            if isBuy {
                //for buying
                slider.value = Float(number * price * 100 / balance)
                let sliderValue = (slider.value * 100).rounded() / 100
                percentageTextField.text = "\(sliderValue)"
                
                if (Double(text) ?? 0) > (balance / price) {
                    calculateAmount()
                } else {
                    amount = number
                }
            } else {
                //for selling
                slider.value = Float(number * 100 / balance)
                let sliderValue = (slider.value * 100).rounded() / 100
                percentageTextField.text = "\(sliderValue)"
                
                if (Double(text) ?? 0) > balance {
                    calculateAmount()
                } else {
                    amount = number
                }
            }
        }
    }
    
    func calculateAmount() {
        if price > 0 {
            if isBuy {
                //for buying
                let limit = 100000000.0  //determine decimal pplaces, number of 0 is equal to decimalLimit
                let number = balance * Double(slider.value) / 100 / price
                amount = (number * limit).rounded(.down) / limit
            } else {
                //for selling
                amount = balance * Double(slider.value) / 100
            }
            inputValueTextField.text = "\(amount)"
        }
    }
}
