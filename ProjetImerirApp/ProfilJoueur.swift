import UIKit

class ProfilJoueur : NSObject, NSCoding{
    
    //Nom du joueur
    var name : String
    
    //Point de vie du joueur
    var lifePoint : Int {
        didSet{
            if lifePoint <= 0 {
                if let vc = UIStoryboard(name:"GameOver", bundle:nil).instantiateInitialViewController() as? GameOverViewController
                {
                    let topController = UIApplication.topViewController()
                    UIView.animate(withDuration: 3, delay: 0, options: .transitionCrossDissolve, animations: {
                        topController?.view.alpha = 0
                    } , completion: { success in
                        topController?.present(vc, animated: false, completion: nil)
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
    var classeJoueur : String
    
    //Moment du scénario atteint
    var sceneActuelle : Int
    
    //Compte le nombre de bonne réponses aux questions (stats)
    var bonneReponseQuiz : Int
    
    //Stock des questions
    var questionAlreadyPick : [Int]
    
    init(name: String, lifePoint : Int, dictProfil : [String:Int], classeJoueur : String, sceneActuelle : Int, bonneReponseQuiz : Int, questionAlreadyPick : [Int]) {
        self.name = name
        self.lifePoint = lifePoint
        self.dictProfil = dictProfil
        self.classeJoueur = classeJoueur
        self.sceneActuelle = sceneActuelle
        self.bonneReponseQuiz = bonneReponseQuiz
        self.questionAlreadyPick = questionAlreadyPick
    }
 
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "myName")
        aCoder.encodeCInt(Int32(lifePoint), forKey: "myLifePoint")
        aCoder.encode(dictProfil, forKey: "myDictProfil")
        aCoder.encode(classeJoueur, forKey: "myClasseJoueur")
        aCoder.encodeCInt(Int32(sceneActuelle), forKey: "mySceneActuelle")
        aCoder.encodeCInt(Int32(bonneReponseQuiz), forKey: "myBonneReponseQuiz")
        aCoder.encode(questionAlreadyPick, forKey: "myQuestionAlreadyPick")
        
    }

    required init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "myName") as? String
        let lifePoint = aDecoder.decodeInteger(forKey: "myLifePoint")
        let dictProfil = aDecoder.decodeObject(forKey: "myDictProfil") as? [String:Int]
        let classeJoueur = aDecoder.decodeObject(forKey: "myClasseJoueur") as? String
        let sceneActuelle = aDecoder.decodeInteger(forKey: "mySceneActuelle")
        let bonneReponseQuiz = aDecoder.decodeInteger(forKey: "myBonneReponseQuiz")
        let questionAlreadyPick = aDecoder.decodeObject(forKey: "myQuestionAlreadyPick")  as! [Int]
        
        self.name = name!
        self.lifePoint = lifePoint
        self.dictProfil = dictProfil!
        self.classeJoueur = classeJoueur!
        self.sceneActuelle = sceneActuelle
        self.bonneReponseQuiz = bonneReponseQuiz
        self.questionAlreadyPick = questionAlreadyPick
    }

}


