//
//  GameDataCell.swift
//  Filhoops
//
//  Created by Ron Ramirez on 11/29/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit

class GameDataCell: UITableViewCell {

    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(gameNumber : Int, points : Int) {
        self.gameLabel.text = "Game \(gameNumber + 1)"
        self.pointLabel.text = "\(points)"
        
        
    }
}
