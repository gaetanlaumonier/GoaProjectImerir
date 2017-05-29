//
//  StrangeBat.swift
//  ProjetImerirApp
//
//  Created by Student on 07/05/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class StrangeBat {
    var speed: Double!
    var name: String!
    
    init() {
        let rand = drand48()
        
        if rand < 0.33 {
            self.name = "BeteRouge"
            self.speed = 2.3
        } else if rand < 0.66 {
            self.name = "BeteVerte"
            self.speed = 1.5
        } else {
            self.name = "BeteGrise"
            self.speed = 1.8
        }
    }
}
