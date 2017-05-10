//
//  InitViewController.swift
//  GoaProject
//
//  Created by Student on 02/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import AVFoundation

class InitViewController: UIViewController {
    
    @IBOutlet weak var titreLabel: UILabel!
    @IBOutlet weak var newPartieButton: UIButton!
    @IBOutlet weak var quizButton: UIButton!
    
    @IBOutlet weak var DataLoadingButton: DesignableButton!
    @IBOutlet weak var MenuBackgroundView: UIImageView!
    
    @IBOutlet weak var headerView: HeaderView!
    
    var oneProfil = ProfilJoueur(name : "Inconnu", lifePoint : 50, dictProfil : ["profil_crieur":0, "profil_sociable" : 0, "profil_timide":0, "profil_innovateur":0, "profil_evil":0, "profil_good":0], classeJoueur : "Hacker", sceneActuelle : 0, bonneReponseQuiz:0, questionAlreadyPick:[])    
    var backgroundMusicPlayer = AVAudioPlayer()
    var bruitageMusicPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize = UIScreen.main.bounds.size
        print(screenSize.height)
        backgroundMusicPlayer = GestionMusic(filename: "LostJungle")
        MenuBackgroundView.loadGif(name: "LabSortie")

    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
//    override func viewDidAppear(_ animated: Bool) {
//        if let headerViewComponent = Bundle.main.loadNibNamed("HeaderView", owner: nil, options: nil)?.first as? HeaderView {
//            headerViewComponent.frame = CGRect(x:0, y:0, width: view.frame.size.width, height: view.frame.size.height*0.15)
//            
//            print(headerViewComponent.frame)
//            
//            headerViewComponent.timerLabel.text = "40s"
//            self.view.addSubview(headerViewComponent)
//        }}
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    
    
    
    @IBAction func ChargerPartie(_ sender: UIButton) {
       
        var maData = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        maData.appendPathComponent("saveGame")

        if let mySaveData = NSKeyedUnarchiver.unarchiveObject(withFile: maData.path) as? ProfilJoueur {
            print("name", mySaveData.name)
            print("life :", mySaveData.lifePoint)
            print("dict", mySaveData.dictProfil)
            print("bonnereponse", mySaveData.bonneReponseQuiz)
            print("classe", mySaveData.classeJoueur)
            print("questionpick", mySaveData.questionAlreadyPick)
            print("scene", mySaveData.sceneActuelle)
            bruitageMusicPlayer = GestionBruitage(filename: "Air", volume : 0.8)

            if let vc = UIStoryboard(name:"Dialogue", bundle:nil).instantiateInitialViewController() as? DialogueViewController
            {
                UIView.animate(withDuration: 4.5, delay: 0, options: .transitionCrossDissolve, animations: {
                self.view.alpha = 0
                    self.backgroundMusicPlayer.setVolume(0, fadeDuration: 4)
            } , completion: { success in
                self.backgroundMusicPlayer.stop()
                vc.oneProfil = mySaveData
                self.present(vc, animated: false, completion: nil)
            })
            }else {
            print("Could not instantiate view controller with identifier of type DialogueViewController")
            return
            }
        } else {
            bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
            DataLoadingButton.setTitle("Sauvegarde vide", for: .normal)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "testQuiz" {
            
            oneProfil = ProfilJoueur(name : "Inconnu", lifePoint : 50, dictProfil : ["profil_crieur":0, "profil_sociable" : 0, "profil_timide":0, "profil_innovateur":0, "profil_evil":0, "profil_good":0], classeJoueur : "Hacker", sceneActuelle : 0, bonneReponseQuiz:0, questionAlreadyPick:[])
            let toViewController = segue.destination as! QuestionViewController
            toViewController.serieQuestionActive = ["CultureG" : 5, "Info": 5, "Enigme": 4, "Psycho": 0] as [String:Int]
            toViewController.oneProfil = self.oneProfil
//            toViewController.cultureTheme.isHidden = false
//            toViewController.infoTheme.isHidden = false
//            toViewController.enigmeTheme.isHidden = false
//            toViewController.psychoTheme.isHidden = false

        } else if segue.identifier == "choiceName" {
           self.oneProfil = ProfilJoueur(name : "myPlayer", lifePoint : 100, dictProfil : ["profil_crieur":0, "profil_sociable" : 0, "profil_timide":0, "profil_innovateur":0, "profil_evil":0, "profil_good":0], classeJoueur : "", sceneActuelle : 0, bonneReponseQuiz: 0, questionAlreadyPick:[])
            let toViewController = segue.destination as! NameModalViewController
            bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
            toViewController.oneProfil = self.oneProfil

        } else if segue.identifier == "Rangement"{
            oneProfil = ProfilJoueur(name : "Inconnu", lifePoint : 120, dictProfil : ["profil_crieur":0, "profil_sociable" : 0, "profil_timide":0, "profil_innovateur":0, "profil_evil":0, "profil_good":0], classeJoueur : "Fonctionnaire", sceneActuelle : 0, bonneReponseQuiz:0, questionAlreadyPick:[])
            
            let toViewController = segue.destination as! RangementViewController
            toViewController.oneProfil = self.oneProfil
            
        } else if segue.identifier == "Cookie" {
            oneProfil = ProfilJoueur(name : "Inconnu", lifePoint : 120, dictProfil : ["profil_crieur":0, "profil_sociable" : 0, "profil_timide":0, "profil_innovateur":0, "profil_evil":0, "profil_good":0], classeJoueur : "Fonctionnaire", sceneActuelle : 0, bonneReponseQuiz:0, questionAlreadyPick:[])
            let toViewController = segue.destination as! ViewController

            UIView.animate(withDuration: 0, delay: 0, options: .transitionCrossDissolve, animations: {
                self.view.alpha = 0
            } , completion: { success in
                toViewController.oneProfil = self.oneProfil
            })} else if segue.identifier == "Credits" {
    bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
            }
        }
    
    @IBAction func gameOver(_ sender: Any) {
        var maData = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        maData.appendPathComponent("saveGame")
        self.oneProfil = ProfilJoueur(name : "Inconnu", lifePoint : 100, dictProfil : ["profil_crieur":0, "profil_sociable" : 0, "profil_timide":0, "profil_innovateur":0, "profil_evil":0, "profil_good":0], classeJoueur : "Fonctionnaire", sceneActuelle : 0, bonneReponseQuiz:0, questionAlreadyPick:[])
        NSKeyedArchiver.archiveRootObject(self.oneProfil, toFile: maData.path)

    }
}
