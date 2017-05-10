
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
    
    //a supprimer apres
    @IBOutlet weak var cultureTheme: UIButton!
    @IBOutlet weak var PsychoTheme: DesignableButton!
    @IBOutlet weak var EnigmeTheme: DesignableButton!
    @IBOutlet weak var InfoTheme: UIButton!
    
    
    var QuestionsComplete = [Question]()
    var AllAnswersReactions = [AnswersReactions]()
    var AllClasseJoueur = [ClasseJoueur]()
    var TableauInfo : [Question] = []
    var TableauCulture : [Question] = []
    var TableauEnigme : [Question] = []
    var TableauPsycho : [Question] = []
    var themeQuestionActif = [Question]()
    var oneProfil = ProfilJoueur(name : "I", lifePoint : 10, dictProfil : ["profil_crieur":0, "profil_sociable" : 0, "profil_timide":0, "profil_innovateur":0, "profil_evil":0, "profil_good":0], classeJoueur : "Geek", sceneActuelle : 1, bonneReponseQuiz : 0, questionAlreadyPick:[] )
    var QuestionNumber : Int = 0
    var QuestionPose : Int = 0
    var messageSpecialLabel : Int = 0
    var countSeconde : Float = 0
    var reponseTrouverInput : Bool = false
    var resultatVrai = Int()
    var actionResultat = Int()
    var startTimer = Timer()
    //variable de classe de joueur
    var chanceDuNoob : Bool = false
    var modeHackeurActive : Bool = false
    var multiplicateurFonctionnaire : Float = 1
    
    var serieQuestionActive : [String:Int] = ["CultureG" : 0, "Info": 0, "Enigme": 0, "Psycho": 0]
    var nbrQuestionSerie : Int = 0
    var endSerie : Bool = false
    var idQuestion : [String:Int] = ["CultureG" : 0, "Info": 0, "Enigme": 0, "Psycho": 0]
    var backgroundMusicPlayer = AVAudioPlayer()
    var bruitageMusicPlayer = AVAudioPlayer()
    
    //Chargement du json, création du tableau des questions, 1ère question
    override func viewDidLoad() {
        super.viewDidLoad()
        // BackgroundView.loadGif(name: "DirecteurEnd")
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
        answerView.isHidden = false
        questionView.isHidden = false
        PickQuestion()
        FonduApparition(myView: self, myDelai: 1)
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
                self.oneProfil.lifePoint = self.oneProfil.lifePoint + (self.oneProfil.bonneReponseQuiz*3)
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
                    self.present(vc, animated: false, completion: nil)
                    
                })
            }else {
                print("Could not instantiate view controller with identifier of type DialogueViewController")
                return
            }
        }
    }
    
    //Rend caché les éléments de l'AnswerView
    func QuestionInit(){
        saisieReponseLabel.isHidden = true
        InputAnswer.isHidden = true
        inputButtonValidate.isHidden = true
        bonneReponseLabel.isHidden = true
        resultatView.isHidden = true
        reponseTrouverInput = false
        for i in 0..<Buttons.count{
            Buttons[i].isHidden = true
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
            
            if themeQuestionActif[QuestionNumber].FeedBack != "" {
                dialogueLabel.text = themeQuestionActif[QuestionNumber].FeedBack
            }else{
                dialogueLabel.text = "Répond à cette question"
            }
            
            messageSpecialLabel = 0
        }else{
            dialogueLabel.text = "Fin de série"
        }
    }
    
    //Interprète la classe du joueur
    func EffetClasse(){
        
        switch self.oneProfil.classeJoueur{
        case "Geek":
           // self.oneProfil.lifePoint += 50
           // lifePointLabel.text = "\(self.oneProfil.lifePoint) PV"
            break
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
    
    func hackFunction(){
        if modeHackeurActive == true {
            let ApparitionRandom = Int(arc4random_uniform(UInt32(3)))
            if ApparitionRandom == 2{
                hackButton.isHidden = false
            }
        }
    }
    
    func VerifNoobFunction(){
        if chanceDuNoob == true {
            let intChanceDuNoob = Int(arc4random_uniform(UInt32(3)))
            if intChanceDuNoob == 2 {
                resultatLabel.text = "\(AllAnswersReactions[0].chanceDuNoob[actionResultat]) \(Int(themeQuestionActif[QuestionNumber].HPLost!)) PV."
                self.oneProfil.lifePoint += themeQuestionActif[QuestionNumber].HPLost!
            } else {
                resultatLabel.text = "\(AllAnswersReactions[0].mauvaiseReponse[resultatVrai])\(AllAnswersReactions[0].pertePVReponse[actionResultat])\(Int(themeQuestionActif[QuestionNumber].HPLost!)) PV."
                self.oneProfil.lifePoint -= themeQuestionActif[QuestionNumber].HPLost!
            }
        }else {
            resultatLabel.text = "\(AllAnswersReactions[0].mauvaiseReponse[resultatVrai])\(AllAnswersReactions[0].pertePVReponse[actionResultat])\(Int(themeQuestionActif[QuestionNumber].HPLost!)) PV."
            self.oneProfil.lifePoint -= themeQuestionActif[QuestionNumber].HPLost!
        }
    }
    
    @IBAction func AButton(_ sender: UIButton) {
        if themeQuestionActif[QuestionNumber].Topic == "Psycho"{
            resultatReponseSwitch(stringReponse: "0", typeOfQuestion : "Psycho")
        } else {
            resultatReponseSwitch(stringReponse: Buttons[0].currentTitle!, typeOfQuestion : "Button")
        }
    }
    
    @IBAction func BButton(_ sender: UIButton) {
        if themeQuestionActif[QuestionNumber].Topic == "Psycho"{
            resultatReponseSwitch(stringReponse: "1", typeOfQuestion : "Psycho")
        } else {
            resultatReponseSwitch(stringReponse: Buttons[1].currentTitle!, typeOfQuestion : "Button")
        }
    }
    
    @IBAction func CButton (_ sender: UIButton){
        if themeQuestionActif[QuestionNumber].Topic == "Psycho"{
            resultatReponseSwitch(stringReponse: "2", typeOfQuestion : "Psycho")
        } else {
            resultatReponseSwitch(stringReponse: Buttons[2].currentTitle!, typeOfQuestion : "Button")
        }
    }
    
    @IBAction func DButton(_ sender: UIButton){
        if themeQuestionActif[QuestionNumber].Topic == "Psycho"{
            resultatReponseSwitch(stringReponse: "3", typeOfQuestion : "Psycho")
        } else {
            resultatReponseSwitch(stringReponse: Buttons[3].currentTitle!, typeOfQuestion : "Button")
        }
    }
    
    @IBAction func inputButtonValidate(_ sender: UIButton){
        if InputAnswer.text != ""{
            resultatReponseSwitch(stringReponse: InputAnswer.text!, typeOfQuestion : "Input")
        } else {
            dialogueLabel.text = "Vous devez saisir une réponse"
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
        switch self.themeQuestionActif[self.QuestionNumber].TypeOfQuestion{
        case "Button":
            var choiceArray : [String] = []
            choiceArray.append(self.themeQuestionActif[self.QuestionNumber].Answer!)
            for i in 0..<self.themeQuestionActif[self.QuestionNumber].Choice.count{
                choiceArray.append(self.themeQuestionActif[self.QuestionNumber].Choice[i])
                
            }
            choiceArray.sort()
            for i in 0..<self.Buttons.count{
                self.Buttons[i].isHidden = false
                self.Buttons[i].setTitle(choiceArray[i], for :UIControlState.normal)
                UIView.animate(withDuration: 0.25, delay : (TimeInterval(i)/4), animations: {
                    self.Buttons[i].center.x = self.view.frame.width/2
                })
            }
            break
        case "Input":
            self.saisieReponseLabel.isHidden = false
            self.InputAnswer.isHidden = false
            self.inputButtonValidate.isHidden = false
            self.InputAnswer.text = ""
            UIView.animate(withDuration: 0.5, animations: {
                self.saisieReponseLabel.center.x = self.view.frame.width/2
                self.InputAnswer.center.x = self.view.frame.width/2
                self.inputButtonValidate.center.x = self.view.frame.width/2
            })
            break
        case "Psycho":
            for i in 0..<self.Buttons.count{
                self.Buttons[i].isHidden = false
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
            startTimer.invalidate()
            resultatVrai = Int(arc4random_uniform(UInt32(AllAnswersReactions[0].bonneReponse.count)))
            actionResultat = Int(arc4random_uniform(UInt32(AllAnswersReactions[0].gainPVReponse.count)))
            AlreadyPickGesture()
            switch typeOfQuestion {
            case "Button":
                for i in 0..<Buttons.count{
                    Buttons[i].setTitle("", for :UIControlState.normal)
                    Buttons[i].isHidden = true
                }
                if(stringReponse == themeQuestionActif[QuestionNumber].Answer){
                    bruitageMusicPlayer = GestionBruitage(filename: "ClikGood", volume : 0.8)
                    resultatLabel.text = "\(AllAnswersReactions[0].bonneReponse[resultatVrai])"
                    self.oneProfil.bonneReponseQuiz += 1
                } else {
                    bruitageMusicPlayer = GestionBruitage(filename: "ClikBad", volume : 1)
                    VerifNoobFunction()
                }
                bonneReponseLabel.text = "La réponse est : \(themeQuestionActif[QuestionNumber].Answer!)"
                dialogueLabel.text = "Tu as répondu à \(QuestionPose) questions sur \(nbrQuestionSerie) dans cette série."
                
                break
            case "Input":
                InputAnswer.isHidden = true
                saisieReponseLabel.isHidden = true
                inputButtonValidate.isHidden = true
                for i in 0..<themeQuestionActif[QuestionNumber].Choice.count{
                    if(stringReponse == themeQuestionActif[QuestionNumber].Choice[i]){
                        resultatLabel.text = "\(AllAnswersReactions[0].bonneReponse[resultatVrai])"
                        reponseTrouverInput = true
                        self.oneProfil.bonneReponseQuiz += 1
                        bruitageMusicPlayer = GestionBruitage(filename: "ClikGood", volume : 0.8)

                    }
                }
                if reponseTrouverInput == false {
                    VerifNoobFunction()
                    bruitageMusicPlayer = GestionBruitage(filename: "ClikBad", volume : 1)
                }
                
                bonneReponseLabel.text = "La réponse est : \(themeQuestionActif[QuestionNumber].Answer!)"
                dialogueLabel.text = "Tu as répondu à \(QuestionPose) questions sur \(nbrQuestionSerie) dans cette série."
                
                break
            case "Psycho":
                let IntReponse : Int = Int(stringReponse)!
                let profilNameAnswer : String = themeQuestionActif[QuestionNumber].ProfilConsequence![IntReponse]
                for i in 0..<Buttons.count{
                    Buttons[i].setTitle("", for :UIControlState.normal)
                    Buttons[i].isHidden = true
                }
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
                resultatLabel.text = "Ta réponse est retenu, cela me servira par la suite"
                if themeQuestionActif[QuestionNumber].HPLostArray[IntReponse] != 0 {
                    self.oneProfil.lifePoint -= (themeQuestionActif[QuestionNumber].HPLostArray?[IntReponse])! + (self.oneProfil.dictProfil["profil_evil"])!
                    resultatLabel.text = "\(AllAnswersReactions[0].mauvaiseReponse[resultatVrai])\(AllAnswersReactions[0].pertePVReponse[actionResultat])\(Int((themeQuestionActif[QuestionNumber].HPLostArray?[IntReponse])!) + (self.oneProfil.dictProfil["profil_evil"])!) PV."
                    dialogueLabel.text = "Tu as un profil assez diabolique, je ne suis pas sur que tu finira le jeu avec des réponses comme cela"
                } else {
                   dialogueLabel.text = "Tu as répondu à \(QuestionPose) questions sur \(nbrQuestionSerie) dans cette série." 
                }
                
                bonneReponseLabel.text = ("Tu as répondu : \(themeQuestionActif[QuestionNumber].Choice[IntReponse])")
                break
                
            case "PasLeTime":
                for i in 0..<Buttons.count{
                    Buttons[i].setTitle("", for :UIControlState.normal)
                    Buttons[i].isHidden = true
                }
                bruitageMusicPlayer = GestionBruitage(filename: "ClikBad", volume : 1)
                InputAnswer.isHidden = true
                saisieReponseLabel.isHidden = true
                inputButtonValidate.isHidden = true
                resultatLabel.text = "\(AllAnswersReactions[0].mauvaiseReponse[resultatVrai])\(AllAnswersReactions[0].pertePVReponse[actionResultat])\(Int(themeQuestionActif[QuestionNumber].HPLost!)) PV."
                self.oneProfil.lifePoint -= themeQuestionActif[QuestionNumber].HPLost!
                bonneReponseLabel.text = "La réponse est : \(themeQuestionActif[QuestionNumber].Answer!)"
                break
                
            default:
                print("Erreur TypeOfQuestion")
                break
            }
            idQuestion[themeQuestionActif[QuestionNumber].Topic!]? += 1
            resultatView.isHidden = false
            bonneReponseLabel.isHidden = false
            headerView.lifePointLabel?.text = String("\(self.oneProfil.lifePoint) PV")
            messageSpecialLabel = 1
        }
    }
    
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
    
    @IBAction func InfoPush(_ sender: UIButton) {
        QuestionPose = 0
        startTimer.invalidate()
        themeQuestionActif = TableauInfo
        dialogueLabel.text = "Questions d'Informatique sélectionnées"
        themeActif.text = "Culture Informatique"
        for i in 0..<themeQuestionActif.count{
            if themeQuestionActif[i].AlreadyPick == true{
                QuestionPose += 1
            }
        }
        PickQuestion()
    }
    
    @IBAction func CulturePush(_ sender: UIButton) {
        QuestionPose = 0
        startTimer.invalidate()
        
        themeQuestionActif = TableauCulture
        dialogueLabel.text = "Questions de Culture Générale sélectionnées"
        themeActif.text = "Culture Générale"
        for i in 0..<themeQuestionActif.count{
            if themeQuestionActif[i].AlreadyPick == true{
                QuestionPose += 1
            }
        }
        PickQuestion()
        
    }
    @IBAction func EnigmePush(_ sender: UIButton){
        QuestionPose = 0
        startTimer.invalidate()
        
        themeQuestionActif = TableauEnigme
        dialogueLabel.text = "Enigmes sélectionnées"
        themeActif.text = "Enigme"
        for i in 0..<themeQuestionActif.count{
            if themeQuestionActif[i].AlreadyPick == true{
                QuestionPose += 1
            }
        }
        PickQuestion()
        
    }
    @IBAction func PsychoPush(_ sender: UIButton){
        QuestionPose = 0
        startTimer.invalidate()
        
        themeQuestionActif = TableauPsycho
        dialogueLabel.text = "Questions de Psychologie sélectionnées"
        themeActif.text = "Psychologie"
        for i in 0..<themeQuestionActif.count{
            if themeQuestionActif[i].AlreadyPick == true{
                QuestionPose += 1
            }
        }
        PickQuestion()
    }
    
    // function which is triggered when handleTap is called
    @IBAction func HandleTouchDialogue(_ sender: UITapGestureRecognizer) {
        if messageSpecialLabel == 1 {
            messageSpecialLabel = 0
            PickQuestion()
        }
    }
    
    
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
    
    func QuestionMusicGesture(){
        if self.oneProfil.sceneActuelle >= 1 && self.oneProfil.sceneActuelle <= 5 {
            backgroundMusicPlayer = GestionMusic(filename: "Bog")
        } else {
            backgroundMusicPlayer = GestionMusic(filename: "SodiumVapor")
        }
    }
}
