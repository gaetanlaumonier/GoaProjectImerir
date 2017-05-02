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
    var ExDialogueNumber : Int = 0
    var nameTap : Bool = false
    var firstDialogue = true
    var oneProfil = ProfilJoueur(name : "", lifePoint : 0, dictProfil : ["profil_crieur":0, "profil_sociable" : 0, "profil_timide":0, "profil_innovateur":0, "profil_evil":0, "profil_good":0], classeJoueur : "", sceneActuelle : 0, bonneReponseQuiz : 0, questionAlreadyPick:[])
    var serieQuestion : [String:Int] = [:]
    var PsychoAnswer = [PsychoDialogue]()
    var playerProfil : String = ""
    var goodOrEvil : String = ""
    var EndGameGesture : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.alpha = 0
        AllDialogue = buildDialogue()
        dialogueLabel.text = AllDialogue[self.oneProfil.sceneActuelle].libelleDialogue[DialogueNumber]
        GestionDialogue()
        GestionBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        FonduApparition(myView: self, myDelai: 1)
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
    
    func ResultatFirstTest(){
        dialogueLabel.text = "\(AllDialogue[self.oneProfil.sceneActuelle].libelleDialogue[DialogueNumber])\(self.oneProfil.bonneReponseQuiz) questions."
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
                UIView.animate(withDuration: 2, delay: 0, options: .transitionCrossDissolve, animations: {
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
        if let vc = UIStoryboard(name:"ArcadeRangement", bundle:nil).instantiateInitialViewController() as? RangementViewController
        {
            UIView.animate(withDuration: 2, delay: 0, options: .transitionCrossDissolve, animations: {
                self.view.alpha = 0
            } , completion: { success in
                vc.oneProfil = self.oneProfil
                self.present(vc, animated: false, completion: nil)
            })
        }else {
            print("Could not instantiate view controller with identifier of type RangementViewController")
            return
        }
        
        
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
    
    func GestionEnd(){
        if self.oneProfil.lifePoint >= 70 {
            self.oneProfil.sceneActuelle += 2
        } else if self.oneProfil.lifePoint >= 40 {
            self.oneProfil.sceneActuelle += 1
        }
        EndGameGesture = false
    }
    
    func DialoguesFinaux(){
        self.oneProfil.sceneActuelle += 3
        UIView.animate(withDuration: 5, animations: {
            self.view.alpha = 0
        }, completion: { sucess in
            self.GestionBackground()
            self.DialogueNumber = 0
            self.firstDialogue = true
            self.GestionDialogue()
            self.FonduApparition(myView: self, myDelai: 1)
        })
    }
    
    func RetourMenu(){
        if let vc = UIStoryboard(name:"Main", bundle:nil).instantiateInitialViewController() as? InitViewController
        {
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
    
    func PsychoResult(){
         PsychoAnswer = buildPsychoDialogue()
         dialogueLabel.text = AllDialogue[self.oneProfil.sceneActuelle].libelleDialogue[DialogueNumber]

            if (self.oneProfil.dictProfil["profil_evil"]?.hashValue)! > (self.oneProfil.dictProfil["profil_good"]?.hashValue)! {
                goodOrEvil = "profil_evil"
            } else if (self.oneProfil.dictProfil["profil_evil"]?.hashValue)! < (self.oneProfil.dictProfil["profil_good"]?.hashValue)!{
                goodOrEvil = "profil_good"
            } else {
                goodOrEvil = "profil_equal"
        }
        
        self.oneProfil.dictProfil["profil_evil"] = nil
        self.oneProfil.dictProfil["profil_good"] = nil
        
        for (key, value) in self.oneProfil.dictProfil {
            if value == self.oneProfil.dictProfil.values.max(){
                playerProfil = key
            }
        }
        ExDialogueNumber = DialogueNumber + 1
        DialogueNumber = 0
        firstDialogue = true
        
        print(playerProfil)
        print(goodOrEvil)
    }

    // MARK: dialogue gesture
    func GestionEnchainementDialogue(){
            if EndGameGesture == false {
                if self.oneProfil.sceneActuelle == 13 && firstDialogue == true {
                    EndGameGesture = true
                    GestionEnd()
                }
                if firstDialogue == false {
                    DialogueNumber += 1
                    if DialogueNumber == AllDialogue[self.oneProfil.sceneActuelle].libelleDialogue.count {
                        //a enlever plus tard
                        if(self.oneProfil.sceneActuelle != 1 || self.oneProfil.sceneActuelle == 5 || self.oneProfil.sceneActuelle == 9 || self.oneProfil.sceneActuelle == 11 || self.oneProfil.sceneActuelle == 0){
                            self.oneProfil.sceneActuelle += 1
                        }
                        firstDialogue = true
                        DialogueNumber = 0
                    }
                } else {
                    firstDialogue  = false
                }
                
            } else {
                GestionEnd()
        }
    }
    
    func GestionStyleDialogue(){
        
        if AllDialogue[self.oneProfil.sceneActuelle].styleLabel.isEmpty {
            dialogueLabel.font = UIFont(name: "Futura", size: self.dialogueLabel.font.pointSize)
            dialogueLabel.textColor = .white

        } else {
            if DialogueNumber >= AllDialogue[self.oneProfil.sceneActuelle].styleLabel.count {
                dialogueLabel.font = UIFont(name: "Futura", size: self.dialogueLabel.font.pointSize)
                dialogueLabel.textColor = .white

            } else if AllDialogue[self.oneProfil.sceneActuelle].styleLabel[DialogueNumber] == "it" {
                dialogueLabel.font = dialogueLabel.font.withTraits(traits: .traitItalic)
                dialogueLabel.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)

            } else {
                dialogueLabel.font = UIFont(name: "Futura", size: self.dialogueLabel.font.pointSize)
                dialogueLabel.textColor = .white

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
            case "GestionPsycho":
                PsychoResult()
                break
            case "DialoguesFinaux":
                DialoguesFinaux()
                break
            case "RetourMenu":
                RetourMenu()
            default:
                dialogueLabel.text = AllDialogue[self.oneProfil.sceneActuelle].libelleDialogue[DialogueNumber]
            break
            }
        } else {
            dialogueLabel.text = AllDialogue[self.oneProfil.sceneActuelle].libelleDialogue[DialogueNumber]
        }
    }
    
    func GestionDialoguePsycho(){
        
        if PsychoAnswer.isEmpty == false {
        
        if firstDialogue == false {
            DialogueNumber += 1
            
        } else {
            firstDialogue  = false
        }
        
            if DialogueNumber >= PsychoAnswer[0].profilEvil.count - 1 && playerProfil != ""{
                DialogueNumber = 0
                playerProfil = ""
            }
            
            if playerProfil != "" {
                switch playerProfil {
                case "profil_crieur":
                        dialogueLabel.text = PsychoAnswer[0].profilCrieur[DialogueNumber]
                    break
                case "profil_sociable":
                    dialogueLabel.text = PsychoAnswer[0].profilSociable[DialogueNumber]
                    break
                case "profil_timide":
                    dialogueLabel.text = PsychoAnswer[0].profilTimide[DialogueNumber]
                    break
                case "profil_innovateur":
                    dialogueLabel.text = PsychoAnswer[0].profilInnovateur[DialogueNumber]
                    break
                default:
                    playerProfil = ""
                    break
                }
            }
        
            if playerProfil == ""{
                switch goodOrEvil {
                case "profil_evil":
                    dialogueLabel.text = PsychoAnswer[0].profilEvil[DialogueNumber]
                    break
                case "profil_good":
                    dialogueLabel.text = PsychoAnswer[0].profilGood[DialogueNumber]
                    break
                case "profil_equal":
                    dialogueLabel.text = PsychoAnswer[0].profilEqual[DialogueNumber]
                default:
                    fatalError("error psycho2 traitment")
                }
                if DialogueNumber == PsychoAnswer[0].profilEvil.count - 1{
                    DialogueNumber = ExDialogueNumber
                    goodOrEvil = ""
                    dialogueLabel.text = AllDialogue[self.oneProfil.sceneActuelle].libelleDialogue[DialogueNumber]
                }
            }
        }
    }
    
    func GestionDialogue(){
        if goodOrEvil == "" {
            GestionEnchainementDialogue()
            GestionStyleDialogue()
            GestionEventDialogue()
        } else {
            GestionDialoguePsycho()
        }
    }
    
    func GestionBackground(){

        if AllDialogue[self.oneProfil.sceneActuelle].backgroundDialogue[1] == "gif"{
    imageBackground.loadGif(name: AllDialogue[self.oneProfil.sceneActuelle].backgroundDialogue[0])
        } else {
            imageBackground.image = UIImage(named: AllDialogue[self.oneProfil.sceneActuelle].backgroundDialogue[0])
        }
    }
    
    @IBAction func DialogueTap(_ sender: UITapGestureRecognizer) {
        GestionDialogue()
    }
    
 
}
