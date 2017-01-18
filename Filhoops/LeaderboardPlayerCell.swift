//
//  LeaderboardPlayerCell.swift
//  Filhoops
//
//  Created by Ron Ramirez on 1/10/17.
//  Copyright © 2017 Mochi Apps. All rights reserved.
//

import UIKit

class LeaderboardPlayerCell: UITableViewCell {

    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var player : Player!
    
    func configureCell(player : Player) {
        self.player = player
        
        //Set up name
        playerNameLabel.text = player.playerName
        
        //Set up Image
        let url = NSURL(string : player.imageURL)
        //If data can be converted
        if let data = NSData(contentsOf: url as! URL){
            //Use the Image
            let img = UIImage(data : data as Data)
            self.profileImageView.image = img
        }
    }

}
