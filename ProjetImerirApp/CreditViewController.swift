//
//  CreditViewController.swift
//  ProjetImerirApp
//
//  Created by Student on 03/05/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import AVFoundation

class CreditViewController: UIViewController {
    
    @IBOutlet weak var creditView: UIView!
    @IBOutlet weak var FirstLabel: UILabel!
    var AllCredit = [Credit]()
    var bruitageMusicPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AllCredit = buildCredit()
        self.view.alpha = 0

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.isHidden = false
        UIView.animate(withDuration: 1, animations: {
        self.creditView.alpha = 0.65
        self.view.alpha = 1
        }, completion : { success in
        
        var totalInterval:TimeInterval = 0
        
        for credit in self.AllCredit {
            let label = DesignableLabel(frame: self.FirstLabel.frame)
            label.frame.origin.y = self.view.frame.height
            label.text = credit.textLabel
            label.textAlignment = .center
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.layer.shadowOffset = CGSize(width: 1, height: 1)
            label.layer.shadowOpacity = 1
            label.layer.shadowColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1).cgColor
            var interval:TimeInterval = 0
            label.layer.shouldRasterize = true
            
            switch credit.typeLabel {
                case "titre":
                    interval = 0
                    label.setupLabelDynamicSize(fontSize: 21)
                    label.textColor = UIColor(red: 1, green: 177/255, blue: 24/255, alpha: 1)
                    label.layer.shadowOffset = CGSize(width: 2, height: 2)
                    break
                case "sousTitre":
                    interval = 1
                    label.setupLabelDynamicSize(fontSize: 18)
                    label.textColor = UIColor(red: 1, green: 192/255, blue: 24/255, alpha: 1)
                    break
                case "texte":
                    interval = 0.5
                    label.setupLabelDynamicSize(fontSize: 15)
                    label.textColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
                    break
                default:
                    break
            }
            
            self.view.addSubview(label)
            
            totalInterval += interval

            UIView.animate(withDuration: 5, delay: totalInterval, options: [.curveLinear], animations: { _ in
                label.frame.origin.y = -label.frame.height
            }, completion: { _ in
                label.removeFromSuperview()
            })
            
        }
    })
    }

    @IBAction func tapScreen(_ sender: Any) {
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
