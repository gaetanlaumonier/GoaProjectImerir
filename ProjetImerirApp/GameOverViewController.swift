//
//  GameOverView.swift
//  ProjetImerirApp
//
//  Created by Student on 18/04/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import AVFoundation

class GameOverViewController: UIViewController {
    
    var bruitageMusicPlayer = AVAudioPlayer()
    func gameOver(){
    if let vc = UIStoryboard(name:"GameOver", bundle:nil).instantiateInitialViewController() as? GameOverViewController
    {
        UIView.animate(withDuration: 3, delay: 0, options: .transitionCrossDissolve, animations: {
            self.view.alpha = 0
        } , completion: { success in
            self.present(vc, animated: false, completion: nil)
        })
    }else {
    print("Could not instantiate view controller with identifier of type InitViewController")
    return
    }
    
}

    @IBAction func retourMenuButton(_
        sender: Any) {
        if let vc = UIStoryboard(name:"Main", bundle:nil).instantiateInitialViewController() as? InitViewController
        {
           self.bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
            UIView.animate(withDuration: 3, delay: 0, options: .transitionCrossDissolve, animations: {
                self.view.alpha = 0
            } , completion: { success in
                self.present(vc, animated: false, completion: nil)
            })
        }else {
            print("Could not instantiate view controller with identifier of type InitViewController")
            return
        }
    }
}
