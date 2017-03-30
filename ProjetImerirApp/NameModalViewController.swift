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
    
    var oneProfil = ProfilJoueur(name : "", lifePoint : 0, dictProfil : ["profil_crieur":0, "profil_sociable" : 0, "profil_timide":0, "profil_innovateur":0, "profil_evil":0, "profil_good":0], classeJoueur : "", sceneActuelle : 0, bonneReponseQuiz: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(oneProfil.name)
        print(oneProfil.lifePoint)
        print(oneProfil.classeJoueur)

    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newPart" {
            let toViewController = segue.destination as! DialogueViewController
            let namePlayer = nameField.text!.capitalizingFirstLetter()
            self.oneProfil.name = namePlayer
            toViewController.oneProfil = self.oneProfil
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "newPart" {
            let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789éàêèâ")
            if nameField.text?.rangeOfCharacter(from: characterset.inverted) != nil {
                contrainteLabel.text = "Pas de caractères spéciaux !"
                return false
            }   else if nameField.text == "" {
                contrainteLabel.text = "N'oublie pas de rentrer un nom !"
                return false
            } else {
                performSegue(withIdentifier: "newPart", sender: self)
                //let initView : UIViewController = InitViewController()
              //  initView.dismiss(animated: false, completion: nil)
                //self.dismiss(animated: false, completion: nil)
                return true
            }
        } else {
            return false
        }
    }
    @IBAction func dismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
