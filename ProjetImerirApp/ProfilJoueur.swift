import UIKit

class ProfilJoueur : NSObject, NSCoding{
    
    //Nom du joueur
    var name : String = ""
    
    //Point de vie du joueur
    var lifePoint : Int = 0 {
        didSet{
            if lifePoint <= 0 {
                if let vc = UIStoryboard(name:"GameOver", bundle:nil).instantiateInitialViewController() as? GameOverViewController
                {
                    let topController = UIApplication.topViewController()
                   
                    switch topController! {
                    case is QuestionViewController:
                        let presentingViewType = topController as! QuestionViewController
                        presentingViewType.startTimer.invalidate()
                        break
                    case is CookieViewController:
                        let presentingViewType = topController as! CookieViewController
                        presentingViewType.myTimer.invalidate()
                        presentingViewType.gamePause = true
                        break
                    case is RangementViewController:
                        let presentingViewType = topController as! RangementViewController
                        presentingViewType.endGameTimer.invalidate()
                        presentingViewType.gamePause = true
                        break
                    case is LabyrintheViewController:
                        let presentingViewType = topController as! LabyrintheViewController
                        if presentingViewType.isFirstMaze {
                            presentingViewType.firstGameTimer.invalidate()
                        }
                        break
                    case is ConsoleViewController:
                        let presentingViewType = topController as! ConsoleViewController
                        presentingViewType.pauseGame()
                        break
                    case is BacViewController:
                        let presentingViewType = topController as! BacViewController
                        presentingViewType.pauseGame()
                        break
                        
                    default:
                        print("No timer")
                        break
                    }

                    UIView.animate(withDuration: 3, delay: 0, options: .transitionCrossDissolve, animations: {
                        topController?.view.alpha = 0
                        
                    } , completion: { success in
                        topController?.view.window?.rootViewController = vc
                       // topController?.present(vc, animated: false, completion: nil)
                    })
                }else {
                    print("Could not instantiate view controller")
                    return
                }
            }
        }
    }
    
    //Profil pour les questions de psychologie
    var dictProfil : [String:Int]
    
    //Chaine de caractères de la classe
    var classeJoueur : String = ""
    
    //Moment du scénario atteint
    var sceneActuelle : Int = 0
    
    //Regroupe les statistiques du quiz
    var statsQuiz : [String:Int]!
    
    //Regroupe les statistiques de l'arcadeCookie
    var statsCookie : [String:Int]!

    //Regroupe les statistiques de l'arcadeRangement
    var statsRangement : [String:Int]!

    //Regroupe les statistiques de l'arcadeConsole
    var statsConsole : [String:Int]!

    //Regroupe les statistiques de l'arcadeBac
    var statsBac : [String:Int]!

    //Regroupe les statistiques du labyrinthe
    var statsLabyrinthe : [String:Int]!

    //Stock des questions
    var questionAlreadyPick : [Int] = []
    
    override init() {
        self.dictProfil = ["profil_crieur":0, "profil_sociable" : 0, "profil_timide":0, "profil_innovateur":0, "profil_evil":0, "profil_good":0]

        self.statsQuiz = ["bonneReponseQuiz":0, "pourcentage" : 0]
        self.statsCookie = ["cookieGoodTaped":0, "pourcentage" : 0]
        self.statsRangement = ["goodClassification":0, "pourcentage" : 0]
        self.statsConsole = ["missileHit":0, "pourcentage" : 0]
        self.statsBac = ["goodClassification":0, "pourcentage" : 0]
        self.statsLabyrinthe = ["timeSpent":0, "batKilled" : 0]
    }
    
    init(name: String, lifePoint : Int, dictProfil : [String:Int], classeJoueur : String, sceneActuelle : Int, statsQuiz : [String:Int], statsCookie : [String:Int], statsRangement : [String:Int], statsConsole : [String:Int], statsBac : [String:Int], statsLabyrinthe : [String:Int], questionAlreadyPick : [Int]) {
        self.name = name
        self.lifePoint = lifePoint
        self.dictProfil = dictProfil
        self.classeJoueur = classeJoueur
        self.sceneActuelle = sceneActuelle
        self.statsQuiz = statsQuiz
        self.statsCookie = statsCookie
        self.statsRangement = statsRangement
        self.statsConsole = statsConsole
        self.statsBac = statsBac
        self.statsLabyrinthe = statsLabyrinthe
        self.questionAlreadyPick = questionAlreadyPick
    }
 
    //Encode l'objet pour la sauvegarde interne
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "myName")
        aCoder.encodeCInt(Int32(lifePoint), forKey: "myLifePoint")
        aCoder.encode(dictProfil, forKey: "myDictProfil")
        aCoder.encode(classeJoueur, forKey: "myClasseJoueur")
        aCoder.encodeCInt(Int32(sceneActuelle), forKey: "mySceneActuelle")
        aCoder.encode(statsQuiz, forKey: "myStatsQuiz")
        aCoder.encode(statsCookie, forKey: "myStatsCookie")
        aCoder.encode(statsRangement, forKey: "myStatsRangement")
        aCoder.encode(statsConsole, forKey: "myStatsConsole")
        aCoder.encode(statsBac, forKey: "myStatsBac")
        aCoder.encode(statsLabyrinthe, forKey: "myStatsLabyrinthe")
        aCoder.encode(questionAlreadyPick, forKey: "myQuestionAlreadyPick")
        
    }
    //Décode l'objet pour la sauvegarde interne
    required init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "myName") as? String
        let lifePoint = aDecoder.decodeInteger(forKey: "myLifePoint")
        let dictProfil = aDecoder.decodeObject(forKey: "myDictProfil") as? [String:Int]
        let classeJoueur = aDecoder.decodeObject(forKey: "myClasseJoueur") as? String
        let sceneActuelle = aDecoder.decodeInteger(forKey: "mySceneActuelle")
        let statsQuiz = aDecoder.decodeObject(forKey: "myStatsQuiz") as? [String:Int]
        let statsCookie = aDecoder.decodeObject(forKey: "myStatsCookie") as? [String:Int]
        let statsRangement = aDecoder.decodeObject(forKey: "myStatsRangement") as? [String:Int]
        let statsConsole = aDecoder.decodeObject(forKey: "myStatsConsole") as? [String:Int]
        let statsBac = aDecoder.decodeObject(forKey: "myStatsBac") as? [String:Int]
        let statsLabyrinthe = aDecoder.decodeObject(forKey: "myStatsLabyrinthe") as? [String:Int]
        let questionAlreadyPick = aDecoder.decodeObject(forKey: "myQuestionAlreadyPick")  as! [Int]
        
        self.name = name!
        self.lifePoint = lifePoint
        self.dictProfil = dictProfil!
        self.classeJoueur = classeJoueur!
        self.sceneActuelle = sceneActuelle
        self.statsQuiz = statsQuiz
        self.statsCookie = statsCookie
        self.statsRangement = statsRangement
        self.statsConsole = statsConsole
        self.statsBac = statsBac
        self.statsLabyrinthe = statsLabyrinthe
        self.questionAlreadyPick = questionAlreadyPick
    }

}
