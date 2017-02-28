class ProfilJoueur {
    
    //Nom du joueur
    var name : String
    
    //Point de vie du joueur
    var lifePoint : Int
    
    //Profil pour les questions de psychologie
    var dictProfil : [String:Int]
    
    //Chaine de caractères de la classe
    var classeJoueur : String
    
    init(name: String, lifePoint : Int, dictProfil : [String:Int], classeJoueur : String) {
        self.name = name
        self.lifePoint = lifePoint
        self.dictProfil = dictProfil
        self.classeJoueur = classeJoueur
    }
    
}

