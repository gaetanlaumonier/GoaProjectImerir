//
//  ContentRangementViewController.swift
//  ProjetImerirApp
//
//  Created by Student on 26/04/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class ContentRangementViewController: UIViewController {
    
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
        
        GamesRulesView?.imageView.image = UIImage(named: actualImage)
        GamesRulesView.hint.text = actualHint
        GamesRulesView.titre.text = actualTitle
        GamesRulesView.label.text = actualLabel
        GamesRulesView.label.sizeToFit()
        
        if isLastPage {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: view.bounds.width/3, height: 20 ))
            button.setupButtonDynamicSize(fontSize: 16)
            button.setTitleColor(.white, for: .normal)
            button.setTitle("Je suis prêt", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self.parent?.parent!, action: #selector(ViewController.hideModal), for: .touchUpInside)
            
            view.addSubview(button)
            view.addConstraints([
                NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: button, attribute: .bottomMargin, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -10)
                ])
            
        }
    }

}
