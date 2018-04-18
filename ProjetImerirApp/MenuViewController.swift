//
//  MenuViewController.swift
//  ProjetImerirApp
//
//  Created by Student on 03/06/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import AVFoundation
import GameKit
import MessageUI

class MenuViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var stackViews: [UIStackView]!
    @IBOutlet var imerirLogo: UIImageView!
    @IBOutlet var gcLabel: DesignableButton!
    @IBOutlet var succesLabel: DesignableButton!
    @IBOutlet var achievementPercentage: UILabel!
    @IBOutlet var achievementProgress: UIProgressView!
    
    var embedViewController:EmbedViewController!
    var bruitageMusicPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        
        succesLabel.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.01, bottom: 0.01, right: 0)
        gcLabel.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.01, bottom: 0.01, right: 0)

        embedViewController = getEmbedViewController()
        
        if embedViewController.gcEnabled {
            onGcUserConnected()
        }
        
        NotificationCenter.default.addObserver(forName: embedViewController.gcConnectedNotif, object: nil, queue: nil, using: self.onGcUserConnected)

        
        let radius = UIScreen.main.bounds.width/20
        let size = CGSize(width: 0, height: 0)

        for stackView in stackViews {
            for subLayer in stackView.layer.sublayers! {
                
                if subLayer is CATransformLayer {
                    if let subsubLayers = subLayer.sublayers {
                        for subsubLayer in subsubLayers {
                            subsubLayer.shadowOpacity = 1
                            subsubLayer.shadowColor = UIColor.white.cgColor
                            subsubLayer.shadowOffset = size
                            subsubLayer.shadowRadius = radius
                        }
                    }
                    continue
                }
                
                subLayer.shadowOpacity = 1
                subLayer.shadowColor = UIColor.white.cgColor
                subLayer.shadowOffset = size
                subLayer.shadowRadius = radius
            }
        }
        
        imerirLogo.layer.shadowOpacity = 1
        imerirLogo.layer.shadowColor = UIColor.white.cgColor
        imerirLogo.layer.shadowOffset = size
        imerirLogo.layer.shadowRadius = radius
    }
    
    func onGcUserConnected(notification:Notification? = nil) {
        gcLabel.setTitle("Connecté", for: [])
        gcLabel.setTitleColor(.green, for: [])
        
        achievementProgress.progress = Float(embedViewController.earnedAchievements.count) / Float(embedViewController.totalNumberOfAchievements)
        achievementProgress.isHidden = false
        
        achievementPercentage.text = String(Int(achievementProgress.progress * 100)) + "%"
        achievementPercentage.isHidden = false
    }
    
    @IBAction func openGameCenter(_ sender: UITapGestureRecognizer) {
        bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
        
        if embedViewController.gcEnabled {
            
            let gcVC = GKGameCenterViewController()
            gcVC.gameCenterDelegate = self.embedViewController
            gcVC.viewState = .achievements
            
            dismiss(animated: true, completion: {
                self.embedViewController.present(gcVC, animated: true, completion: nil)
            })
            
        } else {
            
            // If user canceled login once, it can't be displayed again, so we show an alert
            let alert = UIAlertController(title: "Game Center", message: "Veuillez relancer le jeu si vous souhaitez activer Game Center.\nSi cela ne fonctionne pas, essayez d'activer Game Center dans\nRéglages > Game Center", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            let settingsAction = UIAlertAction(title: "Réglages", style: .cancel, handler: { _ in
                if let settingsURL = URL(string:"App-Prefs:") {
                    if UIApplication.shared.canOpenURL(settingsURL) {
                        UIApplication.shared.open(settingsURL as URL)
                    }
                }
            })

            alert.addAction(settingsAction)
            alert.addAction(okAction)
                
            alert.preferredAction = okAction
            
                
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func openRating(_ sender: UITapGestureRecognizer) {
        
        bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
        
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/id1243112014?action=write-review") else {
            return
        }
        
        UIApplication.shared.open(url as URL)
    }

    @IBAction func openFeedback(_ sender: UITapGestureRecognizer) {
        
        bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
        
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients(["labanalejournee@gmail.com"])
            composeVC.setSubject("Feedback")
            
            dismiss(animated: true, completion: {
                self.embedViewController.present(composeVC, animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func openWikia(_ sender: UITapGestureRecognizer) {
        
        bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)

        guard let url = URL(string : "http://fr.la-banale-journee.wikia.com") else {
            return
        }
        
        UIApplication.shared.open(url as URL)
    }
    
    @IBAction func dismissModal(_ sender: UITapGestureRecognizer) {
        bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
        dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: {
            
            if result.rawValue == 2 {
                let alert = UIAlertController(title: "Message envoyé", message: "Merci d'avoir envoyé votre message, il sera lu par notre équipe très bientôt.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alert.addAction(action)
                
                self.embedViewController.present(alert, animated: true, completion: nil)
            }
        })
    }
}
