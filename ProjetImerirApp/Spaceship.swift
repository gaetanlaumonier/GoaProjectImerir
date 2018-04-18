//
//  Spaceship.swift
//  ProjetImerirApp
//
//  Created by Student on 15/05/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class Spaceship: UIImageView {
    
    var decalage:CGFloat = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let decalage = touch.location(in: self)
        
        self.decalage = decalage.x
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let pos = touch.location(in: self.superview)
        
        var newPos = pos.x - decalage
        
        if newPos < 0 {
            newPos = 0
        } else if newPos > self.superview!.bounds.width - self.bounds.width {
            newPos = self.superview!.bounds.width - self.bounds.width
        }
        
        self.frame.origin.x = newPos
        
    }
}
