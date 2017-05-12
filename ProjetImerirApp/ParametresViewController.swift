//
//  Parametres.swift
//  ProjetImerirApp
//
//  Created by Student on 24/04/2017.
//  Copyright © 2017 Student. All rights reserved.
//
import UIKit
import AVFoundation

class ParametresViewController: UIViewController {

var myPresentingViewController = UIViewController()
var bruitageMusicPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        self.view.alpha = 0
        bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
        myPresentingViewController = self.presentingViewController!
               switch myPresentingViewController as UIViewController {
            case is QuestionViewController:
                let presentingViewType = myPresentingViewController as! QuestionViewController
                presentingViewType.startTimer.invalidate()
            break
        case is CookieViewController:
            let presentingViewType = myPresentingViewController as! CookieViewController
            presentingViewType.myTimer.invalidate()
            presentingViewType.gamePause = true
            break
        case is RangementViewController:
            let presentingViewType = myPresentingViewController as! RangementViewController
            presentingViewType.endGameTimer.invalidate()
            presentingViewType.gamePause = true
            break
               case is LabyrintheViewController:
                let presentingViewType = myPresentingViewController as! LabyrintheViewController
                if presentingViewType.isFirstMaze {
                presentingViewType.firstGameTimer.invalidate()
                }
                break
        default:
            print("No timer")
            break
                    }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        FonduApparition(myView: self, myDelai: 1)
    }
    
    @IBAction func exitButton(_ sender: UIButton) {
        if let vc = UIStoryboard(name:"Main", bundle:nil).instantiateInitialViewController() as? InitViewController
        {
            myPresentingViewController.view.alpha = 0
            bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
           
            switch myPresentingViewController as UIViewController {
            case is QuestionViewController:
                let presentingViewType = myPresentingViewController as! QuestionViewController
                 UIView.animate(withDuration: 2.5, animations: {
                    self.view.alpha = 0
                    presentingViewType.backgroundMusicPlayer.setVolume(0, fadeDuration: 2)
                 }, completion : { _ in
                    presentingViewType.backgroundMusicPlayer.stop()
                    self.present(vc, animated: false)
                 })
                break
            case is CookieViewController:
                let presentingViewType = myPresentingViewController as! CookieViewController
                 UIView.animate(withDuration: 2.5, animations: {
                    self.view.alpha = 0
                    presentingViewType.backgroundMusicPlayer.setVolume(0, fadeDuration: 2)
                 }, completion : { _ in
                    presentingViewType.backgroundMusicPlayer.stop()
                    self.present(vc, animated: false)
                 })
                break
            case is RangementViewController:
                let presentingViewType = myPresentingViewController as! RangementViewController
                 UIView.animate(withDuration: 2.5, animations: {
                    self.view.alpha = 0
                    presentingViewType.backgroundMusicPlayer.setVolume(0, fadeDuration: 2)
                 }, completion : { _ in
                    presentingViewType.backgroundMusicPlayer.stop()
                    self.present(vc, animated: false)
                 })
                
                break
            case is LabyrintheViewController:
                let presentingViewType = myPresentingViewController as! LabyrintheViewController
                UIView.animate(withDuration: 2.5, animations: {
                    self.view.alpha = 0
                    presentingViewType.backgroundMusicPlayer.setVolume(0, fadeDuration: 2)
                }, completion : { _ in
                    presentingViewType.backgroundMusicPlayer.stop()
                    self.present(vc, animated: false)
                })
                
                break
            default:
                print("Not good viewController")
                break
            }
        }else {
            print("Could not instantiate view controller with identifier of type InitViewController")
            return
        }
    }
    
    @IBAction func restartButton(_ sender: UIButton) {
        bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
        switch myPresentingViewController as UIViewController {
        case is QuestionViewController:
            let presentingViewType = myPresentingViewController as! QuestionViewController
            presentingViewType.startTimer = Timer.scheduledTimer(timeInterval: 1, target: presentingViewType, selector: #selector(presentingViewType.GestionTimer), userInfo: nil, repeats: true)
            break
        case is CookieViewController:
            let presentingViewType = myPresentingViewController as! CookieViewController
            presentingViewType.myTimer = Timer.scheduledTimer(timeInterval: 1, target: presentingViewType, selector: #selector(CookieViewController.TimerGesture), userInfo: nil, repeats: true)
            presentingViewType.gamePause = false

            break
        case is RangementViewController:
            let presentingViewType = myPresentingViewController as! RangementViewController
            presentingViewType.gamePause = false
            presentingViewType.endGameTimer = Timer.scheduledTimer(withTimeInterval: 0.1 * presentingViewType.slowGameFactor, repeats: true, block: {_ in
                if presentingViewType.timeLeft > 0 {
                    presentingViewType.timeLeft -= 0.1
                    presentingViewType.headerView.timerLabel.text = "\(Int(presentingViewType.timeLeft)) s"
                } else {
                    presentingViewType.endGame()
                }
            })
            break
        case is LabyrintheViewController:
            let presentingViewType = myPresentingViewController as! LabyrintheViewController
            if presentingViewType.isFirstMaze {
                presentingViewType.firstGameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                    presentingViewType.elapsedTime += 1
                    if presentingViewType.elapsedTime >= 30 {
                        presentingViewType.endGame()
                    }
                })
            }
            break
        default:
            print("No timer")
            break
        }

        dismiss(animated: true, completion: nil)
    }
    
//    func headerViewExist(vc : String) -> Bool {
//        
//    }
}
