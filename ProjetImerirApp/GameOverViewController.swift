
import UIKit
import AVFoundation

class GameOverViewController: UIViewController {
    
    var bruitageMusicPlayer = AVAudioPlayer()
    var embedViewController:EmbedViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        embedViewController = getEmbedViewController()
        embedViewController.view.alpha = 1
    }

    @IBAction func retourMenuButton(_
        sender: Any) {
        if let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "InitController") as? InitViewController
        {
           self.bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
            UIView.animate(withDuration: 3, delay: 0, options: .transitionCrossDissolve, animations: {
                self.view.alpha = 0
            } , completion: { success in
                vc.firstMenuForRun = false
                self.embedViewController.showScene(vc)
            })
        }else {
            print("Could not instantiate view controller with identifier of type InitViewController")
            return
        }
    }
}
