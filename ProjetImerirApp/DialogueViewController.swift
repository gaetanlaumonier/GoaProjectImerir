
import AVFoundation
import UIKit

class DialogueViewController: UIViewController {
    
    @IBOutlet weak var dialogueLabel: UILabel!
    @IBOutlet weak var dialogueView: UIView!
    @IBOutlet weak var imageBackground: UIImageView!
    
    @IBOutlet weak var arrowView: UIView!
    var AllDialogue = [Dialogue]()
    var DialogueNumber : Int = 0
    var ExDialogueNumber : Int = 0
    var nameTap : Bool = false
    var firstDialogue = true
    var oneProfil = ProfilJoueur()
    var serieQuestion : [String:Int] = [:]
    var PsychoAnswer = [PsychoDialogue]()
    var playerProfil : String = ""
    var goodOrEvil : String = ""
    var EndGameGesture : Bool = false
    var bruitageMusicPlayer = AVAudioPlayer()
    var tapEnable : Bool = false
    var personnages = [UIImageView]()
    
    var embedViewController:EmbedViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.alpha = 0
        AllDialogue = buildDialogue()
        dialogueLabel.text = AllDialogue[self.oneProfil.sceneActuelle].libelleDialogue[DialogueNumber]
        GestionDialogue()
        GestionBackground()
        embedViewController = getEmbedViewController()
        embedViewController.backgroundMusicPlayer = GestionMusic(filename: AllDialogue[self.oneProfil.sceneActuelle].musiqueDialogue)
        if AllDialogue[self.oneProfil.sceneActuelle].musiqueDialogue == "Bedtime" {
            embedViewController.backgroundMusicPlayer.volume = 0.6
        } else if AllDialogue[self.oneProfil.sceneActuelle].musiqueDialogue == "SomeDreamy" {
            embedViewController.backgroundMusicPlayer.volume = 0.8
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        FonduApparition(myView: self, myDelai: 1)
        GestionArrow()
        tapEnable = true
    }
    
    //Gère la flèche de dialogue en bas a droite de l'écran
    func GestionArrow() {
        
        let layer = CAShapeLayer()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x:0,y:0))
        path.addQuadCurve(to: CGPoint(x: arrowView.bounds.width, y: arrowView.bounds.midY), controlPoint: CGPoint(x: arrowView.bounds.midX*1.5, y: arrowView.bounds.midY/2))
        path.addQuadCurve(to: CGPoint(x: 0, y: arrowView.bounds.height), controlPoint: CGPoint(x: arrowView.bounds.midX*1.5, y: arrowView.bounds.midY*1.5))
        path.addQuadCurve(to: CGPoint(x: 0, y: 0), controlPoint: CGPoint(x: arrowView.bounds.midX/2, y: arrowView.bounds.midY))
        
        layer.fillColor = UIColor.white.cgColor
        layer.path = path.cgPath
        layer.shadowPath = path.cgPath
        layer.shadowColor = UIColor(red: 1, green: 192/255, blue: 24/255, alpha: 1).cgColor
        layer.shadowOpacity = 1
        
        layer.shadowOffset = CGSize()
        layer.shadowRadius = 3
        arrowView.alpha = 0.9
        arrowView.layer.addSublayer(layer)
    }
    
    //Fontion intégrant le name du joueur dans les dialogues
    func NomExcla(){
        
        dialogueLabel.text = "\(AllDialogue[self.oneProfil.sceneActuelle].libelleDialogue[DialogueNumber])\(self.oneProfil.name) !"
        
        guard AllDialogue[self.oneProfil.sceneActuelle].styleLabel.isEmpty  else {
            guard DialogueNumber >= AllDialogue[self.oneProfil.sceneActuelle].styleLabel.count else {
                if AllDialogue[self.oneProfil.sceneActuelle].styleLabel[DialogueNumber] == "it" {
                    dialogueLabel.text? += " \""
                }
                return
            }
            return
        }
    }
    
    func NomInt(){
        dialogueLabel.text = "\(AllDialogue[self.oneProfil.sceneActuelle].libelleDialogue[DialogueNumber])\(self.oneProfil.name) ?"
        
    }
    
    // MARK: navigation gesture

    func ChoixClasse(){
        if let vc = UIStoryboard(name:"ChoiseClasse", bundle:nil).instantiateViewController(withIdentifier: "choixClasse") as? ChoiceClasseViewController
        {
            arrowView.isHidden = true
            UIView.animate(withDuration: 1, delay: 0, options: .transitionCrossDissolve, animations: {
                self.view.alpha = 0
            } , completion: { success in
                vc.oneProfil = self.oneProfil
                self.embedViewController.showScene(vc)
            })
        }else {
            print("Could not instantiate view controller with identifier of type ChoiceClasseTableViewController")
            return
        }
        
        
    }
    
    func ApparitionSilhouette(){
        embedViewController.backgroundMusicPlayer = GestionMusic(filename: "DownDraft")
        embedViewController.backgroundMusicPlayer.numberOfLoops = 0
        ApparitionPersonnage(namePersonnage: "Silhouette", fadeInDelay: 6, myTag: 0, taille : 0.75)
        dialogueLabel.text = AllDialogue[self.oneProfil.sceneActuelle].libelleDialogue[DialogueNumber]
        
    }
    
    //Permet de faire appaître un personnage au centre de l'écran en fondu
    func ApparitionPersonnage(namePersonnage : String, fadeInDelay : TimeInterval, myTag : Int, taille : CGFloat){
        
        tapEnable = false
        dialogueView.layer.zPosition = 100
        let personnage = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        personnages.append(personnage)
        personnages[myTag].loadGif(name: namePersonnage)
        personnages[myTag].alpha = 0
        arrowView.isHidden = true
        view.addSubview(personnages[myTag])
        personnages[myTag].translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints([
            NSLayoutConstraint(item: personnages[myTag], attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: personnages[myTag], attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: taille, constant: 0)
            
            ])
        view.addConstraints([
            NSLayoutConstraint(item: personnages[myTag], attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: taille, constant: 0),
            NSLayoutConstraint(item: personnages[myTag], attribute: .bottomMargin, relatedBy: .equal, toItem: dialogueView, attribute: .top, multiplier: 1.05, constant: 0)
            ])
        UIView.animate(withDuration: fadeInDelay, animations: {
            self.personnages[myTag].alpha = 1
        }, completion : { _ in
            self.tapEnable = true
            self.arrowView.isHidden = false
        })
    }
    
    func ResultatFirstTest(){
        dialogueLabel.text = "\(AllDialogue[self.oneProfil.sceneActuelle].libelleDialogue[DialogueNumber])\(self.oneProfil.statsQuiz["bonneReponseQuiz"]!) questions."
    }
    
    //Gère les séries de question du quiz
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
    
    //Lance la série de question
    func GestionSerieQuestion(CultureG :Int, Info: Int, Enigme: Int, Psycho: Int){
        serieQuestion = ["CultureG" : CultureG, "Info": Info, "Enigme": Enigme, "Psycho": Psycho] as [String:Int]
        if serieQuestion["Enigme"] != 1 {
            if let vc = UIStoryboard(name:"Quiz", bundle:nil).instantiateViewController(withIdentifier: "Question") as? QuestionViewController
            {
                vc.serieQuestionActive = self.serieQuestion
                arrowView.isHidden = true
                UIView.animate(withDuration: 2, delay: 0, options: .transitionCrossDissolve, animations: {
                    self.view.alpha = 0
                    self.embedViewController.backgroundMusicPlayer.setVolume(0, fadeDuration: 2)
                } , completion: { success in
                    vc.oneProfil = self.oneProfil
                    self.embedViewController.showScene(vc)
                })
            }else {
                print("Could not instantiate view controller with identifier of type QuestionViewController")
                return
            }
        }
    }
    
    //lance l'arcadeCookie
    func ArcadeCookieStart(){
        if let vc = UIStoryboard(name:"ArcadeCookie", bundle:nil).instantiateInitialViewController() as? CookieViewController
        {
            arrowView.isHidden = true
            UIView.animate(withDuration: 2, delay: 0, options: .transitionCrossDissolve, animations: {
                self.view.alpha = 0
                self.embedViewController.backgroundMusicPlayer.setVolume(0, fadeDuration: 2)
            } , completion: { success in
                vc.oneProfil = self.oneProfil
                self.embedViewController.showScene(vc)
            })
        }else {
            print("Could not instantiate view controller with identifier of type ArcadeViewController")
            return
        }
    }
    
    //lance l'arcadeRangemenr
    func ArcadeRangementStart(){
        if let vc = UIStoryboard(name:"ArcadeRangement", bundle:nil).instantiateInitialViewController() as? RangementViewController
        {
            arrowView.isHidden = true
            UIView.animate(withDuration: 2, delay: 0, options: .transitionCrossDissolve, animations: {
                self.view.alpha = 0
                self.embedViewController.backgroundMusicPlayer.setVolume(0, fadeDuration: 2)
            } , completion: { _ in
                vc.oneProfil = self.oneProfil
                self.embedViewController.showScene(vc)
            
            })
        }else {
            print("Could not instantiate view controller with identifier of type RangementViewController")
            return
        }
        
        
    }
    
    func TpChambreAdo(){
        arrowView.isHidden = true
        UIView.animate(withDuration: 2, delay : 1, animations: {
            self.view.alpha = 0
            self.embedViewController.backgroundMusicPlayer.setVolume(0, fadeDuration: 2.5)
        } , completion: { success in
            self.imageBackground.loadGif(name: "ChambreAdo")
            self.embedViewController.backgroundMusicPlayer = self.GestionMusic(filename: "SomeDreamy")
            self.oneProfil.sceneActuelle += 1
            self.firstDialogue = true
            self.DialogueNumber = 0
            self.GestionDialogue()
            UIView.animate(withDuration: 3, animations: {
                self.view.alpha = 1
            }, completion : { _ in
                self.arrowView.isHidden = false
            })
        })
    }
    
    func LabyrintheFirst(){
        
        arrowView.isHidden = true
        UIView.animate(withDuration: 3, animations: {
            self.view.alpha = 0
            self.embedViewController.backgroundMusicPlayer.setVolume(0, fadeDuration: 2.5)
        } , completion: { success in
            self.imageBackground.loadGif(name: "Lab4voies")
            self.personnages[0].removeFromSuperview()
            self.embedViewController.backgroundMusicPlayer = self.GestionMusic(filename: "TheDarkness")
            self.imageBackground.alpha = 0
            self.dialogueView.alpha = 0
            self.view.alpha = 1
            self.oneProfil.sceneActuelle += 1
            self.firstDialogue = true
            self.DialogueNumber = 0
            self.GestionDialogue()
            UIView.animate(withDuration: 2, delay : 1, animations: {
                self.imageBackground.alpha = 0.6
                self.dialogueView.alpha = 1
            }, completion : { _ in
                self.arrowView.isHidden = false
                
            })
        })
    }
    
    //lance le labyrinthe
    func StartLabyrinthe(){
        if let vc = UIStoryboard(name:"ArcadeLabyrinthe", bundle:nil).instantiateInitialViewController() as? LabyrintheViewController
        {
            arrowView.isHidden = true
            UIView.animate(withDuration: 1, animations: {
                self.view.alpha = 0
            } , completion: { success in
                vc.oneProfil = self.oneProfil
                vc.isFirstMaze = true
              //  vc.embedViewController.backgroundMusicPlayer = self.embedViewController.backgroundMusicPlayer
                self.embedViewController.showScene(vc)
            })
        }else {
            print("Could not instantiate view controller with identifier of type LabyrintheViewController")
            return
        }
    }
    
    //Lance le labyrinthe
    func LabyrintheRevange(){
        if let vc = UIStoryboard(name:"ArcadeLabyrinthe", bundle:nil).instantiateInitialViewController() as? LabyrintheViewController
        {
            arrowView.isHidden = true
            UIView.animate(withDuration: 4, animations: {
                self.view.alpha = 0
                self.embedViewController.backgroundMusicPlayer.setVolume(0, fadeDuration: 3.5)
            } , completion: { success in
                vc.oneProfil = self.oneProfil
                vc.isFirstMaze = false
                self.embedViewController.showScene(vc)
            })
        }else {
            print("Could not instantiate view controller with identifier of type LabyrintheViewController")
            return
        }
    }
    
    //Lance l'arcadeConsole
    func ArcadeConsoleStart(){
        
        if let vc = UIStoryboard(name:"ArcadeConsole", bundle:nil).instantiateInitialViewController() as? ConsoleViewController
        {
            arrowView.isHidden = true
            UIView.animate(withDuration: 2, animations: {
                self.view.alpha = 0
                self.embedViewController.backgroundMusicPlayer.setVolume(0, fadeDuration: 1.5)
            } , completion: { _ in
                vc.oneProfil = self.oneProfil
                self.embedViewController.showScene(vc)
                //self.present(vc, animated: false, completion: nil)
            })
        }else {
            print("Could not instantiate view controller with identifier of type ConsoleViewController")
            return
        }
        
        
    }
    
    //Lance l'arcadeBac
    func ArcadeBacStart(){
        
        if let vc = UIStoryboard(name:"ArcadeBac", bundle:nil).instantiateInitialViewController() as? BacViewController
        {
            arrowView.isHidden = true
            UIView.animate(withDuration: 2, animations: {
                self.view.alpha = 0
                self.embedViewController.backgroundMusicPlayer.setVolume(0, fadeDuration: 1.5)
            } , completion: { _ in
                vc.oneProfil = self.oneProfil
                self.embedViewController.showScene(vc)
                //self.present(vc, animated: false, completion: nil)
            })
        }else {
            print("Could not instantiate view controller with identifier of type ConsoleViewController")
            return
        }
        
    }
    
    func GestionEnd(){
        if self.oneProfil.lifePoint >= 70 {
            self.oneProfil.sceneActuelle += 2
        } else if self.oneProfil.lifePoint >= 40 {
            self.oneProfil.sceneActuelle += 1
        }
        EndGameGesture = false
    }
    
    //Fait apparaître le personnage au milieu de l'écran en fondu
    func ApparitionDirecteur(){
        dialogueLabel.text = "\(AllDialogue[self.oneProfil.sceneActuelle].libelleDialogue[DialogueNumber])"
        UIView.animate(withDuration: 10, animations: {
            self.personnages[0].alpha = 0
            self.ApparitionPersonnage(namePersonnage: "Directeur", fadeInDelay: 10, myTag: 1, taille: 0.5)
        }, completion : { _ in
            self.personnages[0].removeFromSuperview()
        })
    }
    
    //Fait apparaître le personnage au milieu de l'écran en fondu
    func ApparitionMartien(){
        dialogueLabel.text = "\(AllDialogue[self.oneProfil.sceneActuelle].libelleDialogue[DialogueNumber])"
        UIView.animate(withDuration: 10, animations: {
            self.personnages[0].alpha = 0
            self.ApparitionPersonnage(namePersonnage: "Martien1", fadeInDelay: 10, myTag: 1, taille: 0.75)
        }, completion : { _ in
            self.personnages[0].removeFromSuperview()
        })
    }
    
    func CorrectAnswer(){
        dialogueLabel.text = "\(AllDialogue[self.oneProfil.sceneActuelle].libelleDialogue[DialogueNumber])\(self.oneProfil.statsQuiz["bonneReponseQuiz"]!.hashValue) questions de quiz sur 40."
    }
    
    func DialoguesFinaux(){
        self.oneProfil.sceneActuelle += 3
        UIView.animate(withDuration: 0.25, animations: {
            self.arrowView.alpha = 0
        })
        UIView.animate(withDuration: 5, animations: {
            self.view.alpha = 0
            self.embedViewController.backgroundMusicPlayer.setVolume(0, fadeDuration: 4)
        }, completion: { sucess in
            self.GestionBackground()
            for obj in self.personnages {
                obj.removeFromSuperview()
            }
            self.firstDialogue = true
            self.DialogueNumber = 0
            self.GestionDialogue()
            self.FonduApparition(myView: self, myDelai: 1)
        })
    }
    
    func RetourMenu(){
        if let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "InitController") as? InitViewController
        {
            UIView.animate(withDuration: 2, delay: 0, options: .transitionCrossDissolve, animations: {
                self.view.alpha = 0
            } , completion: { success in
                vc.firstMenuForRun = false
                self.embedViewController.showScene(vc)
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
        
    }
    
    // MARK: dialogue gesture
    
    //Gère l'enchainement des dialogues au clic
    func GestionEnchainementDialogue(){
        if EndGameGesture == false {
            if self.oneProfil.sceneActuelle == 13 && firstDialogue == true {
                EndGameGesture = true
                GestionEnd()
            }
            if firstDialogue == false {
                
                if self.oneProfil.sceneActuelle != 2 && DialogueNumber != 11 || self.oneProfil.sceneActuelle == 2 && DialogueNumber != 11 {
                    if self.oneProfil.sceneActuelle != 7 && DialogueNumber != 5 || self.oneProfil.sceneActuelle == 7 && DialogueNumber != 5 {
                        
                        self.bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume: 0.5)
                    }
                }
                DialogueNumber += 1
                if DialogueNumber == AllDialogue[self.oneProfil.sceneActuelle].libelleDialogue.count {
//                    if(self.oneProfil.sceneActuelle != 1 || self.oneProfil.sceneActuelle == 5 || self.oneProfil.sceneActuelle == 9 || self.oneProfil.sceneActuelle == 11 || self.oneProfil.sceneActuelle == 0){
//                    if self.oneProfil.sceneActuelle == 5 {
//                        self.oneProfil.sceneActuelle += 1
////                    }
//                    }
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
    
    //Gère le style du dialogue, italique ou non
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
                dialogueLabel.textColor = UIColor(red: 1, green: 232/255, blue: 24/255, alpha: 0.9)
                
            } else {
                dialogueLabel.font = UIFont(name: "Futura", size: self.dialogueLabel.font.pointSize)
                dialogueLabel.textColor = .white
                
            }
            
        }
    }
    
    //Gère les évenements présents dans le dialogue
    func GestionEventDialogue(){
        
        if AllDialogue[self.oneProfil.sceneActuelle].eventDialogue[DialogueNumber] != "nil" {
           
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
            case "Apparition":
                ApparitionSilhouette()
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
            case "TpChambreAdo":
                TpChambreAdo()
            case "LabyrintheFirst":
                LabyrintheFirst()
                break
            case "StartLabyrinthe":
                StartLabyrinthe()
                break
            case "LabyrintheRevange":
                LabyrintheRevange()
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
            case "CorrectAnswer":
                CorrectAnswer()
                break
            case "ApparitionDirecteur":
                ApparitionDirecteur()
                break
            case "ApparitionMartien":
                ApparitionMartien()
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
    
    //Gère les dialogues d'analyse psychologique de fin de partie
    func GestionDialoguePsycho(){
        
        if PsychoAnswer.isEmpty == false {
            
            if firstDialogue == false {
                DialogueNumber += 1
                bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume: 0.5)
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
                    GestionEventDialogue()
                }
            }
        }
    }
    
    //Fonction générale appelée au clic sur la vue
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
        if AllDialogue[self.oneProfil.sceneActuelle].backgroundDialogue[0] == "BackgroundDirecteur" || AllDialogue[self.oneProfil.sceneActuelle].backgroundDialogue[0] == "BackgroundMartien" {
            ApparitionPersonnage(namePersonnage: "Silhouette", fadeInDelay: 3, myTag: 0, taille : 0.65)
        }
    }
    
    @IBAction func DialogueTap(_ sender: UITapGestureRecognizer) {
        if tapEnable == true {
            GestionDialogue()
            UIView.animate(withDuration: 0.25, animations: {
                self.arrowView.alpha = 0
            }, completion : { _ in
                UIView.animate(withDuration: 0.25, animations: {
                    self.arrowView.alpha = 1
                })
            })
            
        }
    }
}
