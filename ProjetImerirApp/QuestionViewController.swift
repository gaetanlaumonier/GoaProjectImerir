
import UIKit

class QuestionViewController: UIViewController {
    
    @IBOutlet weak var BackgroundVIew: UIImageView!
    @IBOutlet var Buttons : [UIButton]!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var lifePointLabel: UILabel!
    @IBOutlet weak var dialogueLabel: UILabel!
    @IBOutlet weak var resultatLabel: UILabel!
    @IBOutlet weak var bonneReponseLabel: UILabel!
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var dialogueView: UIView!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var InputAnswer: UITextField!
    @IBOutlet weak var resultatView: UIView!
    @IBOutlet weak var inputButtonValidate: UIButton!
    @IBOutlet weak var hackButton: UIButton!
    
    
    var QuestionsComplete = [Question]()
    var AllAnswersReactions = [AnswersReactions]()
    var AllClasseJoueur = [ClasseJoueur]()
    var TableauInfo : [Question] = []
    var TableauCulture : [Question] = []
    var TableauEnigme : [Question] = []
    var TableauPsycho : [Question] = []
    var themeQuestionActif = [Question]()
    var oneProfil = ProfilJoueur(name : "I", lifePoint : 0, dictProfil : ["profil_crieur":0, "profil_sociable" : 0, "profil_timide":0, "profil_innovateur":0, "profil_evil":0, "profil_good":0], classeJoueur : "Geek")
    var QuestionNumber = Int()
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
    
    //Chargement du json, création du tableau des questions, 1ère question
    override func viewDidLoad() {
        super.viewDidLoad()
        // BackgroundVIew.loadGif(name: "DirecteurEnd")
        
        QuestionsComplete = buildQuestions()
        AllAnswersReactions = buildAnswersReactions()
        AllClasseJoueur = buildClasseJoueur()
        EffetClasse()
        lifePointLabel.text = "\(self.oneProfil.lifePoint) PV"
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
        themeQuestionActif = TableauInfo
        PickQuestion()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //Rend caché les éléments de l'AnswerView
    func QuestionInit(){
        for i in 0..<Buttons.count{
            Buttons[i].isHidden = true
        }
        InputAnswer.isHidden = true
        inputButtonValidate.isHidden = true
        bonneReponseLabel.isHidden = true
        resultatView.isHidden = true
        reponseTrouverInput = false
        
        
    }
    
    //Pose une question qui n'a pas été posée, lance le timer...
    func PickQuestion(){
        QuestionInit()
        if themeQuestionActif.count > 0 && QuestionPose < themeQuestionActif.count {
            QuestionNumber = Int(arc4random_uniform(UInt32(themeQuestionActif.count)))
            while themeQuestionActif[QuestionNumber].AlreadyPick == true {
                QuestionNumber = Int(arc4random_uniform(UInt32(themeQuestionActif.count)))
            }
            questionLabel.text = themeQuestionActif[QuestionNumber].Question
            formatAnswers()
            
            if themeQuestionActif[QuestionNumber].Timer != 0 {
                TimerLabel.isHidden = false
                countSeconde = Float(themeQuestionActif[QuestionNumber].Timer) * multiplicateurFonctionnaire
                hackFunction()
                TimerLabel.text = "\(Int(countSeconde))s"
                startTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(QuestionViewController.GestionTimer), userInfo: nil, repeats: true)
                
            } else {
                TimerLabel.isHidden = true
                startTimer.invalidate()
            }
            
            if themeQuestionActif[QuestionNumber].FeedBack != "" {
                dialogueLabel.text = themeQuestionActif[QuestionNumber].FeedBack
            }else{
                dialogueLabel.text = "Répond à cette question"
            }
            
            messageSpecialLabel = 0
            themeQuestionActif[QuestionNumber].AlreadyPick = true
        }else{
            dialogueLabel.text = "Plus de question"
        }
        EndGame()
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
        switch themeQuestionActif[QuestionNumber].TypeOfQuestion{
        case "Button":
            var choiceArray : [String] = []
            choiceArray.append(themeQuestionActif[QuestionNumber].Answer!)
            for i in 0..<themeQuestionActif[QuestionNumber].Choice.count{
                choiceArray.append(themeQuestionActif[QuestionNumber].Choice[i])
            }
            choiceArray.sort()
            
            for i in 0..<Buttons.count{
                Buttons[i].isHidden = false
                
                Buttons[i].setTitle(choiceArray[i], for :UIControlState.normal)
            }
            break
        case "Input":
            InputAnswer.isHidden = false
            inputButtonValidate.isHidden = false
            InputAnswer.text = ""
            break
        case "Psycho":
            for i in 0..<Buttons.count{
                Buttons[i].isHidden = false
                Buttons[i].setTitle(themeQuestionActif[QuestionNumber].Choice[i], for :UIControlState.normal)
            }
            break
        default :
            print("erreur TypeOfQuestion")
            break
        }
    }
    
    //Gère l'écoulement du temps de question
    func GestionTimer(){
        countSeconde -= 1
        TimerLabel.text = "\(Int(countSeconde))s"
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
            themeQuestionActif[QuestionNumber].AlreadyPick = true
            switch typeOfQuestion {
            case "Button":
                for i in 0..<Buttons.count{
                    Buttons[i].setTitle("", for :UIControlState.normal)
                    Buttons[i].isHidden = true
                }
                if(stringReponse == themeQuestionActif[QuestionNumber].Answer){
                    resultatLabel.text = "\(AllAnswersReactions[0].bonneReponse[resultatVrai])"
                } else {
                    VerifNoobFunction()
                }
                bonneReponseLabel.text = "La réponse est : \(themeQuestionActif[QuestionNumber].Answer!)"
                dialogueLabel.text = "Tu as répondu à \(QuestionPose) questions"
                
                break
            case "Input":
                InputAnswer.isHidden = true
                inputButtonValidate.isHidden = true
                for i in 0..<themeQuestionActif[QuestionNumber].Choice.count{
                    if(stringReponse == themeQuestionActif[QuestionNumber].Choice[i]){
                        resultatLabel.text = "\(AllAnswersReactions[0].bonneReponse[resultatVrai])"
                        reponseTrouverInput = true
                    }
                }
                if reponseTrouverInput == false {
                    VerifNoobFunction()
                }
                bonneReponseLabel.text = "La réponse est : \(themeQuestionActif[QuestionNumber].Answer!)"
                dialogueLabel.text = "Tu as répondu à \(QuestionPose) questions"
                
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
                }
                
                bonneReponseLabel.text = ("Tu as répondu : \(themeQuestionActif[QuestionNumber].Choice[IntReponse])")
                if QuestionPose > 12 {
                    
                    print(self.oneProfil.dictProfil)
                    
                }
                break
                
            case "PasLeTime":
                for i in 0..<Buttons.count{
                    Buttons[i].setTitle("", for :UIControlState.normal)
                    Buttons[i].isHidden = true
                }
                InputAnswer.isHidden = true
                inputButtonValidate.isHidden = true
                resultatLabel.text = "\(AllAnswersReactions[0].mauvaiseReponse[resultatVrai])\(AllAnswersReactions[0].pertePVReponse[actionResultat])\(Int(themeQuestionActif[QuestionNumber].HPLost!)) PV."
                self.oneProfil.lifePoint -= themeQuestionActif[QuestionNumber].HPLost!
                bonneReponseLabel.text = "La réponse est : \(themeQuestionActif[QuestionNumber].Answer!)"
                break
                
            default:
                print("Erreur TypeOfQuestion")
                break
            }
            QuestionPose += 1
            resultatView.isHidden = false
            bonneReponseLabel.isHidden = false
            lifePointLabel.text = String("\(self.oneProfil.lifePoint) PV")
            messageSpecialLabel = 1
        }
    }
    
    func EndGame(){
        if self.oneProfil.lifePoint < 1 {
            messageSpecialLabel = 3
        }
    }
    
    @IBAction func InfoPush(_ sender: UIButton) {
        QuestionPose = 0
        startTimer.invalidate()
        themeQuestionActif = TableauInfo
        dialogueLabel.text = "Questions d'informatique sélectionnées"
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
        if messageSpecialLabel == 3 {
            resultatLabel.text = "GAME OVER"
            dialogueLabel.text = "GAME OVER"
            lifePointLabel.text = "GAME OVER"
            questionLabel.text = "GAME OVER"
            bonneReponseLabel.text = "GAME OVER"
            for i in 0..<Buttons.count{
                Buttons[i].setTitle("GAME OVER", for: .normal)
            }
        }
    }
    
}
