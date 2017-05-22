//
//  ClasseModalViewController.swift
//  ProjetImerirApp
//
//  Created by Student on 15/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import AVFoundation

class ClasseModalViewController: UIViewController {

    @IBOutlet weak var classeView: DesignableView!
    @IBOutlet weak var confirmationLabel: DesignableLabel!
    @IBOutlet weak var ouiButton: DesignableButton!
    @IBOutlet weak var nonButton: DesignableButton!
    
    var classePlayer : String = ""
    var oneProfil = ProfilJoueur()
    var bruitageMusicPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmationLabel.text = "Es tu sur d'être \(classePlayer) ?"
        self.ouiButton.alpha = 0
        self.nonButton.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {

        self.ouiButton.layer.cornerRadius = self.view.bounds.width / 20
        self.nonButton.layer.cornerRadius = self.view.bounds.width / 20
        
        UIView.animate(withDuration: 0.25, animations: {
            self.ouiButton.alpha = 1
            self.nonButton.alpha = 1

        })
        
    }
    
    @IBAction func goToDialogue(_ sender: Any) {
        let myPresentingViewController = self.presentingViewController as! ChoiceClasseViewController
        let myDialogueViewController = self.presentingViewController?.presentingViewController as! DialogueViewController
        if let vc = UIStoryboard(name:"Dialogue", bundle:nil).instantiateViewController(withIdentifier: "Dialogue") as? DialogueViewController
        {
            self.bruitageMusicPlayer = self.GestionBruitage(filename: "Clik", volume : 1)
            UIView.animate(withDuration: 1, animations: {
            self.classeView.alpha = 0
            }, completion: { _ in
                UIView.animate(withDuration: 2, animations: {
                    myPresentingViewController.view.alpha = 0
                    self.view.alpha = 0
                    myDialogueViewController.backgroundMusicPlayer.setVolume(0, fadeDuration: 2)
                    
                } , completion: { success in
                    myDialogueViewController.backgroundMusicPlayer.stop()
                    self.oneProfil.classeJoueur = self.classePlayer
                    if self.classePlayer == "Geek" {
                        self.oneProfil.lifePoint = self.oneProfil.lifePoint + 40
                    }
                    self.oneProfil.sceneActuelle += 1
                    self.saveMyData()
                    
                    vc.oneProfil = self.oneProfil
                    //vc.view.alpha = 0
                    //  print(self)
                    //                print("presentingViewController",self.presentingViewController)
                    //                print("presentationController",self.presentationController)
                    //                print("presentedViewController",self.presentedViewController)
                    self.present(vc, animated: false)
                    //self.dismiss(animated: false, completion:{
                        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        //show window
                        //appDelegate.window?.rootViewController = vc
                        //                    print("presentingViewController",self.presentingViewController?.presentingViewController)
                        //                    print("presentingViewController",self.presentationController?.presentingViewController)
                        //                    print("presentedViewController",self.presentationController?.presentedViewController)
                        //                    print("presentationController",self.presentedViewController?.presentationController)
                        //                    print("presentedViewController",self.presentedViewController?.presentedViewController)
                        //                    print("presentingViewController",self.presentedViewController?.presentingViewController)
                        //
                        //                    print("self",self)
                        
                        //self.presentingViewController?.dismiss(animated: false, completion: nil)
                })
            })
           
        } else {
            print("Could not instantiate view controller with identifier of type DialogueViewController")
            return
        }
    }

   
    @IBAction func dismissButton(_ sender: UIButton) {
        bruitageMusicPlayer = GestionBruitage(filename: "ClikBad", volume : 1)
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveMyData(){
        var maData = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        maData.appendPathComponent("saveGame")
        NSKeyedArchiver.archiveRootObject(self.oneProfil, toFile: maData.path)
        
    }
}
