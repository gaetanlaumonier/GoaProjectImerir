//
//  Parametres.swift
//  ProjetImerirApp
//
//  Created by Student on 24/04/2017.
//  Copyright © 2017 Student. All rights reserved.
//
import UIKit

class ParametresViewController: UIViewController {

var myPresentingViewController = UIViewController()
    
    override func viewDidLoad() {
        myPresentingViewController = self.presentingViewController!
               switch myPresentingViewController as UIViewController {
            case is QuestionViewController:
                let presentingViewType = myPresentingViewController as! QuestionViewController
                presentingViewType.startTimer.invalidate()
            break
        case is ViewController:
            let presentingViewType = myPresentingViewController as! ViewController
            presentingViewType.myTimer.invalidate()
            presentingViewType.gamePause = true
            break
        case is RangementViewController:
            let presentingViewType = myPresentingViewController as! RangementViewController
            presentingViewType.endGameTimer.invalidate()
            presentingViewType.gamePause = true
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
        
            UIView.animate(withDuration: 2, delay: 0, options: .transitionCrossDissolve, animations: {
                self.view.alpha = 0
            } , completion: { success in
                self.present(vc, animated: false, completion: nil)
            })
        }else {
            print("Could not instantiate view controller with identifier of type InitViewController")
            return
        }
    }
    
    @IBAction func restartButton(_ sender: UIButton) {
        switch myPresentingViewController as UIViewController {
        case is QuestionViewController:
            let presentingViewType = myPresentingViewController as! QuestionViewController
            presentingViewType.startTimer = Timer.scheduledTimer(timeInterval: 1, target: presentingViewType, selector: #selector(presentingViewType.GestionTimer), userInfo: nil, repeats: true)
            break
        case is ViewController:
            let presentingViewType = myPresentingViewController as! ViewController
            presentingViewType.myTimer = Timer.scheduledTimer(timeInterval: 1, target: presentingViewType, selector: #selector(ViewController.TimerGesture), userInfo: nil, repeats: true)
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
        default:
            print("No timer")
            break
        }

        self.dismiss(animated: true, completion: nil)
    }
    
//    func headerViewExist(vc : String) -> Bool {
//        
//    }
}
