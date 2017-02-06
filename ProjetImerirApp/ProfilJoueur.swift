class ProfilJoueur {
    
    //Nom du joueur
    var name : String
    
    //Point de vie du joueur
    var lifePoint : Int
    
    //Profil pour les questions de psychologie
    var dict_profil : [String:Int]
    
    //Chaine de caractères de la classe
    var classeJoueur : String
    
    init(name: String, lifePoint : Int, dict_profil : [String:Int], classeJoueur : String) {
        self.name = name
        self.lifePoint = lifePoint
        self.dict_profil = dict_profil
        self.classeJoueur = classeJoueur
    }
    
}

