//
//  StatsViewController.swift
//  ProjetImerirApp
//
//  Created by Student on 17/05/2017.
//  Copyright © 2017 Student. All rights reserved.
//
import AVFoundation
import UIKit

class StatsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var oneProfil = ProfilJoueur()
    var bruitageMusicPlayer = AVAudioPlayer()
    @IBOutlet weak var tableView: UITableView!
    
    var titreLibelle = ["Quiz", "ArcadeCookie", "ArcadeRangement", "ArcadeConsole", "ArcadeBac", "Labyrinthe"]
    
    var firstStatLibelle = ["Nombre de bonnes réponses :", "Tap réussit :", "Rangement réussit :", "Missile touché :", "Cours appris :", "Temps dans le labyrinthe final :"]
    var secondStatLibelle = ["Pourcentage :", "Pourcentage :", "Pourcentage :", "Pourcentage d'esquive :", "Pourcentage d'efficacité :", "Monstre tué :"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false

    }
    override func viewDidAppear(_ animated: Bool) {
        FonduApparition(myView: self, myDelai: 1)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titreLibelle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatCell") as! StatsTableViewCell
        cell.nameGameLabel.text = titreLibelle[indexPath.row]
        cell.firstStatLabel.text = firstStatLibelle[indexPath.row]
        cell.secondStatLabel.text = secondStatLibelle[indexPath.row]
        switch indexPath.row {
        case 0 :
            cell.firstResultLabel.text = "\(self.oneProfil.statsQuiz["bonneReponseQuiz"]!)"
            if self.oneProfil.statsQuiz["bonneReponseQuiz"]!.hashValue != 0 {
            self.oneProfil.statsQuiz["pourcentage"] = 100 * self.oneProfil.statsQuiz["bonneReponseQuiz"]!.hashValue / 40
            } else {
            self.oneProfil.statsQuiz["pourcentage"] = 0
            }
            cell.secondResultLabel.text = "\(self.oneProfil.statsQuiz["pourcentage"]!)%"
        break
        case 1 :
            cell.firstResultLabel.text = "\(self.oneProfil.statsCookie["cookieGoodTaped"]!)"
            cell.secondResultLabel.text = "\(self.oneProfil.statsCookie["pourcentage"]!)%"
            break
        case 2 :
            cell.firstResultLabel.text = "\(self.oneProfil.statsRangement["goodClassification"]!)"
            cell.secondResultLabel.text = "\(self.oneProfil.statsRangement["pourcentage"]!)%"
            break
        case 3 :
            cell.firstResultLabel.text = "\(self.oneProfil.statsConsole["missileHit"]!)"
            cell.secondResultLabel.text = "\(self.oneProfil.statsConsole["pourcentage"]!)%"
            break
        case 4 :
            cell.firstResultLabel.text = "\(self.oneProfil.statsBac["goodClassification"]!)"
            cell.secondResultLabel.text = "\(self.oneProfil.statsBac["pourcentage"]!)%"
            break
        case 5 :
            let timeSpent = secondsToHoursMinutesSeconds(seconds: self.oneProfil.statsLabyrinthe["timeSpent"]!)
            cell.firstResultLabel.text = "\(timeSpent.0)h, \(timeSpent.1)m"
            cell.secondResultLabel.text = "\(self.oneProfil.statsLabyrinthe["batKilled"]!)%"
            break
        default:
            break
        }
        return cell
    }

    @IBAction func tapToScreen(_ sender: Any) {
        bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
        UIView.animate(withDuration: 1, animations: {
            self.view.alpha = 0
        }, completion: { success in
            self.dismiss(animated:false)
        })
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
