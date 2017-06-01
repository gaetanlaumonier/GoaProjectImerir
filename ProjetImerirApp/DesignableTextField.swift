//
//  DesignableLabel.swift
//  GoaProject
//
//  Created by Student on 03/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

@IBDesignable class DesignableTextField: UITextField {
    
    //Change dynamiquement par l'interface graphique le fontSize du label
    @IBInspectable var fontSize: CGFloat = 12 {
        didSet{
            //Fonction définie dans "OutletExtension.swift"
            self.setupLabelDynamicSize(fontSize: fontSize)
        }
    }
}
