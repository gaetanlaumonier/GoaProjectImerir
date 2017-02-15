//
//  ChoiceClasseTableViewController.swift
//  ProjetImerirApp
//
//  Created by Student on 13/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class ChoiceClasseTableViewController: UITableViewController {

    var AllClasse = [ClasseJoueur]()
    var buttonSender : Int = 10
    var oneProfil = ProfilJoueur(name : "", lifePoint : 0, dict_profil : ["profil_crieur":0, "profil_sociable" : 0, "profil_timide":0, "profil_innovateur":0, "profil_evil":0, "profil_good":0], classeJoueur : "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AllClasse.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classeCell", for: indexPath) as! ClasseTableViewCell

        //soulignement du titre
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: "StringWithUnderLine", attributes: underlineAttribute)
        cell.titleClasseLabel?.attributedText = underlineAttributedString
        
        cell.titleClasseLabel?.text = AllClasse[indexPath.row].nomClasse
        cell.libelleClasse?.text = AllClasse[indexPath.row].libelleClasse
        cell.pouvoirClasse?.text = AllClasse[indexPath.row].pouvoirClasse
        cell.classeButton?.tag = indexPath.row
        
        return cell
    }
    
    @IBAction func ClasseSelected(sender : UIButton){
        buttonSender = sender.tag
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "confirmationSegue" {
            guard buttonSender < 9 else {
        print("buttonSender : ", buttonSender)
                return false
        }
        performSegue(withIdentifier: "confirmationSegue", sender: self)
        return false
            }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmationSegue" {
            let toViewController = segue.destination as! ClasseModalViewController
            let classePlayer = AllClasse[buttonSender].idClasse
            toViewController.classePlayer = classePlayer!
            toViewController.oneProfil = self.oneProfil
        }
    }

}
