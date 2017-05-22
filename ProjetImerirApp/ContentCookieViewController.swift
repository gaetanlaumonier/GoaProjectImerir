//
//  ContentCookieViewController.swift
//  CookieArcade
//
//  Created by Student on 29/01/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit


class ContentCookieViewController: UIViewController {
    
    @IBOutlet var GamesRulesView: GamesRulesView!

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
                NSLayoutConstraint(item: progressBar, attribute: .centerX, relatedBy: .equal, toItem: GamesRulesView.imageView, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: progressBar, attribute: .centerY, relatedBy: .equal, toItem: GamesRulesView.imageView, attribute: .centerY, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: progressBar, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.5, constant: 0)
                ])
            
            Timer.scheduledTimer(timeInterval: 1/60, target: self, selector: #selector(ContentCookieViewController.animateProgressBar), userInfo: nil, repeats: true)
        } else if actualImage == "Mom" {
            GamesRulesView.imageView.loadGif(name: "Maman")
        } else {
            print(actualImage)
            GamesRulesView?.imageView.image = UIImage(named: actualImage)
        }

        if actualHint != "" {
           GamesRulesView.hint.text = "Astuce : " + actualHint
        } else {
           GamesRulesView.hint.text = ""
        }
        
        
      GamesRulesView.titre.text = actualTitle
      GamesRulesView.label.text = actualLabel
      GamesRulesView.label.sizeToFit()

        if isLastPage {
            
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: view.bounds.width/4, height: 20 ))
            button.setTitleColor(.white, for: .normal)
            button.setTitle("Je suis prêt", for: .normal)
            button.layer.cornerRadius = self.view.bounds.width / 25
            button.titleLabel!.font =  UIFont(name: "Futura", size: 10)
            button.setupButtonDynamicSize(fontSize: 16)
            button.backgroundColor = UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1)
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor(red: 1, green: 192/255, blue: 24/255, alpha: 1).cgColor
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self.parent?.parent!, action: #selector(CookieViewController.hideModal), for: .touchUpInside)
            
            view.addSubview(button)
            view.addConstraints([
                NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: button, attribute: .bottomMargin, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -20),
                NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.5, constant: 0)
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
