//
//  SomeHelp.swift
//  ProjetImerirApp
//
//  Created by Student on 25/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class SomeHelp: Bonus {
    
    override func onInit() {
        self.msg = "La main divine !"
    }
    
    override func onBonusPicked() {
        super.onBonusPicked()
        rangementView.controller.someHelp()
    }
}
