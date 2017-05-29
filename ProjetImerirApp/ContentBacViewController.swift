//
//  ContentLabyrintheViewController.swift
//  ProjetImerirApp
//
//  Created by Student on 11/05/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class ContentBacViewController: UIViewController {
    
    @IBOutlet var GamesRulesView: GamesRulesView!
    
    var pageIndex:Int!
    var actualImage:String!
    var actualLabel:String!
    var actualTitle:String!
    var actualHint:String!
    var isLastPage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if actualImage == "Fenetre" {
            
            GamesRulesView.imageView.image = #imageLiteral(resourceName: "FenetreOuverte")
            Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in
                
                self.GamesRulesView.imageView.image = #imageLiteral(resourceName: "FenetreFermee")
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
                    self.GamesRulesView.imageView.image = #imageLiteral(resourceName: "FenetreOuverte")
                })
            })
            
        } else if actualImage == "Cafe" || actualImage == "Bol" {
            
            GamesRulesView.imageView.image = UIImage(named: "\(actualImage!)Plein")
            Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in
                
                self.GamesRulesView.imageView.image = UIImage(named: "\(self.actualImage!)Vide")
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
                    self.GamesRulesView.imageView.image = UIImage(named: "\(self.actualImage!)Plein")
                })
            })
        } else if actualImage == "Barres" {
            
            // Ajoute les progressView avec des contraintes car dans le viewDidLoad la vue n'est pas encore dimmensionnée
            
            let fatigueBar = UIProgressView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            fatigueBar.progress = 0.7
            fatigueBar.trackTintColor = .white
            fatigueBar.progressTintColor = .blue
            
            fatigueBar.layer.cornerRadius = 15
            fatigueBar.clipsToBounds = true
            
            fatigueBar.layer.borderColor = UIColor.gray.cgColor
            fatigueBar.layer.borderWidth = 0.3
            
            let scale = CGAffineTransform(scaleX: 1, y: 10)
            let rotate = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            fatigueBar.transform = scale.concatenating(rotate)
            
            fatigueBar.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(fatigueBar)
            view.addConstraints([
                NSLayoutConstraint(item: fatigueBar, attribute: .centerX, relatedBy: .equal, toItem: GamesRulesView.imageView, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: fatigueBar, attribute: .centerY, relatedBy: .equal, toItem: GamesRulesView.imageView, attribute: .centerY, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: fatigueBar, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.5, constant: 0)
                ])
            
            let hungerBar = UIProgressView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            
            hungerBar.progress = 0.4
            hungerBar.trackTintColor = .white
            hungerBar.progressTintColor = .green
            
            hungerBar.layer.cornerRadius = 15
            hungerBar.clipsToBounds = true
            
            hungerBar.layer.borderColor = UIColor.gray.cgColor
            hungerBar.layer.borderWidth = 0.3
            
            hungerBar.transform = scale.concatenating(rotate)
            
            hungerBar.isHidden = true
            hungerBar.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(hungerBar)
            
            view.addConstraints([
                NSLayoutConstraint(item: hungerBar, attribute: .centerX, relatedBy: .equal, toItem: GamesRulesView.imageView, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: hungerBar, attribute: .centerY, relatedBy: .equal, toItem: GamesRulesView.imageView, attribute: .centerY, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: hungerBar, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.5, constant: 0)
                ])
            
            let eyeIcon = UIImageView(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: 0,
                                                    height: 0))
            eyeIcon.image = UIImage(named: "OeilIcon")
            eyeIcon.translatesAutoresizingMaskIntoConstraints = false
            
            view.insertSubview(eyeIcon, aboveSubview: fatigueBar)
            
            view.addConstraints([
                NSLayoutConstraint(item: eyeIcon, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.4, constant: 0),
                NSLayoutConstraint(item: eyeIcon, attribute: .centerY, relatedBy: .equal, toItem: GamesRulesView.imageView, attribute: .centerY, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: eyeIcon, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.1, constant: 0),
                NSLayoutConstraint(item: eyeIcon, attribute: .height, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.1, constant: 0)])
            
            
            
            let bowlIcon = UIImageView(frame: CGRect(x: 0,
                                                     y: 0,
                                                     width: 0,
                                                     height: 0))
            bowlIcon.image = UIImage(named: "BolIcon")
            bowlIcon.translatesAutoresizingMaskIntoConstraints = false
            
            bowlIcon.isHidden = true
            view.insertSubview(bowlIcon, aboveSubview: hungerBar)
            
            view.addConstraints([
                NSLayoutConstraint(item: bowlIcon, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.4, constant: 0),
                NSLayoutConstraint(item: bowlIcon, attribute: .centerY, relatedBy: .equal, toItem: GamesRulesView.imageView, attribute: .centerY, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: bowlIcon, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.1, constant: 0),
                NSLayoutConstraint(item: bowlIcon, attribute: .height, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.1, constant: 0)])

            Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in
                
                hungerBar.isHidden = false
                bowlIcon.isHidden = false
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
                    hungerBar.isHidden = true
                    bowlIcon.isHidden = true
                })
            })
            
        } else {
            GamesRulesView.imageView.image = UIImage(named: actualImage)
        }
        
        if actualHint != "" {
            GamesRulesView.hint.text = actualHint
        } else {
            GamesRulesView.hint.text = ""
        }
        
        GamesRulesView.hint.text = actualHint
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
            button.addTarget(self.parent?.parent!, action: #selector(BacViewController.hideModal), for: .touchUpInside)
            
            view.addSubview(button)
            view.addConstraints([
                NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: button, attribute: .bottomMargin, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -20),
                NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.5, constant: 0)
                ])
            
        }
    }
}
