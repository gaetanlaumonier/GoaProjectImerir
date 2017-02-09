//
//  DesignableLabel.swift
//  GoaProject
//
//  Created by Student on 03/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

@IBDesignable class DesignableLabel: UILabel {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var fontSize: CGFloat = 12 {
        didSet{
            self.setupLabelDynamicSize(fontSize: fontSize)
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet{
            self.layer.borderColor = borderColor.cgColor
            
        }
    }
    @IBInspectable var lineSpace:CGFloat = 0 {
        didSet{
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpace
            
            let attrString = NSMutableAttributedString(string: self.text!)
            attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
            self.attributedText = attrString
            self.textAlignment = NSTextAlignment.center
        }
    }
}
