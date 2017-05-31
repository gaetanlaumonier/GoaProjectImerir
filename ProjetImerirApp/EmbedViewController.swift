import UIKit
import AVFoundation
import GameKit

class EmbedViewController: UIViewController, GKGameCenterControllerDelegate {
    
    var currentScene: UIViewController!
    var backgroundMusicPlayer = AVAudioPlayer()
    
    var gcEnabled = false
    var gcDefaultLeaderBoard = ""
    
    let LEADERBOARD_ID = "com.score.banalejournee"
    
    func showScene(_ scene: UIViewController) {
        print(scene)
        if currentScene == nil {
            currentScene = scene
            addChildViewController(currentScene)
            currentScene.loadViewIfNeeded()
            view.addSubview(currentScene.view)
        } else {
            addChildViewController(scene)
            
            transition(from: currentScene, to: scene, duration: 0, options: .transitionCrossDissolve, animations: nil, completion: {_ in
                print(scene)
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
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error)
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                })
                
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error)
            }
        }
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
    }
}
