//
//  ContentViewController.swift
//  CookieArcade
//
//  Created by Student on 29/01/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet var titre: DesignableLabel!
    @IBOutlet var label: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var hint: DesignableLabel!
    
    var pageIndex:Int!
    var actualImage:String!
    var actualLabel:String!
    var actualTitle:String!
    var actualHint:String!
    var isLastPage = false
    var progressBar = UIProgressView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if actualImage == "progressBar" {
            progressBar.progress = 0.5
            progressBar.transform = CGAffineTransform(scaleX: 1.0, y: 10.0)
            progressBar.progressTintColor = UIColor(red: 0.5, green: 0.5, blue: 0.0, alpha: 1.0)
            progressBar.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(progressBar)
            view.addConstraints([
                NSLayoutConstraint(item: progressBar, attribute: .centerX, relatedBy: .equal, toItem: imageView, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: progressBar, attribute: .centerY, relatedBy: .equal, toItem: imageView, attribute: .centerY, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: progressBar, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.5, constant: 0)
                ])
            
            Timer.scheduledTimer(timeInterval: 1/60, target: self, selector: #selector(ContentViewController.animateProgressBar), userInfo: nil, repeats: true)
        } else {
            imageView.image = UIImage(named: actualImage)
        }

        if actualHint != "" {
            hint.text = "Astuce : " + actualHint
        } else {
            hint.text = ""
        }
        
        
        titre.text = actualTitle
        label.text = actualLabel
        label.sizeToFit()
        print(view.bounds)
        if isLastPage {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: view.bounds.width/3, height: 20 ))
            button.setupButtonDynamicSize(fontSize: 12)
            button.setTitleColor(.blue, for: .normal)
            button.setTitle("Je suis prêt", for: .normal)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self.parent?.parent!, action: #selector(ViewController.hideModal), for: .touchUpInside)
            
            view.addSubview(button)
            view.addConstraints([
                NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: button, attribute: .bottomMargin, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -20)
                ])
            
        }
    }
    
    func animateProgressBar() {
        if progressBar.progress < 1 {
            progressBar.progress += 1/180
        } else {
            progressBar.progress = 0
        }
        progressBar.progressTintColor = UIColor(red: 1 - CGFloat(progressBar.progress), green: CGFloat(progressBar.progress), blue: 0.0, alpha: 1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
