
import UIKit

//Structure générale des questions du quiz
struct Question{
    
    var IdQuestion : Int!
    
    //énoncé
    var Question : String!
    
    //réponse possible
    var Choice : [String]!
    
    //réponse juste
    var Answer : String?
    
    //thème de la question
    var Topic : String!
    
    //A t'elle était déja posé ?
    var AlreadyPick : Bool!
    
    //Type de la question (Button, textfield ou psychologie)
    var TypeOfQuestion : String!
    
    //Message de retour
    var FeedBack: String!
    var FeedBackPsycho: [String]!
    
    //PV Perdu si mauvaise réponse
    var HPLost : Int!
    var ProfilConsequence : [String]!
    var HPLostArray : [Int]!
    
    //timer de la question
    var Timer : Float!
}

//Tableau de réactions aux réponses de questions, ex : "Bien répondu !"
struct AnswersReactions{
    var bonneReponse : [String]!
    var mauvaiseReponse : [String]!
    var gainPVReponse : [String]!
    var pertePVReponse : [String]!
    var chanceDuNoob : [String]!
    var evilAnswer : [String]!
    var droleAnswer : [String]!
    var argentAnswer : [String]!
    var sociableAnswer : [String]!
    var romantiqueAnswer : [String]!
    var timideAnswer : [String]!
    var soumisAnswer : [String]!
    var creatifAnswer : [String]!
    var crieurAnswer : [String]!
    
}

struct ClasseJoueur {
    
    var idClasse : String!
    var nomClasse : String!
    
    //Libellé dans le choix de classe
    var libelleClasse : String!
    
    //Libellé du pouvoir de la classe
    var pouvoirClasse : String!
    
    //Avantage de la classe dans les jeux
    var arcadeCookie : String!
    var arcadeRangement : String!
    var arcadeConsole : String!
    var arcadeBac : String!
    var labyrinthe : String!

}

struct Dialogue {
    
    var idDialogue : Int
    
    //Texte du dialogue
    var libelleDialogue : [String]
    
    //Le héros parle ou non ?
    var styleLabel : [String]
    
    //gestion des évenements
    var eventDialogue : [String]
    
    //background de la scène
    var backgroundDialogue : [String]
    
    //musique de la scène
    var musiqueDialogue : String
}

//Structure des dialogues du bilan psychologique de fin de partie
struct PsychoDialogue {
    
    var profilCrieur : [String]
    var profilSociable : [String]
    var profilTimide : [String]
    var profilInnovateur : [String]
    var profilEvil : [String]
    var profilGood : [String]
    var profilEqual : [String]

}

//Structure des crédits
struct Credit {
    
    var idLabel : Int
    
    //Libellé du crédit
    var textLabel : String
    
    //Gère les titres, sous titres et texte
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
                                          FeedBackPsycho : dict["FeedBackPsycho"].arrayValue.map {$0.string!},
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
                                                  chanceDuNoob: dict["chanceDuNoob"].arrayValue.map { $0.string!},
                                                  evilAnswer: dict["evilAnswer"].arrayValue.map { $0.string!},
                                                  droleAnswer: dict["droleAnswer"].arrayValue.map { $0.string!},
                                                  argentAnswer: dict["argentAnswer"].arrayValue.map { $0.string!},
                                                  sociableAnswer: dict["sociableAnswer"].arrayValue.map { $0.string!},
                                                  romantiqueAnswer: dict["romantiqueAnswer"].arrayValue.map { $0.string!},
                                                  timideAnswer: dict["timideAnswer"].arrayValue.map { $0.string!},
                                                  soumisAnswer: dict["soumisAnswer"].arrayValue.map { $0.string!},
                                                  creatifAnswer: dict["creatifAnswer"].arrayValue.map { $0.string!},
                                                  crieurAnswer: dict["crieurAnswer"].arrayValue.map { $0.string!}
                )
                
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
