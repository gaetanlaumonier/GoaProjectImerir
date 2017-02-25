//
//  InitViewController.swift
//  GoaProject
//
//  Created by Student on 02/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class InitViewController: UIViewController {
    
    @IBOutlet weak var titreLabel: UILabel!
    @IBOutlet weak var newPartieButton: UIButton!
    @IBOutlet weak var quizButton: UIButton!
    
    @IBOutlet weak var MenuBackgroundView: UIImageView!
    
    @IBOutlet weak var headerView: HeaderView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MenuBackgroundView.loadGif(name: "FinDirecteur")
      
        

    }
    override func viewDidAppear(_ animated: Bool) {
        if let headerView2 = Bundle.main.loadNibNamed("HeaderView", owner: nil, options: nil)?.first as? HeaderView {
            headerView2.frame = CGRect(x:0, y:0, width: view.frame.size.width, height: view.frame.size.height*0.15)
            
            print(headerView2.frame)
            
            headerView2.timerLabel.text = "60s"
            self.view.addSubview(headerView2)
        }}
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "testQuiz" {
            let oneProfil = ProfilJoueur(name : "Inconnu", lifePoint : 50, dict_profil : ["profil_crieur":0, "profil_sociable" : 0, "profil_timide":0, "profil_innovateur":0, "profil_evil":0, "profil_good":0], classeJoueur : "Hacker")
            
            let toViewController = segue.destination as! QuestionViewController
            toViewController.oneProfil = oneProfil
        }
        
        
    }
    
    
}
