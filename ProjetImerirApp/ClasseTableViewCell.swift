//
//  ClasseTableViewCell.swift
//  ProjetImerirApp
//
//  Created by Student on 13/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class ClasseTableViewCell: UITableViewCell {

    @IBOutlet weak var titleClasseLabel: DesignableLabel!
    @IBOutlet weak var libelleClasse: DesignableLabel!
    @IBOutlet weak var pouvoirClasse: DesignableLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
