//
//  DesignableLabel.swift
//  GoaProject
//
//  Created by Student on 03/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

@IBDesignable class DesignableLabel: UILabel {
    
    //Change dynamiquement par l'interface graphique le cornerRadius du label
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    //Change dynamiquement par l'interface graphique le borderWidth du label
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    //Change dynamiquement par l'interface graphique le fontSize du label
    @IBInspectable var fontSize: CGFloat = 12 {
        didSet{
            //Fonction définie dans "OutletExtension.swift"
            self.setupLabelDynamicSize(fontSize: fontSize)
        }
    }
    
    //Change dynamiquement par l'interface graphique le borderColor du label
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet{
            self.layer.borderColor = borderColor.cgColor
            
        }
    }
    
    //Change dynamiquement par l'interface graphique le lineSpace du label
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
