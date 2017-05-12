//
//  Potion.swift
//  ProjetImerirApp
//
//  Created by Student on 07/05/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class Potion {
    var health: Int!
    var scale:CGFloat!
    
    init() {
        self.health = 1 + Int(arc4random_uniform(5))
        self.scale = 0.5 + CGFloat(drand48())
    }
}
