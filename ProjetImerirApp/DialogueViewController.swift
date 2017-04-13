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
    @IBOutlet weak var imageBackground: UIImageView!
    
    var AllDialogue = [Dialogue]()
    var DialogueNumber : Int = 0
    var nameTap : Bool = false
    var firstDialogue = true
    var oneProfil = ProfilJoueur(name : "", lifePoint : 0, dictProfil : ["profil_crieur":0, "profil_sociable" : 0, "profil_timide":0, "profil_innovateur":0, "profil_evil":0, "profil_good":0], classeJoueur : "", sceneActuelle : 0, bonneReponseQuiz : 0, questionAlreadyPick:[])
    var serieQuestion : [String:Int] = [:]
   
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.alpha = 0
//        UIView.animate(withDuration: 5, delay: 0, options: .transitionCrossDissolve, animations: {
//            self.view.alpha = 1
//        } , completion: nil)
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
            UIView.animate(withDuration: 1, delay: 0, options: .transitionCrossDissolve, animations: {
                self.view.alpha = 0
            } , completion: { success in
                vc.oneProfil = self.oneProfil
                self.present(vc, animated: false, completion: nil)
            })
        }else {
            print("Could not instantiate view controller with identifier of type ChoiceClasseTableViewController")
            return
        }
 

    }
    
    func SerieQuestion1(){
        GestionSerieQuestion(CultureG: 5, Info: 5, Enigme: 4, Psycho: 0)
    }
    
    func SerieQuestion2(){
        GestionSerieQuestion(CultureG: 0, Info: 7, Enigme: 3, Psycho: 5)
    }
    
    func SerieQuestion3(){
        GestionSerieQuestion(CultureG: 5, Info: 5, Enigme: 3, Psycho: 0)
    }
    
    func SerieQuestion4(){
        GestionSerieQuestion(CultureG: 0, Info: 0, Enigme: 3, Psycho: 5)
    }
    
    func GestionSerieQuestion(CultureG :Int, Info: Int, Enigme: Int, Psycho: Int){
        serieQuestion = ["CultureG" : CultureG, "Info": Info, "Enigme": Enigme, "Psycho": Psycho] as [String:Int]
        if serieQuestion["Enigme"] != 1 {
            if let vc = UIStoryboard(name:"Quiz", bundle:nil).instantiateViewController(withIdentifier: "Question") as? QuestionViewController
            {
                vc.serieQuestionActive = self.serieQuestion
                UIView.animate(withDuration: 2, delay: 0, options: .transitionCrossDissolve, animations: {
                   self.view.alpha = 0
                } , completion: { success in
                    vc.oneProfil = self.oneProfil
                    self.present(vc, animated: false, completion: nil)
                })
            }else {
                print("Could not instantiate view controller with identifier of type QuestionViewController")
                return
            }
        }
    }
    
    func ArcadeCookieStart(){
            if let vc = UIStoryboard(name:"ArcadeCookie", bundle:nil).instantiateInitialViewController() as? ViewController
            {
                UIView.animate(withDuration: 3, delay: 0, options: .transitionCrossDissolve, animations: {
                    self.view.alpha = 0
                } , completion: { success in
                    vc.oneProfil = self.oneProfil
                    self.present(vc, animated: false, completion: nil)
                })
            }else {
                print("Could not instantiate view controller with identifier of type ArcadeViewController")
                return
        }
    }
    
    func ArcadeRangementStart(){
        print("ArcadeRangement")

        
        
    }
    
    func LabyrintheStart(){
        
        print("Labyrinthe")

        
    }
    
    func ArcadeConsoleStart(){
        
        print("ArcadeConsole")

        
    }
    
    func ArcadeBacStart(){
        print("ArcadeBac")
        
        
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
            case "ArcadeCookie":
                ArcadeCookieStart()
            case "ArcadeRangement":
                ArcadeRangementStart()
                break
            case "Labyrinthe":
                LabyrintheStart()
                break
            case "ArcadeConsole":
                ArcadeConsoleStart()
                break
            case "ArcadeBac":
                ArcadeBacStart()
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
