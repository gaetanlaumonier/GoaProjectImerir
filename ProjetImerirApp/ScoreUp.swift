//
//  ScoreUp.swift
//  ProjetImerirApp
//
//  Created by Student on 25/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class ScoreUp: Bonus {
    var score:Int!
    
    override func onInit() {
        score = Int(arc4random_uniform(4)+2)
        self.msg = "Score augmenté !"
    }
    
    override func onBonusPicked() {
        super.onBonusPicked()
        rangementView.controller.scoreUp(score: score)
    }
}
