//
//  Fiche.swift
//  ProjetImerirApp
//
//  Created by Student on 17/05/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class Fiche: UIView {

    @IBOutlet var fakeTextView: UIView!
    @IBOutlet var matiereLabel: UILabel!
    
    var matiere: String!
    
    init(frame: CGRect, matiere: String) {
        super.init(frame: frame)
        xibSetup()
        self.matiere = matiere
        matiereLabel.text = matiere
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func addFakeText() {
        // Otherwise view takes its bounds from the xib
        self.layoutIfNeeded()
        
        let maxHeight = fakeTextView.bounds.height
        let maxWidth = fakeTextView.bounds.width
        let maxLinesAndCells = 10
        let randomLines = 7
        let lines = Int(arc4random_uniform(UInt32(randomLines + 1))) + maxLinesAndCells - randomLines - 1
        let lineHeight = maxHeight / CGFloat(maxLinesAndCells)
        let cellWidth = maxWidth / CGFloat(maxLinesAndCells)
        let randomCells = 5
        let randomWidth = maxWidth * (CGFloat(randomCells) / CGFloat(maxLinesAndCells))
        
        for i in 0...lines - 1 {
            let layer = CALayer()
            
            layer.frame = CGRect(x: cellWidth/2,
                                 y: CGFloat(i)*lineHeight + lineHeight/2,
                                 width: CGFloat(drand48()) * randomWidth + maxWidth - randomWidth - cellWidth/2,
                                 height: lineHeight/2)
            
            layer.backgroundColor = UIColor.black.cgColor
            
            fakeTextView.layer.addSublayer(layer)
        }
    }
    
    var view: UIView!
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "FicheView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}
