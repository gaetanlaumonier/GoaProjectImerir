//
//  StatsTableViewCell.swift
//  ProjetImerirApp
//
//  Created by Student on 17/05/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class StatsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameGameLabel: DesignableLabel!
    @IBOutlet weak var firstStatLabel: DesignableLabel!
    @IBOutlet weak var firstResultLabel: DesignableLabel!
    @IBOutlet weak var secondStatLabel: DesignableLabel!
    @IBOutlet weak var secondResultLabel: DesignableLabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
