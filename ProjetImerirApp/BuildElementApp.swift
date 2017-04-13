
//mars :

//Background : Ecran titre, Ecran de fin, game over, les animations dans les jeux

//avril: 
//fin des jeu, gestion des pv
//fin du jeu
//musique

//mai
//save
//retaper note de cadrage, cahier des charges, proposition technico commerciale

//optionnel à voir vers la fin
//reflechir a la charte graphique et typographique
//uml, reflexion tests
//menu : revenir au menu

//a aborder reunion
//Ce que jai fait (table view classe, gif, debut du jeu)
//Ce qu'il a fait
//graphisme
//charte
//reporting




//a demander a grabo :
//dismiss, UML, Tests, crash de l'appli sauvegarde oneprofil

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
    
}

struct Dialogue {
    
    var idDialogue : Int
    var libelleDialogue : [String]
    var styleLabel : [String]
    var eventDialogue : [String]
    var backgroundDialogue : [String]
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
                                              pouvoirClasse: dict["pouvoirClasse"].stringValue)
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
                                          backgroundDialogue: dict["backgroundDialogue"].arrayValue.map { $0.string!})
                allDialogue.append(thisObject)
            }
        } catch {
            print("JSON Processing Failed")
        }
    } else {
        print("Fichier ProfilJoueur introuvable, vérifier la route et l'orthographe !")
    }
    return allDialogue
}
