//
//  TeamGameDataCell.swift
//  Filhoops
//
//  Created by Ron Ramirez on 12/2/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit

class TeamGameDataCell: UICollectionViewCell {
    
    @IBOutlet weak var gameTitleLabel: UILabel!
    
    func configureCell(game : Game) {
        
        self.gameTitleLabel.text = game.gameTitle
    
    }
}
