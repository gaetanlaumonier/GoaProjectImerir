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
    
    var oneProfil = ProfilJoueur(name : "", lifePoint : 0, dictProfil : ["profil_crieur":0, "profil_sociable" : 0, "profil_timide":0, "profil_innovateur":0, "profil_evil":0, "profil_good":0], classeJoueur : "", sceneActuelle : 0, bonneReponseQuiz: 0, questionAlreadyPick:[])
    var bruitageMusicPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "newPart" {
//            let toViewController = segue.destination as! DialogueViewController
//            let namePlayer = nameField.text!.capitalizingFirstLetter()
//            self.oneProfil.name = namePlayer
//            toViewController.oneProfil = self.oneProfil
//           // toViewController.modalPresentationStyle = .custom
//           // toViewController.modalTransitionStyle = .partialCurl
//        }
//    }
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        
//        if identifier == "newPart" {
//            let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789éàêèâ")
//            if nameField.text?.rangeOfCharacter(from: characterset.inverted) != nil {
//                contrainteLabel.text = "Pas de caractères spéciaux !"
//                return false
//            }   else if nameField.text == "" {
//                contrainteLabel.text = "N'oublie pas de rentrer un nom !"
//                return false
//            } else {
               // UIView.animate(withDuration: 4, delay: 0, options: .transitionCrossDissolve, animations: {
                //    self.generalView.alpha = 0
              //      self.generalView.backgroundColor = .black
              //  } , completion: { success in
//                    return true
//               // })
//            }
//        } else {
//            return false
//        }
//        return false
//    }

    @IBAction func startNewGame(_ sender: UIButton) {
        
        let myPresentingViewController = self.presentingViewController as! InitViewController
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789éàêèâ")
        if nameField.text?.rangeOfCharacter(from: characterset.inverted) != nil {
            contrainteLabel.text = "Pas de caractères spéciaux !"
            myPresentingViewController.bruitageMusicPlayer = self.GestionBruitage(filename: "ClikBad", volume : 1)

        } else if nameField.text == "" {
            contrainteLabel.text = "N'oublie pas de rentrer un nom !"
            myPresentingViewController.bruitageMusicPlayer = self.GestionBruitage(filename: "ClikBad", volume : 1)
        } else if (nameField.text?.characters.count)! < 2 || (nameField.text?.characters.count)! > 12 {
            contrainteLabel.text = "de 2 à 12 lettres maximum !"
            myPresentingViewController.bruitageMusicPlayer = self.GestionBruitage(filename: "ClikBad", volume : 1)
        } else {
            if let vc = UIStoryboard(name:"Dialogue", bundle:nil).instantiateViewController(withIdentifier: "Dialogue") as? DialogueViewController
        {
            
                bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
            myPresentingViewController.bruitageMusicPlayer = self.GestionBruitage(filename: "Air", volume : 0.8)
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
                                     self.oneProfil = ProfilJoueur(name : "Inconnu", lifePoint : 100, dictProfil : ["profil_crieur":4, "profil_sociable" : 0, "profil_timide":4, "profil_innovateur":0, "profil_evil":4, "profil_good":4], classeJoueur : "Hacker", sceneActuelle : 5, bonneReponseQuiz:20, questionAlreadyPick:[])
                                    self.oneProfil.name = namePlayer
                                    self.saveMyData()
                                    
                                    vc.oneProfil = self.oneProfil
                                //    self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)

                                    self.present(vc, animated: false, completion: nil)

                                })
                    })
             //   self.dismiss(animated: false, completion: nil)
        } else {
            print("Could not instantiate view controller with identifier of type DialogueViewController")
            return
            }
        }
    }
    
    @IBAction func dismissButton(_ sender: UIButton) {
        bruitageMusicPlayer = self.GestionBruitage(filename: "ClikBad", volume : 1)
        self.dismiss(animated: true, completion: nil)
    }

    func saveMyData(){
        var maData = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        maData.appendPathComponent("saveGame")
        NSKeyedArchiver.archiveRootObject(self.oneProfil, toFile: maData.path)
        
    }
}
