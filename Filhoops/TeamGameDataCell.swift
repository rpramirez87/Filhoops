//
//  TeamGameDataCell.swift
//  Filhoops
//
//  Created by Ron Ramirez on 12/2/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit

class TeamGameDataCell: UICollectionViewCell {
    
    @IBOutlet weak var gameTimeLabel: UILabel!
    @IBOutlet weak var gameDateLabel: UILabel!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var team1ScoreLabel: UILabel!
    @IBOutlet weak var team2ScoreLabel: UILabel!
    
    func configureCell(game : Game) {
        self.gameTitleLabel.text = game.gameTitle
        self.gameTimeLabel.text = game.gameTime
        self.gameDateLabel.text = game.gameDate
        self.team1ScoreLabel.text = game.team1Score
        self.team2ScoreLabel.text = game.team2Score
    }
}
