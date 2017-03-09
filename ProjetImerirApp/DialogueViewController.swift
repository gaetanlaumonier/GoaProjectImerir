//
//  DialogueViewController.swift
//  GoaProject
//
//  Created by Student on 02/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class DialogueViewController: UIViewController {
    
    @IBOutlet weak var dialogueLabel: UILabel!
    @IBOutlet weak var dialogueView: UIView!
    
    var AllDialogue = [Dialogue]()
    var idDialogueNumber : Int = 0
    var DialogueNumber : Int = 0
    var nameTap : Bool = false
    var firstDialogue = true
    var oneProfil = ProfilJoueur(name : "", lifePoint : 0, dictProfil : ["profil_crieur":0, "profil_sociable" : 0, "profil_timide":0, "profil_innovateur":0, "profil_evil":0, "profil_good":0], classeJoueur : "")
    override func viewDidLoad() {
        super.viewDidLoad()
        AllDialogue = buildDialogue()
        dialogueLabel.text = AllDialogue[idDialogueNumber].libelleDialogue[DialogueNumber]
        GestionDialogue()        
        print(oneProfil.name)
        print(oneProfil.lifePoint)
        print(oneProfil.classeJoueur)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func NomExcla(){
      
        dialogueLabel.text = "\(AllDialogue[idDialogueNumber].libelleDialogue[DialogueNumber])\(self.oneProfil.name) !"
        
        guard AllDialogue[idDialogueNumber].styleLabel.isEmpty  else {
            guard DialogueNumber >= AllDialogue[idDialogueNumber].styleLabel.count else {
             if AllDialogue[idDialogueNumber].styleLabel[DialogueNumber] == "it" {
                dialogueLabel.text? += "\""
                }
                return
            }
            return
        }
    }
    
    func NomInt(){
        dialogueLabel.text = "\(AllDialogue[idDialogueNumber].libelleDialogue[DialogueNumber])\(self.oneProfil.name) ?"
        
    }
    
    func ChoixClasse(){
        if let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "choixClasse") as? ChoiceClasseViewController
        {
            print("ok2")
            vc.oneProfil = self.oneProfil
            present(vc, animated: true, completion: nil)
        }else {
            print("Could not instantiate view controller with identifier of type ChoiceClasseTableViewController")
            return
        }
 

    }
    
    func GestionEnchainementDialogue(){
        if firstDialogue == false {
        DialogueNumber += 1
        if DialogueNumber == AllDialogue[idDialogueNumber].libelleDialogue.count {
            //firstDialogue = true
            DialogueNumber = 0
            idDialogueNumber += 1
            }
        } else {
            firstDialogue  = false
        }
    }
    
    func GestionStyleDialogue(){
        if AllDialogue[idDialogueNumber].styleLabel.isEmpty {
            dialogueLabel.font = UIFont.systemFont(ofSize: self.dialogueLabel.font.pointSize, weight : UIFontWeightRegular)
        } else {
            if DialogueNumber >= AllDialogue[idDialogueNumber].styleLabel.count {
                dialogueLabel.font = UIFont.systemFont(ofSize: self.dialogueLabel.font.pointSize, weight : UIFontWeightRegular)
            } else if AllDialogue[idDialogueNumber].styleLabel[DialogueNumber] == "it" {
                dialogueLabel.font = UIFont.italicSystemFont(ofSize: self.dialogueLabel.font.pointSize)
            } else {
                dialogueLabel.font = UIFont.systemFont(ofSize: self.dialogueLabel.font.pointSize, weight : UIFontWeightRegular)
            }
        
        }
    }
    

    func GestionEventDialogue(){
      
        if AllDialogue[idDialogueNumber].eventDialogue[DialogueNumber] != "nil" {
//        let event = AllDialogue[idDialogueNumber].eventDialogue[DialogueNumber]
//        let selector = NSSelectorFromString(event)
//        //let _ = #selector(selector)
//        selector
//        } else {
//            dialogueLabel.text = AllDialogue[idDialogueNumber].libelleDialogue[DialogueNumber]
//        }
            switch AllDialogue[idDialogueNumber].eventDialogue[DialogueNumber] {
            case "NomExcla" :
                NomExcla()
                break
            case "NomInt":
                NomInt()
                break
            case "ChoixClasse":
                print("ok")
                ChoixClasse()
                break
            default:
                dialogueLabel.text = AllDialogue[idDialogueNumber].libelleDialogue[DialogueNumber]
            break
            }
        } else {
            print("lala")
            dialogueLabel.text = AllDialogue[idDialogueNumber].libelleDialogue[DialogueNumber]
        }
    }
    func GestionDialogue(){
        
            GestionEnchainementDialogue()
            GestionStyleDialogue()
            GestionEventDialogue()
    }
//        switch AllDialogue[idDialogueNumber].eventDialogue[DialogueNumber]{
//        case "nil":
//            GestionDialogue()
//            
//            break
//            
//        case "choixClasse":
//            break
//            
//        default:
//            print("Problème avec l'évènement du dialogue")
//            break
//        }

    
    
    @IBAction func DialogueTap(_ sender: UITapGestureRecognizer) {
        GestionDialogue()
    }
    
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "choixClasseSegue" {
            let toViewController = segue.destination as! ChoiceClasseViewController
            toViewController.oneProfil = self.oneProfil
            //self.dismiss(animated: false, completion: nil)
        }
     }
 
    
}
