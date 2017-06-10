//
//  Maze.swift
//  ProjetImerirApp
//
//  Created by Student on 05/04/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

/**
 Custom class that generates a [[Cell]] array for a given width and height
 */
class Maze {
    
    /**
     Type of a maze cell.
     - Space
     - Wall
     */
    enum Cell {
        case Space, Wall
    }
    
    /// Contains maze's data
    var data: [[Cell]] = []
    
    /// Width with which the maze was generated
    var width: Int!
    
    /// Height with which the maze was generated
    var height: Int!
    
    /// The total number of .space cells in the maze
    var walkableCells: Int = 0
    
    /**
     Generate a random maze.
     
     - parameters:
        - width: Number of Cells in a subarray. Must be odd.
        - height: Number of subarrays. Must be odd.
     
     - Important:
     Each border Cell will be a Cell.Space
     */
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        for _ in 0 ..< height {
            data.append([Cell](repeating: Cell.Wall, count: width))
        }
        for i in 0 ..< width {
            data[0][i] = Cell.Space
            data[height - 1][i] = Cell.Space
        }
        for i in 0 ..< height {
            data[i][0] = Cell.Space
            data[i][width - 1] = Cell.Space
        }
        data[2][2] = Cell.Space
        self.carve(x: 2, y: 2)
        data[1][2] = Cell.Wall
        data[height - 2][width - 3] = Cell.Space
        walkableCells += 2
    }
    
    // Carve starting at x, y.
    private func carve(x: Int, y: Int) {
        let upx = [1, -1, 0, 0]
        let upy = [0, 0, 1, -1]
        var dir = Int(arc4random_uniform(4))
        var count = 0
        while count < 4 {
            let x1 = x + upx[dir]
            let y1 = y + upy[dir]
            let x2 = x1 + upx[dir]
            let y2 = y1 + upy[dir]
            if data[y1][x1] == Cell.Wall && data[y2][x2] == Cell.Wall {
                data[y1][x1] = Cell.Space
                data[y2][x2] = Cell.Space
                walkableCells += 2
                carve(x: x2, y: y2)
            } else {
                dir = (dir + 1) % 4
                count += 1
            }
        }
    }
    
    /// Print maze into Debugger.
    func show() {
        for row in data {
            for cell in row {
                if cell == Cell.Space {
                    print("  ", terminator: "")
                } else {
                    print("[]", terminator: "")
                }
            }
            print()
        }
    }
    
}
