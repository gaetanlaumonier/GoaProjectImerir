//
//  ElementDataView.swift
//  ProjetImerirApp
//
//  Created by Student on 11/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

@IBDesignable class HeaderView: UIView {


    @IBOutlet weak var timerLabel: DesignableLabel!
    @IBOutlet weak var settingImageView: UIImageView!

    @IBOutlet weak var lifePointLabel: DesignableLabel!
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
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
        let nib = UINib(nibName: "HeaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
//    func setup(){
//        view = loadViewFromNib()
//        view.frame = bounds
//     //   view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.flexibleHeight
//        addSubview(view)
//        
//    //    let bundle = Bundle(for: type(of: self))
//        
//  //      self.view = bundle.loadNibNamed("HeaderView", owner:self, options:nil)!.first as! UIView!
//    }
//    
//    func loadViewFromNib() -> UIView {
//        let bundle = Bundle(for: type(of: self))
//        let nib = UINib(nibName:"HeaderView", bundle: bundle)
//        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
//       
//        return view
//    }
//    
//    @IBInspectable var myTimerText : String?
//        {
//        get {
//            return timerLabel.text
//        }
//        set (myTimerText){
//            timerLabel.text = myTimerText
//        }
//    }
//
//    @IBInspectable var myLifePointText : String?
//        {
//            get {
//                return lifePointLabel.text
//            }
//            set (myLifePointText){
//                lifePointLabel.text = myLifePointText
//            }
//        }
}
