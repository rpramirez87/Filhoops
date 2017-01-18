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
    @IBOutlet weak var playerTeamLabel: UILabel!
    @IBOutlet weak var playerAverageLabel: UILabel!

    var player : Player!
    
    func configureCell(player : Player, cellNumber : Int) {
        self.player = player
        
        //Set up Labels
        playerNameLabel.text = player.playerName
        playerTeamLabel.text = player.team
        numberLabel.text = "\(cellNumber + 1)."
        playerAverageLabel.text = "\(40 / (cellNumber + 1))"
        
        //Set up Image
        let imageURL = URL(string: player.imageURL)
        var image: UIImage?
        if let url = imageURL {
            //All network operations has to run on different thread(not on main thread).
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData = NSData(contentsOf: url)
                //All UI operations has to run on main thread.
                DispatchQueue.main.async {
                    if imageData != nil {
                        image = UIImage(data: imageData as! Data)
                        self.profileImageView.image = image
                    } else {
                        image = nil
                    }
                }
            }
        }
    }

}
