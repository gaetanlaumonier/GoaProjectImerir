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
    @IBOutlet weak var DataLoadingButton: DesignableButton!
    @IBOutlet weak var MenuBackgroundView: UIImageView!
    @IBOutlet weak var statsButton: DesignableButton!
    
    var oneProfil = ProfilJoueur()
    var backgroundMusicPlayer = AVAudioPlayer()
    var myBruitageMusicPlayer = AVAudioPlayer()
    var bruitageMusicPlayer = AVAudioPlayer()
    var oneLabel = 0
    var mySaveData = ProfilJoueur()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.alpha = 0
        backgroundMusicPlayer = GestionMusic(filename: "LostJungle")
        MenuBackgroundView.loadGif(name: "LabSortie")
        enabledButton()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        FonduApparition(myView: self, myDelai: 0.5)
    }
    
    @IBAction func ChargerPartie(_ sender: UIButton) {
        
            //            print("name", mySaveData.name)
            //            print("life :", mySaveData.lifePoint)
            //            print("dict", mySaveData.dictProfil)
            //            print("bonnereponse", mySaveData.bonneReponseQuiz)
            //            print("classe", mySaveData.classeJoueur)
            //            print("questionpick", mySaveData.questionAlreadyPick)
            //            print("scene", mySaveData.sceneActuelle)
            myBruitageMusicPlayer = GestionBruitage(filename: "Air", volume : 0.8)
            
            if let vc = UIStoryboard(name:"Dialogue", bundle:nil).instantiateInitialViewController() as? DialogueViewController
            {
                
                UIView.animate(withDuration: 4.5, delay: 0, options: .transitionCrossDissolve, animations: {
                    self.view.alpha = 0
                    self.backgroundMusicPlayer.setVolume(0, fadeDuration: 4)
                } , completion: { success in
                    self.backgroundMusicPlayer.stop()
                    vc.oneProfil = self.mySaveData
                    self.present(vc, animated: false, completion: nil)
                })
            }else {
                print("Could not instantiate view controller with identifier of type DialogueViewController")
                return
            }
        }
    
    @IBAction func StatsButton(_ sender: Any) {
        
                if let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "StatsViewController") as? StatsViewController
                {
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.oneProfil = self.mySaveData
                    self.present(vc, animated: false, completion: nil)
                }else {
                    print("Could not instantiate view controller with identifier of type StatsViewController")
                    return
            }
    }
    
//    func popLabelMessage(message : String){
//        if oneLabel == 0 {
//            oneLabel = 1
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.8, height: view.frame.height * 0.1))
//        label.center.x = view.frame.width/2
//        label.center.y = newPartieButton.frame.origin.y - 40
//        label.textAlignment = .center
//        label.font = UIFont(name: "Futura", size: 17)
//        label.text = message
//        label.setupLabelDynamicSize(fontSize: 17)
//        label.numberOfLines = 0
//        label.layer.shadowOffset = CGSize(width: 1, height: 1)
//        label.layer.shadowOpacity = 1
//        label.layer.shadowRadius = 1
//        label.textColor = UIColor(red: 1, green: 212/255, blue: 24/192, alpha: 0.9)
//        label.alpha = 0
//        self.view.addSubview(label)
//        UIView.animate(withDuration: 0.5, animations: {
//        label.alpha = 1
//        }, completion : { _ in
//            UIView.animate(withDuration: 2, delay: 3, animations: {
//            label.alpha = 0
//            }, completion: { _ in
//           label.removeFromSuperview()
//                self.oneLabel = 0
//                })
//            })
//        }
//    }
    
    func enabledButton(){
        var maData = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        maData.appendPathComponent("saveGame")
        
        if let mySaveData = NSKeyedUnarchiver.unarchiveObject(withFile: maData.path) as? ProfilJoueur {
            //  mySaveData.statsLabyrinthe["timeSpent"]! += 1
            if mySaveData.statsLabyrinthe["timeSpent"]!.hashValue < 1 {
                statsButton.isEnabled = false
                statsButton.alpha = 0.5

            }
        } else {
            statsButton.isEnabled = false
            DataLoadingButton.isEnabled = false
            statsButton.alpha = 0.5
            DataLoadingButton.alpha = 0.5

        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "choiceName" {
            let toViewController = segue.destination as! NameModalViewController
            toViewController.oneProfil = self.oneProfil
        }
        bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
    }
}
