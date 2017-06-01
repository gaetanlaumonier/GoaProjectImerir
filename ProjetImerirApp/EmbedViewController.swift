import UIKit
import AVFoundation
import GameKit

class EmbedViewController: UIViewController, GKGameCenterControllerDelegate {
    
    var currentScene: UIViewController!
    var backgroundMusicPlayer = AVAudioPlayer()
    
    var gcEnabled = false
    var gcDefaultLeaderBoard = ""
    
    let LEADERBOARD_ID = "leaderboard.lifepoints"
    
    let gcConnectedNotif = Notification.Name(rawValue: "gcUserConnected")
    var gcUserCanceled = false
    
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
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                
                GKAchievement.resetAchievements(completionHandler: nil)
                self.loadAchievements()
                NotificationCenter.default.post(Notification(name: self.gcConnectedNotif))

                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if let error = error {
                        print(error)
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
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
                        let alert = UIAlertController(title: "Authentication Error", message: gkerror.localizedDescription, preferredStyle: .alert)
                        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        
                        alert.addAction(action)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func updateAchievement(_ achievement: String, _ percentage: Double = 1.0) {
        
        print(achievement)
        let achievement = GKAchievement(identifier: achievement)
        
        achievement.percentComplete = percentage
        achievement.showsCompletionBanner = true  // use Game Center's UI

        GKAchievement.report([achievement], withCompletionHandler: { (error:Error?) -> Void in
            guard error == nil else {
                print(error)
                return
            }
            
            print("Reported achievement: \(achievement)) to: \(percentage) %")
        })
    }
    
    func loadAchievements() {
        
        GKAchievement.loadAchievements(completionHandler: { (achievements , error) -> Void in
            if let error = error {
                print(error)
            }
            
            print("lalalalala")
            print(achievements)
            
        })
        
    }
    
    // Delegate to dismiss the GC controller
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InitController")
        
        showScene(initVc)
        
        authenticateLocalPlayer()
        
        print(NotificationCenter.default)
    }
}
