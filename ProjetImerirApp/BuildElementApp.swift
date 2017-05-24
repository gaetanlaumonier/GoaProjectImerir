

//avril: 
//menu pause
//test dialogue style

//mai
//wiki

//a integrer a chaque jeux : header, musique, background, traitement de la fin, bruitage, pause
//nato
//3 jeu
//Traitement de la fin des jeux

//mercredi question, commit
//jeudi wiki, fin des jeux, test
//vendredi test, commentaires
//samedi revision oral et redactionnel

//optionnel à voir vers la fin
//uml, reflexion tests
//mode arcade

//a demander a grabo :
//dismiss, UML, Tests, crash de l'appli

import UIKit

struct Question{
    var IdQuestion : Int!
    var Question : String!
    var Choice : [String]!
    var Answer : String?
    var Topic : String!
    var AlreadyPick : Bool!
    var TypeOfQuestion : String!
    var FeedBack: String!
    var HPLost : Int!
    var ProfilConsequence : [String]!
    var HPLostArray : [Int]!
    var Timer : Float!
}

//Tableau de réactions aux réponses de questions, ex : "Bien répondu !"
struct AnswersReactions{
    var bonneReponse : [String]!
    var mauvaiseReponse : [String]!
    var gainPVReponse : [String]!
    var pertePVReponse : [String]!
    var chanceDuNoob : [String]!
}

struct ClasseJoueur {
    
    var idClasse : String!
    var nomClasse : String!
    var libelleClasse : String!
    var pouvoirClasse : String!
    var arcadeCookie : String!
    var arcadeRangement : String!
    var arcadeConsole : String!
    var arcadeBac : String!
    var labyrinthe : String!

}

struct Dialogue {
    
    var idDialogue : Int
    var libelleDialogue : [String]
    var styleLabel : [String]
    var eventDialogue : [String]
    var backgroundDialogue : [String]
    var musiqueDialogue : String
}

struct PsychoDialogue {
    
    var profilCrieur : [String]
    var profilSociable : [String]
    var profilTimide : [String]
    var profilInnovateur : [String]
    var profilEvil : [String]
    var profilGood : [String]
    var profilEqual : [String]

}

struct Credit {
    
    var idLabel : Int
    var textLabel : String
    var typeLabel : String
    
}

//Création de l'Objet des questions à partir du json
func buildQuestions() -> [Question]{
    var questions = [Question]()
    if let file = Bundle.main.path(forResource: "QuestionsImerirApp", ofType: "json") {
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: file))
            let json = JSON(data: data)
            var idQuestion : Int = 0
            for (_, dict) in json["Questions"] {
                let thisObject = Question(IdQuestion: idQuestion,
                                          Question: dict["Question"].stringValue,
                                          Choice: dict["Choice"].arrayValue.map { $0.string!},
                                          Answer: dict["Answer"].stringValue,
                                          Topic: dict["Topic"].stringValue,
                                          AlreadyPick: false,
                                          TypeOfQuestion: dict["TypeOfQuestion"].stringValue,
                                          FeedBack: dict["FeedBack"].stringValue,
                                          HPLost: dict["HPLost"].intValue,
                                          ProfilConsequence : dict["ProfilConsequence"].arrayValue.map {$0.string!},
                                          HPLostArray : dict["HPLostArray"].arrayValue.map {$0.int!},
                                          Timer : dict["Timer"].floatValue)
                questions.append(thisObject)
            idQuestion += 1
            }
        } catch {
            print("JSON Processing Failed")
        }
    } else {
        print("Fichier introuvable QuestionsImerirApp, vérifier la route et l'orthographe !")
    }
    return questions
}

//Création de l'Objet des réactions à partir du json
func buildAnswersReactions() -> [AnswersReactions]{
    var answersReactions = [AnswersReactions]()
    
    if let file = Bundle.main.path(forResource: "QuestionsImerirApp", ofType: "json") {
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: file))
            let json = JSON(data: data)
            for (_, dict) in json["AnswersReactions"] {
                let thisObject = AnswersReactions(bonneReponse: dict["bonneReponse"].arrayValue.map { $0.string!},
                                                  mauvaiseReponse: dict["mauvaiseReponse"].arrayValue.map { $0.string!},
                                                  gainPVReponse: dict["gainPVReponse"].arrayValue.map { $0.string!},
                                                  pertePVReponse: dict["pertePVReponse"].arrayValue.map { $0.string!},
                                                  chanceDuNoob: dict["chanceDuNoob"].arrayValue.map { $0.string!})
                answersReactions.append(thisObject)
            }
        } catch {
            print("JSON Processing Failed")
        }
    } else {
        print("Fichier QuestionsImerirApp introuvable, vérifier la route et l'orthographe !")
    }
    return answersReactions
}

//Création de l'Objet des classes à partir du json
func buildClasseJoueur() -> [ClasseJoueur]{
    var allClasse = [ClasseJoueur]()
    if let file = Bundle.main.path(forResource: "ClasseJoueur", ofType: "json") {
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: file))
            let json = JSON(data: data)
            for (_, dict) in json["ClasseJoueur"] {
                let thisObject = ClasseJoueur(idClasse: dict["idClasse"].stringValue,
                                              nomClasse: dict["nomClasse"].stringValue,
                                              libelleClasse: dict["libelleClasse"].stringValue,
                                              pouvoirClasse: dict["pouvoirClasse"].stringValue,
                                              arcadeCookie: dict["arcadeCookie"].stringValue,
                                              arcadeRangement: dict["arcadeRangement"].stringValue,
                                              arcadeConsole: dict["arcadeConsole"].stringValue,
                                              arcadeBac: dict["arcadeBac"].stringValue,
                                              labyrinthe: dict["labyrinthe"].stringValue
                    
)
                allClasse.append(thisObject)
            }
        } catch {
            print("JSON Processing Failed")
        }
    } else {
        print("Fichier ProfilJoueur introuvable, vérifier la route et l'orthographe !")
    }
    return allClasse
}

//Création de l'Objet des dialogues à partir du json
func buildDialogue() -> [Dialogue]{
    var allDialogue = [Dialogue]()
    if let file = Bundle.main.path(forResource: "Dialogue", ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: file))

            let json = JSON(data: data)

            for (_, dict) in json["Dialogue"] {
                let thisObject = Dialogue(idDialogue: dict["idDialogue"].intValue,
                                          libelleDialogue: dict["libelleDialogue"].arrayValue.map { $0.string!},
                                          styleLabel: dict["styleLabel"].arrayValue.map { $0.string!},
                                          eventDialogue: dict["eventDialogue"].arrayValue.map { $0.string!},
                                          backgroundDialogue: dict["BackgroundDialogue"].arrayValue.map { $0.string!},
                                          musiqueDialogue: dict["MusiqueDialogue"].stringValue)
                allDialogue.append(thisObject)
            }
        } catch {
            print("JSON Processing Failed")
        }
    } else {
        print("Fichier Dialogue introuvable, vérifier la route et l'orthographe !")
    }
    return allDialogue
}

//Création de l'Objet des dialogues de psychologie à partir du json
func buildPsychoDialogue() -> [PsychoDialogue]{
    var allPsychoDialogue = [PsychoDialogue]()
    if let file = Bundle.main.path(forResource: "Dialogue", ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: file))
            
            let json = JSON(data: data)
            
            for (_, dict) in json["Psychologie"] {
                let thisObject = PsychoDialogue(profilCrieur: dict["profil_crieur"].arrayValue.map { $0.string!},
                                          profilSociable: dict["profil_sociable"].arrayValue.map { $0.string!},
                                          profilTimide: dict["profil_timide"].arrayValue.map { $0.string!},
                                          profilInnovateur: dict["profil_innovateur"].arrayValue.map { $0.string!},
                                          profilEvil: dict["profil_evil"].arrayValue.map { $0.string!},
                                          profilGood: dict["profil_good"].arrayValue.map { $0.string!},
                                          profilEqual: dict["profil_equal"].arrayValue.map { $0.string!})

                allPsychoDialogue.append(thisObject)
            }
        } catch {
            print("JSON Processing Failed")
        }
    } else {
        print("Fichier Dialogue introuvable, vérifier la route et l'orthographe !")
    }
    return allPsychoDialogue
}


//Création de l'Objet des Crédits à partir du json
func buildCredit() -> [Credit]{
    var allCredit = [Credit]()
    if let file = Bundle.main.path(forResource: "Credit", ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: file))
            
            let json = JSON(data: data)
            
            for (_, dict) in json["Credit"] {
                let thisObject = Credit(idLabel: dict["idLabel"].intValue,
                                        textLabel: dict["textLabel"].stringValue,
                                        typeLabel: dict["typeLabel"].stringValue)
                
                allCredit.append(thisObject)
            }
        } catch {
            print("JSON Processing Failed")
        }
    } else {
        print("Fichier Credit introuvable, vérifier la route et l'orthographe !")
    }
    return allCredit
}
