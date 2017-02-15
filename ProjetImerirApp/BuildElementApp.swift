//A faire :
//background, style des boutons, label...
//sauvegarde
//enigmes speciales (clik sur élément)
//Background : Reveil, berceau, chambre ado, Ecran titre, Ecran de fin, game over, question ado (pas obligé)
//Element graphique : feuille de bac, arcade cookie ?
//background pr les classes ? (à priori non)
//segue button exit
//scenario
//git
//page view classe
//design header element (shadow)
//dismiss les view


//a aborder reunion
//Ce que jai fait (json, timer, background, classe)
//Ce qu'il a fait
//git
//reporting

import UIKit

struct Question{
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
            for (_, dict) in json["Questions"] {
                let thisObject = Question(Question: dict["Question"].stringValue,
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
                questions.append(thisObject)            }
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
