//
//  RangementView.swift
//  ProjetImerirApp
//
//  Created by Student on 25/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class RangementView: UIView {
    
    var controller:RangementViewController {
        get{
            return self.next as! RangementViewController
        }
    }
}

