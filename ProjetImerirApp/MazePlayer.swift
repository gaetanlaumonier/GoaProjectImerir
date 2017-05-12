//
//  MazePlayer.swift
//  ProjetImerirApp
//
//  Created by Student on 07/05/2017.
//  Copyright © 2017 Student. All rights reserved.
//

class MazePlayer {
    
    enum Orientation : Int {
        case North, East, South, West
    }
    
    var x:Int!
    var y:Int!
    var orientation:Orientation = .North
}
