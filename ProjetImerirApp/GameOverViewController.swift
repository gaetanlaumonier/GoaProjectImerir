
import UIKit
import AVFoundation

class GameOverViewController: UIViewController {
    
    var bruitageMusicPlayer = AVAudioPlayer()

    @IBAction func retourMenuButton(_
        sender: Any) {
        if let vc = UIStoryboard(name:"Main", bundle:nil).instantiateInitialViewController() as? InitViewController
        {
           self.bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
            UIView.animate(withDuration: 3, delay: 0, options: .transitionCrossDissolve, animations: {
                self.view.alpha = 0
            } , completion: { success in
                vc.firstMenuForRun = false
                self.view.window?.rootViewController = vc
            })
        }else {
            print("Could not instantiate view controller with identifier of type InitViewController")
            return
        }
    }
}
