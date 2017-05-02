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

    @IBOutlet weak var settingImage: DesignableButton!
    
    
    @IBAction func settingButton(_ sender: UIButton) {
        
        
        if let vc = UIStoryboard(name:"Parametres", bundle:nil).instantiateInitialViewController() as? ParametresViewController
        {
            let topController = UIApplication.topViewController()
                topController?.present(vc, animated: true, completion: nil)
            
        } else {
            print("Could not instantiate view controller with identifier of type ParametresViewController")
            return
        }
    }
    
//    @IBAction func settingPush(_ sender: UIButton) {
//        //settingImage.setImage(#imageLiteral(resourceName: "RoueCranteePush"), for: .selected)
//        
//       //settingImage.setImage(#imageLiteral(resourceName: "RoueCranteePush"), for: .focused)
//
//        settingImage.setImage(#imageLiteral(resourceName: "RoueCranteePush"), for: .highlighted)
//     
//    }
    
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
}
