//
//  FreezeObjects.swift
//  ProjetImerirApp
//
//  Created by Student on 25/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class FreezeObjects: Bonus {
    
    override func onInit() {
        self.msg = "Les objets sont gelés !"
    }
    
    override func onBonusPicked() {
        super.onBonusPicked()
        rangementView.controller.freezeObjects()
    }
}
