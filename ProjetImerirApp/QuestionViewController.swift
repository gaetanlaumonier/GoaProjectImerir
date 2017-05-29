
import UIKit
import AVFoundation

class QuestionViewController: UIViewController {
    
    @IBOutlet weak var BackgroundVIew: UIImageView!
    @IBOutlet var Buttons : [UIButton]!
    @IBOutlet weak var themeActif: DesignableLabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var dialogueLabel: UILabel!
    @IBOutlet weak var resultatLabel: UILabel!
    @IBOutlet weak var bonneReponseLabel: UILabel!
    @IBOutlet weak var dialogueView: UIView!
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var InputAnswer: UITextField!
    @IBOutlet weak var resultatView: UIView!
    @IBOutlet weak var inputButtonValidate: UIButton!
    @IBOutlet weak var hackButton: UIButton!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var saisieReponseLabel: DesignableLabel!
    
    
    var QuestionsComplete = [Question]()
    var AllAnswersReactions = [AnswersReactions]()
    var AllClasseJoueur = [ClasseJoueur]()
    var TableauInfo : [Question] = []
    var TableauCulture : [Question] = []
    var TableauEnigme : [Question] = []
    var TableauPsycho : [Question] = []
    var themeQuestionActif = [Question]()
    var oneProfil = ProfilJoueur()
    var QuestionNumber : Int = 0
    var QuestionPose : Int = 0
    var messageSpecialLabel : Int = 0
    var countSeconde : Float = 0
    var reponseTrouverInput : Bool = false
    var resultatVrai = Int()
    var actionResultat = Int()
    var startTimer = Timer()
    var chanceDuNoob : Bool = false
    var modeHackeurActive : Bool = false
    var multiplicateurFonctionnaire : Float = 1
    var serieQuestionActive : [String:Int] = ["CultureG" : 0, "Info": 0, "Enigme": 0, "Psycho": 0]
    var nbrQuestionSerie : Int = 0
    var endSerie : Bool = false
    var idQuestion : [String:Int] = ["CultureG" : 0, "Info": 0, "Enigme": 0, "Psycho": 0]
    var backgroundMusicPlayer = AVAudioPlayer()
    var bruitageMusicPlayer = AVAudioPlayer()
    var readyPopup: UIView!
    
    //Chargement du json, création du tableau des questions, 1ère question
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.alpha = 0
        QuestionMusicGesture()
        QuestionsComplete = buildQuestions()
        AllAnswersReactions = buildAnswersReactions()
        AllClasseJoueur = buildClasseJoueur()
        EffetClasse()
        headerView.lifePointLabel.text = "\(self.oneProfil.lifePoint) PV"
        headerView.timerLabel.textColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        
        nbrQuestionSerie = (serieQuestionActive["CultureG"]!.hashValue + serieQuestionActive["Info"]!.hashValue + serieQuestionActive["Enigme"]!.hashValue + serieQuestionActive["Psycho"]!.hashValue)
        
        for number in self.oneProfil.questionAlreadyPick {
            QuestionsComplete[number].AlreadyPick = true
        }
        
        for j in 0..<QuestionsComplete.count{
            
            switch QuestionsComplete[j].Topic{
            case "Info":
                TableauInfo.append(QuestionsComplete[j])
                break
            case "CultureG":
                TableauCulture.append(QuestionsComplete[j])
                break
            case "Enigme":
                TableauEnigme.append(QuestionsComplete[j])
                break
            case "Psycho":
                TableauPsycho.append(QuestionsComplete[j])
                break
            default:
                break
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        hackButton.layer.cornerRadius = view.bounds.width / 20
        
        FonduApparition(myView: self, myDelai: 1)
        
        // Appuyer sur l'écran pour commencer la série
        readyPopup = endGamePopup(text: "Appuie sur l'écran pour commencer la série de questions.", onClick: #selector(pickFirstQuestion))
    }
    
    func pickFirstQuestion() {
        readyPopup.removeFromSuperview()
        PickQuestion()
    }
    
    //Gère les séries de question
    func SerieQuestionGestion(){
        
        if serieQuestionActive["CultureG"]!>0 && idQuestion["CultureG"]! < serieQuestionActive["CultureG"]!{
            themeQuestionActif = TableauCulture
            themeActif.text = "Culture Générale"
        } else if serieQuestionActive["Info"]!>0 && idQuestion["Info"]! < serieQuestionActive["Info"]!{
            themeQuestionActif = TableauInfo
            themeActif.text = "Culture Informatique"
        } else if serieQuestionActive["Enigme"]!>0 && idQuestion["Enigme"]! < serieQuestionActive["Enigme"]!{
            themeQuestionActif = TableauEnigme
            themeActif.text = "Enigme"
        } else if serieQuestionActive["Psycho"]!>0 && idQuestion["Psycho"]! < serieQuestionActive["Psycho"]!{
            themeQuestionActif = TableauPsycho
            themeActif.text = "Psychologie"
        } else {
            if self.oneProfil.sceneActuelle == 1{
                self.oneProfil.lifePoint = self.oneProfil.lifePoint + (self.oneProfil.statsQuiz["bonneReponseQuiz"]! * 2)
            }
            if let vc = UIStoryboard(name:"Dialogue", bundle:nil).instantiateViewController(withIdentifier: "Dialogue") as? DialogueViewController
            {
                endSerie = true
                self.oneProfil.sceneActuelle += 1
                UIView.animate(withDuration: 2, delay: 0, options: .transitionCrossDissolve, animations: {
                    self.view.alpha = 0
                    self.backgroundMusicPlayer.setVolume(0, fadeDuration: 1.5)
                } , completion: { success in
                    self.backgroundMusicPlayer.stop()
                    vc.oneProfil = self.oneProfil
                    self.saveMyData()
                    self.view.window?.rootViewController = vc
                    
                })
            }else {
                print("Could not instantiate view controller with identifier of type DialogueViewController")
                return
            }
        }
    }
    
    //Rend caché les éléments de l'AnswerView
    func QuestionInit(){
        
        self.saisieReponseLabel.alpha = 0
        self.saisieReponseLabel.textColor = .white
        self.InputAnswer.alpha = 0
        self.inputButtonValidate.alpha = 0
        self.resultatLabel.alpha = 0
        self.bonneReponseLabel.alpha = 0
        self.dialogueView.alpha = 0
        self.resultatView.alpha = 0
        self.dialogueLabel.alpha = 0
        self.dialogueView.isHidden = true
        self.dialogueLabel.text = ""
        self.resultatLabel.text = ""
        self.bonneReponseLabel.text = ""
        
        for i in 0..<Buttons.count{
            Buttons[i].center.x = self.view.frame.width + (self.questionView.bounds.width/2 + 10)
        }
        
        
    }
    
    //Pose une question qui n'a pas été posée, lance le timer...
    func PickQuestion(){
        SerieQuestionGestion()
        QuestionInit()
        
        if themeQuestionActif.count > 0 && QuestionPose < themeQuestionActif.count && endSerie == false{
            QuestionNumber = Int(arc4random_uniform(UInt32(themeQuestionActif.count)))
            while themeQuestionActif[QuestionNumber].AlreadyPick == true {
                QuestionNumber = Int(arc4random_uniform(UInt32(themeQuestionActif.count)))
            }
            questionLabel.text = themeQuestionActif[QuestionNumber].Question
            formatAnswers()
            if themeQuestionActif[QuestionNumber].Timer != 0 {
                headerView.timerLabel?.isHidden = false
                countSeconde = Float(themeQuestionActif[QuestionNumber].Timer) * multiplicateurFonctionnaire
                hackFunction()
                headerView.timerLabel?.text = "\(Int(countSeconde))s"
                startTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(QuestionViewController.GestionTimer), userInfo: nil, repeats: true)
                
            } else {
                headerView.timerLabel?.isHidden = true
                startTimer.invalidate()
            }
            
            messageSpecialLabel = 0
        }else{
            themeActif.text = ""
            questionLabel.text = "Fin de la série de question"
        }
    }
    
    //Interprète la classe du joueur
    func EffetClasse(){
        switch self.oneProfil.classeJoueur{
        case "Noob":
            chanceDuNoob = true
            break
        case "Hacker":
            modeHackeurActive = true
            break
        case "Fonctionnaire":
            multiplicateurFonctionnaire = 1.4
            break
        default:
            break
        }
        
    }
    
    //Gère le bonus du Hacker
    func hackFunction(){
        if modeHackeurActive == true {
            let ApparitionRandom = Int(arc4random_uniform(UInt32(3)))
            if ApparitionRandom == 2{
                hackButton.isHidden = false
            }
        }
    }
    
    //Gère le bonus du Noob
    func VerifNoobFunction(){
        if chanceDuNoob == true {
            let intChanceDuNoob = Int(arc4random_uniform(UInt32(5)))
            if intChanceDuNoob == 2 {
                resultatLabel.text = "\(AllAnswersReactions[0].chanceDuNoob[actionResultat]) \(Int(themeQuestionActif[QuestionNumber].HPLost!)) PV."
                self.oneProfil.lifePoint += themeQuestionActif[QuestionNumber].HPLost!
                changeColorLabelGood(label: headerView.lifePointLabel)
            } else {
                resultatLabel.text = "\(AllAnswersReactions[0].mauvaiseReponse[resultatVrai])\(AllAnswersReactions[0].pertePVReponse[actionResultat])\(Int(themeQuestionActif[QuestionNumber].HPLost!)) PV."
                changeColorLabelBad(label: headerView.lifePointLabel)
                self.oneProfil.lifePoint -= themeQuestionActif[QuestionNumber].HPLost!
            }
        }else {
            resultatLabel.text = "\(AllAnswersReactions[0].mauvaiseReponse[resultatVrai])\(AllAnswersReactions[0].pertePVReponse[actionResultat])\(Int(themeQuestionActif[QuestionNumber].HPLost!)) PV."
            changeColorLabelBad(label: headerView.lifePointLabel)
            self.oneProfil.lifePoint -= themeQuestionActif[QuestionNumber].HPLost!
        }
    }
    
    //Clique sur le bouton de la réponse A
    @IBAction func AButton(_ sender: UIButton) {
        if themeQuestionActif[QuestionNumber].Topic == "Psycho"{
            resultatReponseSwitch(stringReponse: "0", typeOfQuestion : "Psycho")
        } else {
            resultatReponseSwitch(stringReponse: Buttons[0].currentTitle!, typeOfQuestion : "Button")
        }
    }
    
    //Clique sur le bouton de la réponse B
    @IBAction func BButton(_ sender: UIButton) {
        if themeQuestionActif[QuestionNumber].Topic == "Psycho"{
            resultatReponseSwitch(stringReponse: "1", typeOfQuestion : "Psycho")
        } else {
            resultatReponseSwitch(stringReponse: Buttons[1].currentTitle!, typeOfQuestion : "Button")
        }
    }
    
    //Clique sur le bouton de la réponse C
    @IBAction func CButton (_ sender: UIButton){
        if themeQuestionActif[QuestionNumber].Topic == "Psycho"{
            resultatReponseSwitch(stringReponse: "2", typeOfQuestion : "Psycho")
        } else {
            resultatReponseSwitch(stringReponse: Buttons[2].currentTitle!, typeOfQuestion : "Button")
        }
    }
    
    //Clique sur le bouton de la réponse D
    @IBAction func DButton(_ sender: UIButton){
        if themeQuestionActif[QuestionNumber].Topic == "Psycho"{
            resultatReponseSwitch(stringReponse: "3", typeOfQuestion : "Psycho")
        } else {
            resultatReponseSwitch(stringReponse: Buttons[3].currentTitle!, typeOfQuestion : "Button")
        }
    }
    
    //Clique sur le bouton de la réponse en TextField
    @IBAction func inputButtonValidate(_ sender: UIButton){
        if InputAnswer.text != ""{
            resultatReponseSwitch(stringReponse: InputAnswer.text!, typeOfQuestion : "Input")
        } else {
            saisieReponseLabel.textColor = .red
        }
    }
    
    @IBAction func hackButton(_ sender: UIButton){
        hackButton.isHidden = true
        messageSpecialLabel = 0
        startTimer.invalidate()
        PickQuestion()
    }
    
    //Gère l'affichage des réponses selon le thème
    func formatAnswers(){
        self.questionView.center.x = self.view.frame.width + (self.questionView.bounds.width/2 + 10)
        UIView.animate(withDuration: 0.25, animations: {
            self.questionView.center.x = self.view.frame.width/2
            
        }, completion : { _ in
            self.QuestionInit()
            switch self.themeQuestionActif[self.QuestionNumber].TypeOfQuestion{
            case "Button":
                var choiceArray : [String] = []
                choiceArray.append(self.themeQuestionActif[self.QuestionNumber].Answer!)
                for i in 0..<self.themeQuestionActif[self.QuestionNumber].Choice.count{
                    choiceArray.append(self.themeQuestionActif[self.QuestionNumber].Choice[i])
                    
                }
                choiceArray.sort()
                for i in 0..<self.Buttons.count{
                    self.Buttons[i].alpha = 1
                    self.Buttons[i].setTitle(choiceArray[i], for :UIControlState.normal)
                    UIView.animate(withDuration: 0.25, delay : (TimeInterval(i)/4), animations: {
                        self.Buttons[i].center.x = self.view.frame.width/2
                    })
                }
                break
            case "Input":
                self.saisieReponseLabel.alpha = 1
                self.InputAnswer.alpha = 1
                self.inputButtonValidate.alpha = 1
                self.InputAnswer.text = ""
                UIView.animate(withDuration: 0.5, animations: {
                    self.saisieReponseLabel.center.x = self.view.frame.width/2
                    self.InputAnswer.center.x = self.view.frame.width/2
                    self.inputButtonValidate.center.x = self.view.frame.width/2
                })
                break
            case "Psycho":
                for i in 0..<self.Buttons.count{
                    self.Buttons[i].alpha = 1
                    self.Buttons[i].setTitle(self.themeQuestionActif[self.QuestionNumber].Choice[i], for :UIControlState.normal)
                    UIView.animate(withDuration: 0.25, delay : (TimeInterval(i)/4), animations: {
                        self.Buttons[i].center.x = self.view.frame.width/2
                    })
                }
                break
            default :
                print("erreur TypeOfQuestion")
                break
            }
        })
    }
    
    //Gère l'écoulement du temps de question
    func GestionTimer(){
        countSeconde -= 1
        headerView.timerLabel?.text = "\(Int(countSeconde))s"
        if countSeconde <= 0 {
            resultatReponseSwitch(stringReponse: "PasLeTime", typeOfQuestion: "PasLeTime")
        }
    }
    
    //Analyse la réponse donnée selon le type de la question
    func resultatReponseSwitch(stringReponse : String, typeOfQuestion : String){
        if messageSpecialLabel == 0 {
            
            hackButton.isHidden = true
            startTimer.invalidate()
            resultatVrai = Int(arc4random_uniform(UInt32(AllAnswersReactions[0].bonneReponse.count)))
            actionResultat = Int(arc4random_uniform(UInt32(AllAnswersReactions[0].gainPVReponse.count)))
            AlreadyPickGesture()
            switch typeOfQuestion {
                //Question type "QCM"
            case "Button":
                QuestionInit()
                if(stringReponse == self.themeQuestionActif[self.QuestionNumber].Answer){
                    self.bruitageMusicPlayer = self.GestionBruitage(filename: "ClikGood", volume : 0.8)
                    self.resultatLabel.text = "\(self.AllAnswersReactions[0].bonneReponse[self.resultatVrai])"
                    self.oneProfil.statsQuiz["bonneReponseQuiz"]! += 1
                } else {
                    self.bruitageMusicPlayer = self.GestionBruitage(filename: "ClikBad", volume : 1)
                    self.VerifNoobFunction()
                }
                
                for i in 0..<self.Buttons.count{
                    self.Buttons[i].alpha = 0
                    self.Buttons[i].setTitle("", for :UIControlState.normal)
                }
                self.bonneReponseLabel.text = "La réponse est : \(self.themeQuestionActif[self.QuestionNumber].Answer!)"
                self.resultatView.alpha = 1
                self.dialogueView.isHidden = false
                if self.themeQuestionActif[self.QuestionNumber].FeedBack != "" {
                    self.dialogueLabel.text = self.themeQuestionActif[self.QuestionNumber].FeedBack
                }else{
                    self.dialogueLabel.text = "Tu as répondu à \(self.QuestionPose) questions sur \(self.nbrQuestionSerie) dans cette série."
                }
                UIView.animate(withDuration: 0.3, animations: {
                    self.resultatLabel.alpha = 1
                }, completion : { _ in
                    UIView.animate(withDuration: 0.4, animations: {
                        self.bonneReponseLabel.alpha = 1
                        
                    }, completion : { _ in
                        UIView.animate(withDuration: 0.5, animations: {
                            self.dialogueView.alpha = 1
                            
                        }, completion : { _ in
                            UIView.animate(withDuration: 0.75, animations: {
                                self.dialogueLabel.alpha = 1
                            })
                        })
                    })
                })
                
                break
                //Question en saisie de réponse
            case "Input":
                
                self.view.endEditing(true)
                
                for i in 0..<self.themeQuestionActif[self.QuestionNumber].Choice.count{
                    if(stringReponse.trimmingCharacters(in: .whitespacesAndNewlines) == self.themeQuestionActif[self.QuestionNumber].Choice[i]){
                        self.resultatLabel.text = "\(self.AllAnswersReactions[0].bonneReponse[self.resultatVrai])"
                        self.reponseTrouverInput = true
                        self.oneProfil.statsQuiz["bonneReponseQuiz"]! += 1
                        self.bruitageMusicPlayer = self.GestionBruitage(filename: "ClikGood", volume : 0.8)
                    } else {
                        self.VerifNoobFunction()
                        self.bruitageMusicPlayer = self.GestionBruitage(filename: "ClikBad", volume : 1)
                    }
                }
                
                
                
                self.InputAnswer.alpha = 0
                self.saisieReponseLabel.alpha = 0
                self.inputButtonValidate.alpha = 0
                self.bonneReponseLabel.text = "La réponse est : \(self.themeQuestionActif[self.QuestionNumber].Answer!)"
                self.resultatView.alpha = 1
                self.dialogueView.isHidden = false
                
                if self.themeQuestionActif[self.QuestionNumber].FeedBack != "" {
                    self.dialogueLabel.text = self.themeQuestionActif[self.QuestionNumber].FeedBack
                }else{
                    self.dialogueLabel.text = "Tu as répondu à \(self.QuestionPose) questions sur \(self.nbrQuestionSerie) dans cette série."
                }
                UIView.animate(withDuration: 0.3, animations: {
                    self.resultatLabel.alpha = 1
                }, completion : { _ in
                    UIView.animate(withDuration: 0.4, animations: {
                        self.bonneReponseLabel.alpha = 1
                        
                    }, completion : { _ in
                        UIView.animate(withDuration: 0.5, animations: {
                            self.dialogueView.alpha = 1
                            
                        }, completion : { _ in
                            UIView.animate(withDuration: 0.75, animations: {
                                self.dialogueLabel.alpha = 1
                            })
                        })
                    })
                })
                
                break
                //Question de psychologie
            case "Psycho":
                let IntReponse : Int = Int(stringReponse)!
                bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
                let profilNameAnswer : String = themeQuestionActif[QuestionNumber].ProfilConsequence![IntReponse]
                
                switch profilNameAnswer {
                case "profil_crieur":
                    self.oneProfil.dictProfil["profil_crieur"]? += 1
                    break
                case "profil_sociable":
                    self.oneProfil.dictProfil["profil_sociable"]? += 1
                    break
                case "profil_timide":
                    self.oneProfil.dictProfil["profil_timide"]? += 1
                    break
                case "profil_innovateur":
                    self.oneProfil.dictProfil["profil_innovateur"]? += 1
                    break
                case "profil_evil":
                    self.oneProfil.dictProfil["profil_evil"]? += 1
                    break
                case "profil_good":
                    self.oneProfil.dictProfil["profil_good"]? += 1
                    break
                default:
                    print("Error json ProfilConsequence")
                    break
                }
                
                let rand = Int(arc4random_uniform(2))
                if rand == 1 {
                    dialogueLabel.text = "Ta réponse est retenu, cela me servira par la suite"
                } else {
                    dialogueLabel.text = "Tu as répondu à \(QuestionPose) questions sur \(nbrQuestionSerie) dans cette série."
                }
                
                if themeQuestionActif[QuestionNumber].HPLostArray[IntReponse] != 0 {
                    
                    resultatLabel.text = "\(AllAnswersReactions[0].mauvaiseReponse[resultatVrai])\(AllAnswersReactions[0].pertePVReponse[actionResultat])\(Int((themeQuestionActif[QuestionNumber].HPLostArray?[IntReponse])!) + (self.oneProfil.dictProfil["profil_evil"])!) PV."
                }
                
                resultatLabel.text = ("Tu as répondu : \(themeQuestionActif[QuestionNumber].Choice[IntReponse])")
                switch themeQuestionActif[QuestionNumber].FeedBackPsycho[IntReponse]{
                case "argentAnswer":
                    let rand = Int(arc4random_uniform(UInt32(AllAnswersReactions[0].argentAnswer.count)))
                    bonneReponseLabel.text = AllAnswersReactions[0].argentAnswer[rand]
                    break
                case "droleAnswer":
                    let rand = Int(arc4random_uniform(UInt32(AllAnswersReactions[0].droleAnswer.count)))
                    bonneReponseLabel.text = AllAnswersReactions[0].droleAnswer[rand]
                    break
                case "sociableAnswer":
                    let rand = Int(arc4random_uniform(UInt32(AllAnswersReactions[0].sociableAnswer.count)))
                    bonneReponseLabel.text = AllAnswersReactions[0].sociableAnswer[rand]
                    break
                case "romantiqueAnswer":
                    let rand = Int(arc4random_uniform(UInt32(AllAnswersReactions[0].romantiqueAnswer.count)))
                    bonneReponseLabel.text = AllAnswersReactions[0].romantiqueAnswer[rand]
                    break
                case "timideAnswer":
                    let rand = Int(arc4random_uniform(UInt32(AllAnswersReactions[0].timideAnswer.count)))
                    bonneReponseLabel.text = AllAnswersReactions[0].timideAnswer[rand]
                    break
                case "soumisAnswer":
                    let rand = Int(arc4random_uniform(UInt32(AllAnswersReactions[0].soumisAnswer.count)))
                    bonneReponseLabel.text = AllAnswersReactions[0].soumisAnswer[rand]
                    break
                case "creatifAnswer":
                    let rand = Int(arc4random_uniform(UInt32(AllAnswersReactions[0].creatifAnswer.count)))
                    bonneReponseLabel.text = AllAnswersReactions[0].creatifAnswer[rand]
                    break
                case "crieurAnswer":
                    let rand = Int(arc4random_uniform(UInt32(AllAnswersReactions[0].crieurAnswer.count)))
                    bonneReponseLabel.text = AllAnswersReactions[0].crieurAnswer[rand]
                    break
                case "evilAnswer":
                    let rand = Int(arc4random_uniform(UInt32(AllAnswersReactions[0].evilAnswer.count)))
                    bonneReponseLabel.text = AllAnswersReactions[0].evilAnswer[rand]
                    changeColorLabelBad(label: headerView.lifePointLabel)
                    self.oneProfil.lifePoint -= (themeQuestionActif[QuestionNumber].HPLostArray?[IntReponse])!
                    break
                default:
                    break
                }
                
                for i in 0..<self.Buttons.count{
                    self.Buttons[i].alpha = 0
                    self.Buttons[i].setTitle("", for :UIControlState.normal)
                }
                self.resultatView.alpha = 1
                self.dialogueView.isHidden = false
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.resultatLabel.alpha = 1
                }, completion : { _ in
                    UIView.animate(withDuration: 0.4, animations: {
                        self.bonneReponseLabel.alpha = 1
                        
                    }, completion : { _ in
                        UIView.animate(withDuration: 0.5, animations: {
                            self.dialogueView.alpha = 1
                            
                        }, completion : { _ in
                            UIView.animate(withDuration: 0.75, animations: {
                                self.dialogueLabel.alpha = 1
                            })
                        })
                    })
                })
                
                break
                
            //Temps écoulé
            case "PasLeTime":
                bruitageMusicPlayer = GestionBruitage(filename: "ClikBad", volume : 1)
                self.view.endEditing(true)
                
                resultatLabel.text = "\(AllAnswersReactions[0].mauvaiseReponse[resultatVrai])\(AllAnswersReactions[0].pertePVReponse[actionResultat])\(Int(themeQuestionActif[QuestionNumber].HPLost!)) PV."
                changeColorLabelBad(label: headerView.lifePointLabel)
                self.oneProfil.lifePoint -= themeQuestionActif[QuestionNumber].HPLost!
                bonneReponseLabel.text = "La réponse est : \(themeQuestionActif[QuestionNumber].Answer!)"
                
                self.InputAnswer.alpha = 0
                self.saisieReponseLabel.alpha = 0
                self.inputButtonValidate.alpha = 0
                for i in 0..<self.Buttons.count{
                    self.Buttons[i].alpha = 0
                    self.Buttons[i].setTitle("", for :UIControlState.normal)
                }
                
                self.resultatView.alpha = 1
                self.dialogueView.isHidden = false
                
                if self.themeQuestionActif[self.QuestionNumber].FeedBack != "" {
                    self.dialogueLabel.text = self.themeQuestionActif[self.QuestionNumber].FeedBack
                }else{
                    self.dialogueLabel.text = "Tu as répondu à \(self.QuestionPose) questions sur \(self.nbrQuestionSerie) dans cette série."
                }
                UIView.animate(withDuration: 0.3, animations: {
                    self.resultatLabel.alpha = 1
                }, completion : { _ in
                    UIView.animate(withDuration: 0.4, animations: {
                        self.bonneReponseLabel.alpha = 1
                        
                    }, completion : { _ in
                        UIView.animate(withDuration: 0.5, animations: {
                            self.dialogueView.alpha = 1
                            
                        }, completion : { _ in
                            UIView.animate(withDuration: 0.75, animations: {
                                self.dialogueLabel.alpha = 1
                            })
                        })
                    })
                })
                
                break
                
            default:
                print("Erreur TypeOfQuestion")
                break
            }
            idQuestion[themeQuestionActif[QuestionNumber].Topic!]? += 1
            
            
            headerView.lifePointLabel?.text = String("\(self.oneProfil.lifePoint) PV")
            messageSpecialLabel = 1
        }
    }
    
    //La même question ne sera jamais posé au joueur
    func AlreadyPickGesture(){
        switch themeQuestionActif[QuestionNumber].Topic {
        case "CultureG":
            TableauCulture[QuestionNumber].AlreadyPick = true
            break
        case "Info":
            TableauInfo[QuestionNumber].AlreadyPick = true
            break
        case "Enigme":
            TableauEnigme[QuestionNumber].AlreadyPick = true
            break
        case "Psycho":
            TableauPsycho[QuestionNumber].AlreadyPick = true
            break
        default:
            fatalError("Problem with AlreadyPick func")
            break
        }
        themeQuestionActif[QuestionNumber].AlreadyPick = true
        QuestionsComplete[themeQuestionActif[QuestionNumber].IdQuestion].AlreadyPick = themeQuestionActif[QuestionNumber].AlreadyPick
        QuestionPose += 1
    }
    
//    @IBAction func InfoPush(_ sender: UIButton) {
//        QuestionPose = 0
//        startTimer.invalidate()
//        themeQuestionActif = TableauInfo
//        dialogueLabel.text = "Questions d'Informatique sélectionnées"
//        themeActif.text = "Culture Informatique"
//        for i in 0..<themeQuestionActif.count{
//            if themeQuestionActif[i].AlreadyPick == true{
//                QuestionPose += 1
//            }
//        }
//        PickQuestion()
//    }
//    
//    @IBAction func CulturePush(_ sender: UIButton) {
//        QuestionPose = 0
//        startTimer.invalidate()
//        
//        themeQuestionActif = TableauCulture
//        dialogueLabel.text = "Questions de Culture Générale sélectionnées"
//        themeActif.text = "Culture Générale"
//        for i in 0..<themeQuestionActif.count{
//            if themeQuestionActif[i].AlreadyPick == true{
//                QuestionPose += 1
//            }
//        }
//        PickQuestion()
//        
//    }
//    @IBAction func EnigmePush(_ sender: UIButton){
//        QuestionPose = 0
//        startTimer.invalidate()
//        
//        themeQuestionActif = TableauEnigme
//        dialogueLabel.text = "Enigmes sélectionnées"
//        themeActif.text = "Enigme"
//        for i in 0..<themeQuestionActif.count{
//            if themeQuestionActif[i].AlreadyPick == true{
//                QuestionPose += 1
//            }
//        }
//        PickQuestion()
//        
//    }
//    @IBAction func PsychoPush(_ sender: UIButton){
//        QuestionPose = 0
//        startTimer.invalidate()
//        
//        themeQuestionActif = TableauPsycho
//        dialogueLabel.text = "Questions de Psychologie sélectionnées"
//        themeActif.text = "Psychologie"
//        for i in 0..<themeQuestionActif.count{
//            if themeQuestionActif[i].AlreadyPick == true{
//                QuestionPose += 1
//            }
//        }
//        PickQuestion()
//    }
    
    // function which is triggered when handleTap is called
    @IBAction func HandleTouchDialogue(_ sender: UITapGestureRecognizer) {
        if messageSpecialLabel == 1 {
            messageSpecialLabel = 0
            PickQuestion()
            
        }
    }
    
    //Gère la musique de fond du quiz
    func QuestionMusicGesture(){
        if self.oneProfil.sceneActuelle >= 1 && self.oneProfil.sceneActuelle <= 5 {
            backgroundMusicPlayer = GestionMusic(filename: "Bog")
        } else {
            backgroundMusicPlayer = GestionMusic(filename: "SodiumVapor")
        }
    }
    
    //Sauvegarde la progression du joueur dans la mémoire interne
    func saveMyData(){
        self.oneProfil.questionAlreadyPick.removeAll()
        for question in QuestionsComplete {
            if question.AlreadyPick == true {
                self.oneProfil.questionAlreadyPick.append(question.IdQuestion)
            }
        }
        var maData = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        maData.appendPathComponent("saveGame")
        NSKeyedArchiver.archiveRootObject(self.oneProfil, toFile: maData.path)
        
    }
    
}
