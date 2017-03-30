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
    var DialogueNumber : Int = 0
    var nameTap : Bool = false
    var firstDialogue = true
    var oneProfil = ProfilJoueur(name : "", lifePoint : 0, dictProfil : ["profil_crieur":0, "profil_sociable" : 0, "profil_timide":0, "profil_innovateur":0, "profil_evil":0, "profil_good":0], classeJoueur : "", sceneActuelle : 0, bonneReponseQuiz : 0)
    var serieQuestion : [String:Int] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        AllDialogue = buildDialogue()
        dialogueLabel.text = AllDialogue[self.oneProfil.sceneActuelle].libelleDialogue[DialogueNumber]
        GestionDialogue()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: event function
    func NomExcla(){
      
        dialogueLabel.text = "\(AllDialogue[self.oneProfil.sceneActuelle].libelleDialogue[DialogueNumber])\(self.oneProfil.name) !"
        
        guard AllDialogue[self.oneProfil.sceneActuelle].styleLabel.isEmpty  else {
            guard DialogueNumber >= AllDialogue[self.oneProfil.sceneActuelle].styleLabel.count else {
             if AllDialogue[self.oneProfil.sceneActuelle].styleLabel[DialogueNumber] == "it" {
                dialogueLabel.text? += "\""
                }
                return
            }
            return
        }
    }
    
    func NomInt(){
        dialogueLabel.text = "\(AllDialogue[self.oneProfil.sceneActuelle].libelleDialogue[DialogueNumber])\(self.oneProfil.name) ?"
        
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
    
    func SerieQuestion1(){
        GestionSerieQuestion(cultureG: 5, info: 5, enigme: 4, psycho: 0)
    }
    
    func SerieQuestion2(){
        GestionSerieQuestion(cultureG: 0, info: 7, enigme: 3, psycho: 5)
    }
    
    func SerieQuestion3(){
        GestionSerieQuestion(cultureG: 5, info: 5, enigme: 3, psycho: 0)
    }
    
    func SerieQuestion4(){
        GestionSerieQuestion(cultureG: 0, info: 0, enigme: 3, psycho: 5)
    }
    
    func GestionSerieQuestion(cultureG :Int, info: Int, enigme: Int, psycho: Int){
        serieQuestion = ["cultureG" : cultureG, "info": info, "enigme": enigme, "psycho": psycho] as [String:Int]
        if serieQuestion["enigme"] != 1 {
            if let vc = UIStoryboard(name:"Quiz", bundle:nil).instantiateViewController(withIdentifier: "Question") as? QuestionViewController
            {
                vc.serieQuestionActive = self.serieQuestion
                vc.oneProfil = self.oneProfil
                present(vc, animated: true, completion: nil)
            }else {
                print("Could not instantiate view controller with identifier of type QuestionViewController")
                return
            }
        }
    }
    
    func ResultatFirstTest(){
    dialogueLabel.text = "\(AllDialogue[self.oneProfil.sceneActuelle].libelleDialogue[DialogueNumber])\(self.oneProfil.bonneReponseQuiz) questions."
    }
    
    // MARK: dialogue gesture
    func GestionEnchainementDialogue(){
        if firstDialogue == false {
        DialogueNumber += 1
        if DialogueNumber == AllDialogue[self.oneProfil.sceneActuelle].libelleDialogue.count {
            //a enlever plus tard
            if(self.oneProfil.sceneActuelle != 1 || self.oneProfil.sceneActuelle == 5 || self.oneProfil.sceneActuelle == 9 || self.oneProfil.sceneActuelle == 11 || self.oneProfil.sceneActuelle == 0){
                self.oneProfil.sceneActuelle += 1
            }
            DialogueNumber = 0
            }
        } else {
            firstDialogue  = false
        }
    }
    
    func GestionStyleDialogue(){
        if AllDialogue[self.oneProfil.sceneActuelle].styleLabel.isEmpty {
            dialogueLabel.font = UIFont(name: "Futura", size: self.dialogueLabel.font.pointSize)
        } else {
            if DialogueNumber >= AllDialogue[self.oneProfil.sceneActuelle].styleLabel.count {
                dialogueLabel.font = UIFont(name: "Futura", size: self.dialogueLabel.font.pointSize)
            } else if AllDialogue[self.oneProfil.sceneActuelle].styleLabel[DialogueNumber] == "it" {
                dialogueLabel.font = dialogueLabel.font.withTraits(traits: .traitItalic)
            } else {
                dialogueLabel.font = UIFont(name: "Futura", size: self.dialogueLabel.font.pointSize)
            }
        
        }
    }
    

    func GestionEventDialogue(){
      
        if AllDialogue[self.oneProfil.sceneActuelle].eventDialogue[DialogueNumber] != "nil" {
//        let event = AllDialogue[self.oneProfil.sceneActuelle].eventDialogue[DialogueNumber]
//        let selector = NSSelectorFromString(event)
//        //let _ = #selector(selector)
//        selector
//        } else {
//            dialogueLabel.text = AllDialogue[self.oneProfil.sceneActuelle].libelleDialogue[DialogueNumber]
//        }
            switch AllDialogue[self.oneProfil.sceneActuelle].eventDialogue[DialogueNumber] {
            case "NomExcla" :
                NomExcla()
                break
            case "NomInt":
                NomInt()
                break
            case "ChoixClasse":
                ChoixClasse()
                break
            case "SerieQuestion1":
                SerieQuestion1()
                break
            case "SerieQuestion2":
                SerieQuestion2()
                break
            case "SerieQuestion3":
                SerieQuestion3()
                break
            case "SerieQuestion4":
                SerieQuestion4()
                break
            case "resultatTest":
                ResultatFirstTest()
                break
            default:
                dialogueLabel.text = AllDialogue[self.oneProfil.sceneActuelle].libelleDialogue[DialogueNumber]
            break
            }
        } else {
            dialogueLabel.text = AllDialogue[self.oneProfil.sceneActuelle].libelleDialogue[DialogueNumber]
        }
    }
    func GestionDialogue(){
        
            GestionEnchainementDialogue()
            GestionStyleDialogue()
            GestionEventDialogue()
    }
//        switch AllDialogue[self.oneProfil.sceneActuelle].eventDialogue[DialogueNumber]{
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
    
    // MARK: segue gesture
    
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "Quiz" {
//            let toViewController = segue.destination as! QuestionViewController
//            toViewController.oneProfil = self.oneProfil
//            toViewController.serieQuestionActive = self.serieQuestion
//            //self.dismiss(animated: false, completion: nil)
//        }
//     }
 
}
