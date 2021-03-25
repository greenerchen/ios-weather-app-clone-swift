//
//  NSAttributedString+textText.swift
//  WeatherApp
//
//  Created by Greener Chen on 2021/3/6.
//

import UIKit

extension NSAttributedString {
    class func attributedTimeText(_ text: String,
                                  boldFont: UIFont,
                                  formmerFont: UIFont,
                                  latterFont: UIFont)
    -> NSAttributedString? {
        let textStrings = text.split(separator: " ")
        guard let formmer = textStrings.first else { return nil }
        
        let attributedString = NSMutableAttributedString(string: String(formmer), attributes: [NSAttributedString.Key.font : formmerFont, NSAttributedString.Key.foregroundColor : UIColor.white])
        guard textStrings.count > 1 else {
            attributedString.addAttributes([NSAttributedString.Key.font : boldFont, NSAttributedString.Key.foregroundColor : UIColor.white], range: NSRange(location: 0, length: text.count))
            return attributedString
        }
        
        attributedString.append(NSAttributedString(string: String(textStrings[1]), attributes: [NSAttributedString.Key.font : latterFont, NSAttributedString.Key.foregroundColor : UIColor.white]))
        
        return attributedString
    }
    
    class func attributedText(_ text: String,
                              font1: UIFont,
                              font2: UIFont,
                              font3: UIFont)
    -> NSAttributedString? {
        let textStrings = text.split(separator: " ")
        guard let text1 = textStrings.first else { return nil }
        
        let attributedString = NSMutableAttributedString(string: String(text1), attributes: [NSAttributedString.Key.font : font1, NSAttributedString.Key.foregroundColor : UIColor.white])
        guard textStrings.count > 1 else { return attributedString }
        
        attributedString.append(NSAttributedString(string: " " + String(textStrings[1]), attributes: [NSAttributedString.Key.font : font2, NSAttributedString.Key.foregroundColor : UIColor.white]))
        guard textStrings.count > 2 else { return attributedString }
        
        attributedString.append(NSAttributedString(string: " " + String(textStrings[2]), attributes: [NSAttributedString.Key.font : font3, NSAttributedString.Key.foregroundColor : UIColor.white]))
        
        return attributedString
    }
}
