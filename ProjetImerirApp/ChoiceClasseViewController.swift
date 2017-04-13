//
//  ChoiceClasseTableViewController.swift
//  ProjetImerirApp
//
//  Created by Student on 13/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class ChoiceClasseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var AllClasse = [ClasseJoueur]()
    var buttonSender : Int = 10
    var oneProfil = ProfilJoueur(name : "", lifePoint : 0, dictProfil : ["profil_crieur":0, "profil_sociable" : 0, "profil_timide":0, "profil_innovateur":0, "profil_evil":0, "profil_good":0], classeJoueur : "", sceneActuelle: 0, bonneReponseQuiz : 0, questionAlreadyPick:[])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.alpha = 0
        UIView.animate(withDuration: 1, delay: 0, options: .transitionCrossDissolve, animations: {
            self.view.alpha = 1
        } , completion: nil)
        AllClasse = buildClasseJoueur()
        tableView.allowsSelection = false
        print(oneProfil.name)
        print(oneProfil.lifePoint)
        print(oneProfil.classeJoueur)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AllClasse.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classeCell", for: indexPath) as! ClasseTableViewCell
        
        //soulignement du titre
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
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
