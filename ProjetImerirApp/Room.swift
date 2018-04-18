//
//  Room.swift
//  ProjetImerirApp
//
//  Created by Student on 07/05/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

/// The Room class gives the possibility of accessing variables related to any room in the maze minigame.
class Room {
    
    /// X position of the room in the maze. Doesn't match the minimap if it is rotated.
    var x:Int!
    
    /// Y position of the room in the maze. Doesn't match the minimap if it is rotated.
    var y:Int!
    
    /// Stored list of possible directions where the player can go.
    var possibleCells:[LabyrintheViewController.Direction]?
    
    /// A Potion if room has one. Chances that a potion was generated are 20%. Otherwise, value will be nil.
    var potion:Potion?
    
    /// Can store up to 3 StrangeBat. Chances that a StrangeBat is generated is divided by 3 for each StrangeBat already stored.
    var bats = [StrangeBat]()
    
    /// Boolean that is initially equal to nil. Has to be set to false if a room shouldn't have spikes and true if it should.
    var hasSpikes:Bool?
    
    /// Create a new Room at position x,y
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
