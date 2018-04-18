//
//  DesignableButton.swift
//  GoaProject
//
//  Created by Student on 03/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

@IBDesignable class DesignableButton: UIButton {
    
    //Change dynamiquement par l'interface graphique le cornerRadius du button
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius * UIScreen.main.bounds.width / 500.0
        }
    }
    
    //Change dynamiquement par l'interface graphique le borderWidth du button
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet{
            self.layer.borderWidth = borderWidth * UIScreen.main.bounds.width / 500.0
        }
    }
    
    //Change dynamiquement par l'interface graphique le borderColor du button
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet{
            self.layer.borderColor = borderColor.cgColor
            
        }
    }
    
    //Change dynamiquement par l'interface graphique le fontSize du button
    @IBInspectable var fontSize: CGFloat = 12 {
        didSet{
            //Fonction définie dans "OutletExtension.swift"
            self.setupButtonDynamicSize(fontSize: fontSize)
        }
    }
}
