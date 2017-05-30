import UIKit
import AVFoundation

class EmbedViewController: UIViewController {
    
    var currentScene: UIViewController!
    var backgroundMusicPlayer = AVAudioPlayer()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InitController")
        
        showScene(initVc)
    }
}
