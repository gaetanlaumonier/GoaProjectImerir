//
//  CreditViewController.swift
//  ProjetImerirApp
//
//  Created by Student on 03/05/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import AVFoundation

class CreditViewController: UIViewController, CAAnimationDelegate {
    
    @IBOutlet weak var creditView: UIView!
    @IBOutlet weak var FirstLabel: UILabel!
    
    let TITLE_COLOR = UIColor(red: 1, green: 177/255, blue: 24/255, alpha: 1).cgColor
    let SUBTITLE_COLOR = UIColor(red: 1, green: 192/255, blue: 24/255, alpha: 1).cgColor
    let TEXT_COLOR = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
    
    var firstLayer:CATextLayer!
    
    var AllCredit = [Credit]()
    var bruitageMusicPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AllCredit = buildCredit()
        view.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1, animations: {
            self.view.alpha = 1
        }, completion : { _ in
            
            self.firstLayer = CATextLayer()
            self.firstLayer.frame = self.FirstLabel.frame
            self.firstLayer.frame.origin.y = self.view.bounds.height
            self.firstLayer.alignmentMode = kCAAlignmentCenter
            self.firstLayer.shouldRasterize = true
            
            self.firstLayer.shadowOffset = CGSize(width: 1, height: 1)
            self.firstLayer.shadowOpacity = 1
            self.firstLayer.shadowColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1).cgColor
            
            self.promptNextCredit()
        })
    }
    
    func promptNextCredit() {
        
        if let credit = AllCredit.first {
            
            if let copiedLayer = firstLayer.copyLayer() {
                
                copiedLayer.string = credit.textLabel
                
                
                var interval:CFTimeInterval = 0
                
                switch credit.typeLabel {
                case "titre":
                    interval = 0
                    copiedLayer.setupLabelDynamicSize(fontSize: 21)
                    copiedLayer.foregroundColor = TITLE_COLOR
                    copiedLayer.shadowOffset = CGSize(width: 2, height: 2)
                    break
                case "sousTitre":
                    interval = 1
                    copiedLayer.setupLabelDynamicSize(fontSize: 18)
                    copiedLayer.foregroundColor = SUBTITLE_COLOR
                    break
                case "texte":
                    interval = 0.5
                    copiedLayer.setupLabelDynamicSize(fontSize: 15)
                    copiedLayer.foregroundColor = TEXT_COLOR
                    break
                default:
                    break
                }
                
                view.layer.addSublayer(copiedLayer)
                
                
                Timer.scheduledTimer(withTimeInterval: interval, repeats: false, block: { _ in
                    self.AllCredit.removeFirst()
                    self.promptNextCredit()
                    
                    let anim = CABasicAnimation(keyPath: "position.y")
                    anim.toValue = -copiedLayer.frame.height
                    anim.duration = 5
                    anim.delegate = self
                    anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                    anim.setValue(copiedLayer, forKey: "parent")
                    
                    anim.setValue(self.AllCredit.isEmpty, forKey: "isLastLayer")
                    
                    copiedLayer.add(anim, forKey: nil)
                })
            }
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            if let layer = anim.value(forKey: "parent") as? CATextLayer {
                layer.removeFromSuperlayer()
                
                if anim.value(forKey: "isLastLayer") as! Bool {
                    leaveCredits()
                }
            }
        }
    }

    @IBAction func tapScreen(_ sender: Any) {
        leaveCredits()
    }
    
    func leaveCredits() {
        bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
        UIView.animate(withDuration: 1, animations: {
            self.view.alpha = 0
        }, completion: { success in
            self.dismiss(animated:false)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
