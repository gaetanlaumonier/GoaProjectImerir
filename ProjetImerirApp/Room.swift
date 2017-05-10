//
//  Room.swift
//  ProjetImerirApp
//
//  Created by Student on 07/05/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class Room {
    var x:Int!
    var y:Int!
    var possibleCells:[LabyrintheViewController.Direction]?
    
    var potion:Potion?
    var bats = [StrangeBat]()
    var hasSpikes:Bool?
    
    
    init(x:Int,y:Int){
        self.x = x
        self.y = y
        
        if drand48() < 0.2 {
            potion = Potion()
        }
        
        let rand = drand48()
        
        if rand < 1/27 {
            bats.append( StrangeBat() )
        }
        if rand < 1/9 {
            bats.append( StrangeBat() )
        }
        if rand < 1/3 {
            bats.append( StrangeBat() )
        }
    }
}
