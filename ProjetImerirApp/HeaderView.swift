//
//  ElementDataView.swift
//  ProjetImerirApp
//
//  Created by Student on 11/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//
import AVFoundation
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
    //{
//        willSet {
//            print("New value is \(newValue)")
//        }
//        didSet {
//            print("Old value is \(oldValue)")
//        }
//        didSet {
//           
//            let truncated = lifePointLabel.text?.index((lifePointLabel.text?.endIndex)!, offsetBy: -3)
//            let indexTruncated = lifePointLabel.text?.substring(to: truncated!)
//           //let string = lifePointLabel.text!.substring(to: truncated!)
//           // print(Int(string)!
//            let oldTruncated = oldValue?.text?.index((oldValue?.text?.endIndex)!, offsetBy: -3)
//            let indexOldTruncated = oldValue?.text?.substring(to: (oldTruncated)!)
//            
//            if Int(indexTruncated!)! > Int((indexOldTruncated)!)! {
//                UIView.animate(withDuration: 0.25, animations: {
//                    self.lifePointLabel.shadowColor = UIColor(colorLiteralRed: 127/255, green: 1, blue: 22/255, alpha: 1)
//                },completion : { _ in
//                    UIView.animate(withDuration: 0.25, animations: {
//                        self.lifePointLabel.shadowColor = UIColor(colorLiteralRed: 80/255, green: 80/255, blue: 80/255, alpha: 1)
//                    })
//                })
//            } else {
//                UIView.animate(withDuration: 0.25, animations: {
//                    self.lifePointLabel.shadowColor = UIColor(colorLiteralRed: 1, green: 192/255, blue: 22/255, alpha: 1)
//                },completion : { _ in
//                    UIView.animate(withDuration: 0.25, animations: {
//                        self.lifePointLabel.shadowColor = UIColor(colorLiteralRed: 80/255, green: 80/255, blue: 80/255, alpha: 1)
//                    })
//                })
//                }
//        }
//    }
    
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
