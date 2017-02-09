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
    var oneProfil = ProfilJoueur(name : "I", lifePoint : 0, dict_profil : ["profil_crieur":0, "profil_sociable" : 0, "profil_timide":0, "profil_innovateur":0, "profil_evil":0, "profil_good":0], classeJoueur : "Geek")
    override func viewDidLoad() {
        super.viewDidLoad()
        AllDialogue = buildDialogue()
        print(AllDialogue)
        print(AllDialogue[idDialogueNumber].libelleDialogue[DialogueNumber])
        GestionEvent()
        print(self.oneProfil.name)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func GestionDialogue(){
        dialogueLabel.text = AllDialogue[idDialogueNumber].libelleDialogue[DialogueNumber]
        
    }
    
    func GestionEvent(){
        DialogueNumber += 1
        if DialogueNumber == AllDialogue[idDialogueNumber].libelleDialogue.count {
            DialogueNumber = 0
            idDialogueNumber += 1
        } else {
            
        }
        if AllDialogue[idDialogueNumber].styleLabel.isEmpty {
                print("normal2")
                dialogueLabel.font = UIFont.systemFont(ofSize: self.dialogueLabel.font.pointSize, weight : UIFontWeightRegular)
        } else {
            if DialogueNumber >= AllDialogue[idDialogueNumber].styleLabel.count {
                print("normal3")
                dialogueLabel.font = UIFont.systemFont(ofSize: self.dialogueLabel.font.pointSize, weight : UIFontWeightRegular)
            } else if AllDialogue[idDialogueNumber].styleLabel[DialogueNumber] == "it" {
                dialogueLabel.font = UIFont.italicSystemFont(ofSize: self.dialogueLabel.font.pointSize)
                print("ital")
            } else {
                print("normal")
                dialogueLabel.font = UIFont.systemFont(ofSize: self.dialogueLabel.font.pointSize, weight : UIFontWeightRegular)
            }
            
        }
        print(DialogueNumber)
        dialogueLabel.text = AllDialogue[idDialogueNumber].libelleDialogue[DialogueNumber]

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
    }
    @IBAction func DialogueTap(_ sender: UITapGestureRecognizer) {
        GestionEvent()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
