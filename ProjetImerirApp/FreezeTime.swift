//
//  FreezeTime.swift
//  ProjetImerirApp
//
//  Created by Student on 25/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class FreezeTime: Bonus {
    
    override func onInit() {
        self.msg = "Le temps s'est arrêté !"
    }
    
    override func onBonusPicked() {
        super.onBonusPicked()
        rangementView.controller.freezeTime()
    }
}
