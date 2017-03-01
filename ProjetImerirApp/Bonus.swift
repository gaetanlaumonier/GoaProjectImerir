//
//  Bonus.swift
//  ProjetImerirApp
//
//  Created by Student on 25/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class Bonus: UIButton {
    var msg:String!
    var rangementView:RangementView!
    var color:UIColor = UIColor.green
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let spview = self.superview {
            rangementView = spview as! RangementView
            self.addTarget(rangementView.controller, action: #selector(RangementViewController.onBonusPicked), for: .touchUpInside)
        }
    }
    
    required override init(frame: CGRect){
        super.init(frame: frame)
        self.onInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func onInit() {
        
    }
    
    func onBonusPicked() {
        self.isUserInteractionEnabled = false
        rangementView.controller.drawMessage(bonus: self)
        self.layer.removeAllAnimations()
        UIView.animate(withDuration: 2, animations: {_ in
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        },completion: {_ in
            self.removeFromSuperview()
        })
    }
    
    
}
