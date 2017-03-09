//
//  ClasseModalViewController.swift
//  ProjetImerirApp
//
//  Created by Student on 15/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class ClasseModalViewController: UIViewController {

    @IBOutlet weak var confirmationLabel: DesignableLabel!
    @IBOutlet weak var ouiButton: DesignableButton!
    @IBOutlet weak var nonButton: DesignableButton!
    
    var classePlayer : String = ""
    var oneProfil = ProfilJoueur(name : "", lifePoint : 0, dictProfil : ["profil_crieur":0, "profil_sociable" : 0, "profil_timide":0, "profil_innovateur":0, "profil_evil":0, "profil_good":0], classeJoueur : "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmationLabel.text = "Es tu sur d'être \(classePlayer) ?"
        print(oneProfil.name)
        print(oneProfil.lifePoint)
        print(oneProfil.classeJoueur)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "retourDialogue" {
            let toViewController = segue.destination as! DialogueViewController
            self.oneProfil.classeJoueur = classePlayer
            if classePlayer == "Geek" {
                self.oneProfil.lifePoint = self.oneProfil.lifePoint + (self.oneProfil.lifePoint/2)
            }
            toViewController.oneProfil = self.oneProfil
            toViewController.idDialogueNumber = 1
            toViewController.DialogueNumber = 0
            let classeView : UIViewController = ChoiceClasseViewController()
           // classeView.dismiss(animated : false, completion: nil)
            self.dismiss(animated: false, completion: nil)

        }
    }

    @IBAction func dismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
