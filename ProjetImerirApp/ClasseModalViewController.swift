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
    var oneProfil = ProfilJoueur(name : "", lifePoint : 0, dictProfil : ["profil_crieur":0, "profil_sociable" : 0, "profil_timide":0, "profil_innovateur":0, "profil_evil":0, "profil_good":0], classeJoueur : "", sceneActuelle : 0, bonneReponseQuiz : 0, questionAlreadyPick:[])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmationLabel.text = "Es tu sur d'être \(classePlayer) ?"

    }
    
    @IBAction func goToDialogue(_ sender: Any) {
        if let vc = UIStoryboard(name:"Dialogue", bundle:nil).instantiateViewController(withIdentifier: "Dialogue") as? DialogueViewController
        {
            UIView.animate(withDuration: 2, delay: 0, options: .transitionCrossDissolve, animations: {
                let myPresentingViewController = self.presentingViewController as! ChoiceClasseViewController
                myPresentingViewController.view.alpha = 0
                self.view.alpha = 0
            } , completion: { success in
                self.oneProfil.classeJoueur = self.classePlayer
                if self.classePlayer == "Geek" {
                    self.oneProfil.lifePoint = self.oneProfil.lifePoint + (self.oneProfil.lifePoint/2)
                }
                self.oneProfil.sceneActuelle += 1
                vc.oneProfil = self.oneProfil
                //vc.view.alpha = 0
              //  print(self)
//                print("presentingViewController",self.presentingViewController)
//                print("presentationController",self.presentationController)
//                print("presentedViewController",self.presentedViewController)
                print("self",self)
                self.dismiss(animated: false, completion:{
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    //show window
                    appDelegate.window?.rootViewController = vc
//                    print("presentingViewController",self.presentingViewController?.presentingViewController)
//                    print("presentingViewController",self.presentationController?.presentingViewController)
//                    print("presentedViewController",self.presentationController?.presentedViewController)
//                    print("presentationController",self.presentedViewController?.presentationController)
//                    print("presentedViewController",self.presentedViewController?.presentedViewController)
//                    print("presentingViewController",self.presentedViewController?.presentingViewController)
//
//                    print("self",self)

                    self.presentingViewController?.dismiss(animated: false, completion: nil)
                })
            })
        } else {
            print("Could not instantiate view controller with identifier of type DialogueViewController")
            return
        }
    }

   
    @IBAction func dismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
