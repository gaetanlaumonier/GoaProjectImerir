import UIKit
import AVFoundation
import GameKit

class EmbedViewController: UIViewController, GKGameCenterControllerDelegate {
    
    var currentScene: UIViewController!
    var backgroundMusicPlayer = AVAudioPlayer()
    
    var gcEnabled = false
    
    let LEADERBOARD_LIFEPOINTS = "leaderboard.lifepoints"
    
    let gcConnectedNotif = Notification.Name(rawValue: "gcUserConnected")
    var gcUserCanceled = false
    var earnedAchievements:[String]! = []
    var totalNumberOfAchievements = 0
        
    func showScene(_ scene: UIViewController) {
        
        if currentScene == nil {
            currentScene = scene
            addChildViewController(currentScene)
            currentScene.loadViewIfNeeded()
            view.addSubview(currentScene.view)
        } else {
            addChildViewController(scene)
            
            transition(from: currentScene, to: scene, duration: 0, options: .transitionCrossDissolve, animations: nil, completion: {_ in
                self.currentScene.removeFromParentViewController()
                self.currentScene = scene
            })
        }
    }
    
    // MARK: - AUTHENTICATE LOCAL PLAYER
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()

        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {

                // 1. Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                
                // Recupere les succes déjà acquis et les stocke dans un tableau qui sera lu a chaque tentative d'ajout d'un succès
                self.loadOwnedAchievements(completion: { _ in
                    GKAchievementDescription.loadAchievementDescriptions(completionHandler: { (achievements, error) -> Void in
                        if let error = error {
                            print(error)
                            return
                        }
                        
                        if let achievements = achievements {
                            self.totalNumberOfAchievements = achievements.count
                        }
                        
                        // 2. Player is already authenticated & logged in, load game center
                        self.gcEnabled = true

                        
                        // Push notification (Utilisée dans le menuViewController pour mettre a jour le label du bouton gamecenter)
                        NotificationCenter.default.post(Notification(name: self.gcConnectedNotif))
                    })
                })
                
                
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error!)

                if (error as? GKError) != nil {
                    let gkerror = error as! GKError
                    
                    
                    if gkerror.errorCode == 2 {
                        self.gcUserCanceled = true
                    } else {
                        let alert = UIAlertController(title: "Game Center Error", message: gkerror.localizedDescription, preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
                        alert.addAction(action)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func loadOwnedAchievements(completion: (() -> Swift.Void)? = nil) {

        GKAchievement.loadAchievements(completionHandler: { (achievements, error) -> Void in
            
            if let error = error {
                print(error)
            }
            
            if let achievements = achievements {
                for achievement in achievements {
                    if achievement.isCompleted {
                        self.earnedAchievements.append(achievement.identifier!)
                    }
                }
            }
            
            completion?()
        })
        
    }
    
    func submitToLeaderboard(_ identifier: String, _ score: Int64) {
        
        let bestScore = GKScore(leaderboardIdentifier: identifier)
        bestScore.value = score

        GKScore.report([bestScore]) { (error) in
            
            guard error == nil  else { return }
            
            print("Score with value: \(bestScore.value) was submitted to leadeboard with identifier: \(identifier)!")
        }
    }
    
    func updateAchievement(_ identifier: String, _ percentage: Double = 1) {
        
        guard !hasAchievement(identifier) else {
            return
        }
        
        let percentage = percentage * 100
        
        // Avoid validating same achievement many times on rare case where achievement is pushed again before .report function answered
        if percentage >= 100 {
            self.earnedAchievements.append(identifier)
        }
        
        let achievement = GKAchievement(identifier: identifier)
        
        achievement.percentComplete = percentage
        achievement.showsCompletionBanner = true  // use Game Center's UI

        GKAchievement.report([achievement], withCompletionHandler: { (error:Error?) -> Void in
            if let error = error {
                print(error)
                return
            }
            
            print("Reported achievement: \(achievement)) to: \(percentage) %")
        })
    }
    
    // Delegate to dismiss the GC controller
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func hasAchievement(_ identifier: String) -> Bool {
        if earnedAchievements.contains(identifier) {
            return true
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InitController")
        
        showScene(initVc)
        
        authenticateLocalPlayer()
    }
}
