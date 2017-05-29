//
//  NameModalViewController.swift
//  GoaProject
//
//  Created by Student on 02/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import AVFoundation

class NameModalViewController: UIViewController {
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var contrainteLabel: UILabel!
    @IBOutlet weak var NameButton: UIButton!
    
    var oneProfil = ProfilJoueur()
    var bruitageMusicPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.autocorrectionType = .no
        
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        
        let myPresentingViewController = self.presentingViewController as! InitViewController
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789éèàêèâôöëç-ûÔÖÛÇÉÈÊËÀÂ")
        if nameField.text?.rangeOfCharacter(from: characterset.inverted) != nil {
            contrainteLabel.text = "Pas de caractères spéciaux !"
            self.bruitageMusicPlayer = self.GestionBruitage(filename: "ClikBad", volume : 1)
        } else if nameField.text == "" {
            contrainteLabel.text = "N'oublie pas de rentrer un nom !"
            self.bruitageMusicPlayer = self.GestionBruitage(filename: "ClikBad", volume : 1)
        } else if (nameField.text?.characters.count)! < 2 || (nameField.text?.characters.count)! > 12 {
            contrainteLabel.text = "de 2 à 12 lettres maximum !"
            self.bruitageMusicPlayer = self.GestionBruitage(filename: "ClikBad", volume : 1)
        } else {
            if let vc = UIStoryboard(name:"Dialogue", bundle:nil).instantiateViewController(withIdentifier: "Dialogue") as? DialogueViewController
            {
                self.view.endEditing(true)
                bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
                myPresentingViewController.myBruitageMusicPlayer = self.GestionBruitage(filename: "Air", volume : 0.8)
                myPresentingViewController.backgroundMusicPlayer.setVolume(0, fadeDuration: 2.5)
                UIView.animate(withDuration: 2, delay: 0, options: .transitionCrossDissolve, animations: {
                    self.nameView.alpha = CGFloat(0)
                    
                } , completion: { _ in
                    UIView.animate(withDuration: 2.5, animations: {
                        myPresentingViewController.view.alpha = 0
                        self.view.alpha = 0
                    }, completion : { _ in
                        myPresentingViewController.backgroundMusicPlayer.stop()
                        let namePlayer = self.nameField.text!.capitalizingFirstLetter()
                        self.oneProfil = ProfilJoueur(name : "Inconnu", lifePoint : 100, dictProfil : ["profil_crieur":0, "profil_sociable" : 0, "profil_timide":0, "profil_innovateur":0, "profil_evil":0, "profil_good":0], classeJoueur : "Personne", sceneActuelle : 0, statsQuiz : ["bonneReponseQuiz":0, "pourcentage" : 0], statsCookie : ["cookieGoodTaped":0, "pourcentage" : 0], statsRangement : ["goodClassification":0, "pourcentage" : 0], statsConsole : ["missileHit":0, "pourcentage" : 0], statsBac : ["goodClassification":0, "pourcentage" : 0], statsLabyrinthe : ["timeSpent":0, "batKilled" : 0], questionAlreadyPick:[])
                        self.oneProfil.name = namePlayer
                        self.saveMyData()
                        
                        vc.oneProfil = self.oneProfil
                        self.view.window?.rootViewController? = vc
                        
                    })
                })
            } else {
                print("Could not instantiate view controller with identifier of type DialogueViewController")
                return
            }
        }
    }
    
    @IBAction func dismissButton(_ sender: UIButton) {
        self.bruitageMusicPlayer = self.GestionBruitage(filename: "ClikBad", volume : 1)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func upKeyboard(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.nameView.frame.origin.y = self.view.bounds.height/7
        })
    }
    
    @IBAction func downKeyboard(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.nameView.center.y = self.view.center.y
        })
        
    }
    
    func saveMyData(){
        var maData = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        maData.appendPathComponent("saveGame")
        NSKeyedArchiver.archiveRootObject(self.oneProfil, toFile: maData.path)
        
    }
}
