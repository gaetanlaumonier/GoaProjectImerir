class ProfilJoueur {
    
    //Nom du joueur
    var name : String
    
    //Point de vie du joueur
    var lifePoint : Int
    
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
    
}

