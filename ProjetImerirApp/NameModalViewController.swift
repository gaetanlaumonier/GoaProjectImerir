//
//  NameModalViewController.swift
//  GoaProject
//
//  Created by Student on 02/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class NameModalViewController: UIViewController {
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var contrainteLabel: UILabel!
    @IBOutlet weak var NameButton: UIButton!
    
    var oneProfil = ProfilJoueur(name : "", lifePoint : 0, dictProfil : ["profil_crieur":0, "profil_sociable" : 0, "profil_timide":0, "profil_innovateur":0, "profil_evil":0, "profil_good":0], classeJoueur : "", sceneActuelle : 0, bonneReponseQuiz: 0, questionAlreadyPick:[])
    
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
        
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789éàêèâ")
        if nameField.text?.rangeOfCharacter(from: characterset.inverted) != nil {
            contrainteLabel.text = "Pas de caractères spéciaux !"
        } else if nameField.text == "" {
            contrainteLabel.text = "N'oublie pas de rentrer un nom !"
        } else if (nameField.text?.characters.count)! < 2 || (nameField.text?.characters.count)! > 12 {
            contrainteLabel.text = "de 2 à 12 lettres maximum !"
        } else {
        if let vc = UIStoryboard(name:"Dialogue", bundle:nil).instantiateViewController(withIdentifier: "Dialogue") as? DialogueViewController
        {
            UIView.animate(withDuration: 3, delay: 0, options: .transitionCrossDissolve, animations: {
                let myPresentingViewController = self.presentingViewController as! InitViewController
                myPresentingViewController.view.alpha = 0
                self.view.alpha = 0
                            } , completion: { success in
                let namePlayer = self.nameField.text!.capitalizingFirstLetter()
                self.oneProfil.name = namePlayer
                vc.oneProfil = self.oneProfil
                vc.view.alpha = 0
                self.present(vc, animated: false, completion: nil)
                                UIView.animate(withDuration: 4, delay: 0, options: .transitionCrossDissolve, animations: {
                                    vc.view.alpha = 1
                                }, completion : nil)
             //   self.dismiss(animated: false, completion: nil)
            })
        }else {
            print("Could not instantiate view controller with identifier of type DialogueViewController")
            return
        }
    }
    }
    
    @IBAction func dismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
