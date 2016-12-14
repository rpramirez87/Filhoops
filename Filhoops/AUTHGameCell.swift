//
//  AUTHGameCell.swift
//  Filhoops
//
//  Created by Ron Ramirez on 12/14/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit

class AUTHGameCell: UITableViewCell {


    @IBOutlet weak var gymLabel: UILabel!
    @IBOutlet weak var team1Label: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var team2Label: UILabel!
    
    func configureCell(game : Game) {
        self.timeLabel.text = game.gameTime
        self.team1Label.text = game.team1
        self.team2Label.text = game.team2
        self.gymLabel.text = game.gym
    }

}
