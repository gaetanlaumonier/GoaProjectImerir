//
//  ChoiceClasseTableViewController.swift
//  ProjetImerirApp
//
//  Created by Student on 13/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import AVFoundation
import UIKit

class ChoiceClasseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var AllClasse = [ClasseJoueur]()
    var buttonSender : Int = 10
    var oneProfil = ProfilJoueur()
    var bruitageMusicPlayer = AVAudioPlayer()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.alpha = 0
        AllClasse = buildClasseJoueur()
        tableView.allowsSelection = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        FonduApparition(myView: self, myDelai: 1)
        tableView.flashScrollIndicators()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllClasse.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classeCell", for: indexPath) as! ClasseTableViewCell
        
        //soulignement du titre
        let underlineAttribute = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: "StringWithUnderLine", attributes: underlineAttribute)
        cell.titleClasseLabel?.attributedText = underlineAttributedString
        
        cell.titleClasseLabel?.text = AllClasse[indexPath.row].nomClasse
        cell.imageClasse?.image = UIImage(named : AllClasse[indexPath.row].idClasse )
        cell.libelleClasse?.text = AllClasse[indexPath.row].libelleClasse
        cell.pouvoirClasse?.text = AllClasse[indexPath.row].pouvoirClasse
        cell.classeButton?.tag = indexPath.row
        
        return cell
    }
    
    @IBAction func ClasseSelected(sender : UIButton){
        buttonSender = sender.tag
        bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "confirmationClasseSegue" {
            guard buttonSender < 9 else {
                print("buttonSender : ", buttonSender)
                return false
            }
            performSegue(withIdentifier: "confirmationClasseSegue", sender: self)
            return false
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmationClasseSegue" {
            let toViewController = segue.destination as! ClasseModalViewController
            let classePlayer = AllClasse[buttonSender].idClasse
            toViewController.classePlayer = classePlayer!
            toViewController.oneProfil = self.oneProfil
            
        }
    }
    
}
