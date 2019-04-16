//
//  AttributedText.swift
//  workDictionary
//
//  Created by Fan Wu on 4/10/19.
//  Copyright © 2019 8184. All rights reserved.
//

import Foundation
import UIKit

class AttributedText {
    
    func makeBulletList(stringList: [String],
                        font: UIFont,
                        bullet: String? = "\u{2022}",
                        indentation: CGFloat = 20,
                        lineSpacing: CGFloat = 2,
                        paragraphSpacing: CGFloat = 12,
                        textColor: UIColor = .gray,
                        bulletColor: UIColor = .red) -> NSAttributedString {
        
        let textAttributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: textColor]
        let bulletAttributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: bulletColor]
        
        let paragraphStyle = NSMutableParagraphStyle()
        let nonOptions = [NSTextTab.OptionKey: Any]()
        paragraphStyle.tabStops = [
            NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
        paragraphStyle.defaultTabInterval = indentation
        //paragraphStyle.firstLineHeadIndent = 0
        //paragraphStyle.headIndent = 20
        //paragraphStyle.tailIndent = 1
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.headIndent = indentation
        
        let bulletList = NSMutableAttributedString()
        
        
        for (index, string) in stringList.enumerated() {
            var formattedString = ""
            var rangeForBullet: NSRange
            let nsString = NSString(string: formattedString)
            if let b = bullet {
                formattedString = "\(b)\t\(string)\n"
                rangeForBullet = nsString.range(of: b)
            } else {
                let b = "\(index + 1)."
                formattedString = "\(b)\t\(string)\n"
                rangeForBullet = nsString.range(of: b)
            }
            let attributedString = NSMutableAttributedString(string: formattedString)
            
            attributedString.addAttributes(
                [.paragraphStyle : paragraphStyle],
                range: NSMakeRange(0, attributedString.length))
            
            attributedString.addAttributes(
                textAttributes,
                range: NSMakeRange(0, attributedString.length))
            attributedString.addAttributes(bulletAttributes, range: rangeForBullet)
            bulletList.append(attributedString)
        }
        
        return bulletList
    }
}
