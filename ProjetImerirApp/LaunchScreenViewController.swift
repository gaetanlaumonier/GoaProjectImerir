//
//  LaunchScreenViewController.swift
//  ProjetImerirApp
//
//  Created by Student on 24/05/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        if let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "InitController") as? InitViewController
        {
            UIView.animate(withDuration: 1, animations: {
                self.view.alpha = 0
            } , completion: { success in
                self.present(vc, animated: false, completion: nil)
            })
        }else {
            print("Could not instantiate view controller with identifier of type InitTableViewController")
            return
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
