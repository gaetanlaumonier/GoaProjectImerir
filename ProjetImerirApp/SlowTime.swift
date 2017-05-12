//
//  SlowTime.swift
//  ProjetImerirApp
//
//  Created by Student on 25/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class SlowTime: Bonus {
    
    override func onInit() {
        self.msg = "Ralentissement du temps !"
    }
    
    override func onBonusPicked() {
        super.onBonusPicked()
        rangementView.controller.slowTime()
    }
}
