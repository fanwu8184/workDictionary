//
//  Extendtion.swift
//  workDictionary
//
//  Created by Fan Wu on 11/12/18.
//  Copyright © 2018 8184. All rights reserved.
//

import Foundation
import UIKit

// MARK: Double
extension Double {
    
    func toString(decimal: Int = 8) -> String {
        let value = decimal < 0 ? 0 : decimal
        var string = String(format: "%.\(value)f", self)
        
        while string.last == "0" || string.last == "." {
            if string.last == "." { string = String(string.dropLast()); break}
            string = String(string.dropLast())
        }
        return string
    }
}

// MARK: UIView
extension UIView {
    
    //start wiggle animation
    func startWiggle(wiggleBounceY: Double = 4, wiggleBounceDuration: Double = 0.12, wiggleBounceDurationVariance: Double = 0.025, wiggleRotateAngle: Double = 0.06, wiggleRotateDuration: Double = 0.1, wiggleRotateDurationVariance: Double = 0.025) {
        func randomize(interval: TimeInterval, withVariance variance: Double) -> Double {
            let random = (Double(arc4random_uniform(1000)) - 500.0) / 500.0
            return interval + variance * random
        }
        
        //Create rotation animation
        let rotationAnim = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotationAnim.values = [-wiggleRotateAngle, wiggleRotateAngle]
        rotationAnim.autoreverses = true
        rotationAnim.duration = randomize(interval: wiggleRotateDuration, withVariance: wiggleRotateDurationVariance)
        rotationAnim.repeatCount = HUGE
        
        //Create bounce animation
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        bounceAnimation.values = [wiggleBounceY, 0]
        bounceAnimation.autoreverses = true
        bounceAnimation.duration = randomize(interval: wiggleBounceDuration, withVariance: wiggleBounceDurationVariance)
        bounceAnimation.repeatCount = HUGE
        
        //Apply animations to view
        UIView.animate(withDuration: 0) {
            self.layer.add(rotationAnim, forKey: "rotation")
            self.layer.add(bounceAnimation, forKey: "bounce")
            self.transform = .identity
        }
    }
    
    //stop wiggle animation
    func stopWiggle(){ layer.removeAllAnimations() }
}

// MARK: String
extension String {
    func isValidatedEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
}
