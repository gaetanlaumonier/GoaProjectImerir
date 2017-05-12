//
//  Objet.swift
//  ProjetImerirApp
//
//  Created by Student on 25/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class Objet: UIImageView {
    
    var decalage:CGPoint!
    var previousPosition:CGPoint!
    var isMoving = false
    var isSpawning = false
    var isWiggling = false
    var isGrabbed = false
    var isDying = false
    var isFrozen = false
    var wiggleTimer:Timer!
    var rangementView:RangementView!
    var wiggleSpeed:CFTimeInterval! {
        get {
            return self.rangementView.controller.timeLeft / 20 + 1
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let spview = self.superview {
            rangementView = spview as! RangementView
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        decalage = touch!.location(in: self)
        if !isSpawning {
            self.layer.removeAllAnimations()
        }
        self.isWiggling = false
        self.isGrabbed = true
        rangementView.controller.stopWiggling(objet: self)
        
        
        let location = touch!.location(in: self.superview)
        
        if let layer = layer.presentation() {
            decalage.x = decalage.x + self.frame.origin.x - layer.frame.origin.x
            decalage.y = decalage.y + self.frame.origin.y - layer.frame.origin.y
            
            let newLoc = CGPoint(x: location.x - decalage.x, y: location.y - decalage.y)
            previousPosition = newLoc
            
            self.frame.origin = newLoc
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch!.location(in: self.superview)
        
        let newLoc = CGPoint(x: location.x - decalage.x, y: location.y - decalage.y)
        self.frame.origin = newLoc
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isGrabbed = false
        rangementView.controller.onObjectDropped(objet: self)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let presentationLayer = self.layer.presentation() {
            let suppt = self.convert(point, to: self.superview)
            let prespt = self.superview!.layer.convert(suppt, to: presentationLayer)
            return super.hitTest(prespt, with: event)
            
        }
        
        return super.hitTest(point, with: event)
    }
    
    
}
