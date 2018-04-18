//
//  ModeArcadeViewController.swift
//  ProjetImerirApp
//
//  Created by Student on 10/06/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import AVFoundation

class ModeArcadeViewController: UIViewController {

    @IBOutlet var classesStackView: UIStackView!
    @IBOutlet var arcadesStackView: UIStackView!
    
    var embedViewController:EmbedViewController!
    var bruitageMusicPlayer = AVAudioPlayer()
    var arcadeChoosen:Int!
    var oneProfil = ProfilJoueur()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        embedViewController = getEmbedViewController()
    }
    
    @IBAction func dismissModal(_ sender: UITapGestureRecognizer) {
        bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onArcadeChoosen(_ sender: DesignableButton) {
        bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
        arcadeChoosen = sender.tag
        
        UIView.animate(withDuration: 1) {
            self.arcadesStackView.alpha = 0
            self.classesStackView.alpha = 1
        }
    }
    
    @IBAction func onClasseChoosen(_ sender: DesignableButton) {
        bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
        
        oneProfil.classeJoueur = sender.title(for: [])!
        oneProfil.lifePoint = 100
        
        dismiss(animated: true, completion: nil)
        
        let myPresentingViewController = self.presentingViewController!.childViewControllers.first as! InitViewController
        
        switch arcadeChoosen {
        case 1:
            if let vc = UIStoryboard(name:"ArcadeCookie", bundle:nil).instantiateInitialViewController() as? CookieViewController {
                UIView.animate(withDuration: 2, delay: 0, options: .transitionCrossDissolve, animations: {
                    myPresentingViewController.view.alpha = 0
                    self.embedViewController.backgroundMusicPlayer.setVolume(0, fadeDuration: 2)
                } , completion: { success in
                    vc.oneProfil = self.oneProfil
                    vc.arcadeMode = true
                    self.embedViewController.showScene(vc)
                })
            }
            break
        case 2:
            if let vc = UIStoryboard(name:"ArcadeRangement", bundle:nil).instantiateInitialViewController() as? RangementViewController {
                UIView.animate(withDuration: 2, delay: 0, options: .transitionCrossDissolve, animations: {
                    myPresentingViewController.view.alpha = 0
                    self.embedViewController.backgroundMusicPlayer.setVolume(0, fadeDuration: 2)
                } , completion: { success in
                    vc.oneProfil = self.oneProfil
                    vc.arcadeMode = true
                    self.embedViewController.showScene(vc)
                })
            }
            break
        case 3:
            if let vc = UIStoryboard(name:"ArcadeConsole", bundle:nil).instantiateInitialViewController() as? ConsoleViewController {
                UIView.animate(withDuration: 2, delay: 0, options: .transitionCrossDissolve, animations: {
                    myPresentingViewController.view.alpha = 0
                    self.embedViewController.backgroundMusicPlayer.setVolume(0, fadeDuration: 2)
                } , completion: { success in
                    vc.oneProfil = self.oneProfil
                    vc.arcadeMode = true
                    self.embedViewController.showScene(vc)
                })
            }
            break
        case 4:
            if let vc = UIStoryboard(name:"ArcadeBac", bundle:nil).instantiateInitialViewController() as? BacViewController {
                UIView.animate(withDuration: 2, delay: 0, options: .transitionCrossDissolve, animations: {
                    myPresentingViewController.view.alpha = 0
                    self.embedViewController.backgroundMusicPlayer.setVolume(0, fadeDuration: 2)
                } , completion: { success in
                    vc.oneProfil = self.oneProfil
                    vc.arcadeMode = true
                    self.embedViewController.showScene(vc)
                })
            }
        default:
            break
        }
    }
}
