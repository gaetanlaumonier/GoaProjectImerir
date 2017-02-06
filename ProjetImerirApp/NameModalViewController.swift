//
//  NameModalViewController.swift
//  GoaProject
//
//  Created by Student on 02/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class NameModalViewController: UIViewController {
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var contrainteLabel: UILabel!
    @IBOutlet weak var NameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Dialogue" {
            let toViewController = segue.destination as! DialogueViewController
            toViewController.oneProfil.name = nameField.text!
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "Dialogue" {
            let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789")
            if nameField.text?.rangeOfCharacter(from: characterset.inverted) != nil {
                contrainteLabel.text = "Caractères spéciaux indésirables"
                return false
            }   else if nameField.text == "" {
                contrainteLabel.text = "Le nom est vide"
                return false
            } else {
                performSegue(withIdentifier: "Dialogue", sender: self)
                return true
            }
        } else {
            return false
        }
    }
    @IBAction func dismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
