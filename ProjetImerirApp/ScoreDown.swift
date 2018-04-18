//
//  ScoreDown.swift
//  ProjetImerirApp
//
//  Created by Student on 25/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class ScoreDown: Bonus {
    var score: Int!
    
    override func onInit() {
        score = Int(arc4random_uniform(4)+2)
        self.color = UIColor.red
        self.msg = "Score diminué !"
    }
    
    override func onBonusPicked() {
        super.onBonusPicked()
        rangementView.controller.scoreDown(score: score)
    }
}
