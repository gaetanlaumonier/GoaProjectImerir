//
//  DesignableView.swift
//  GoaProject
//
//  Created by Student on 03/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

@IBDesignable class DesignableView: UIView {
    
    //Change dynamiquement par l'interface graphique le cornerRadius de la view
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius * UIScreen.main.bounds.width / 500.0
        }
    }
    
    //Change dynamiquement par l'interface graphique le borderWidth de la view
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet{
            self.layer.borderWidth = borderWidth * UIScreen.main.bounds.width / 500.0
        }
    }
    
    //Change dynamiquement par l'interface graphique le borderColor de la view
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet{
            self.layer.borderColor = borderColor.cgColor
            
        }
    }
}
