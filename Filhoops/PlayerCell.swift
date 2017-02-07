//
//  PlayerCell.swift
//  Filhoops
//
//  Created by Ron Ramirez on 12/2/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit
import Firebase

class PlayerCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerNumberLabel: UILabel!
    var player : Player!
    
    func configureCell(player : Player) {
        self.player = player
        
        //Set up name
        playerNameLabel.text = player.playerName
        playerNumberLabel.text = player.playerNumber
        
        //Set up Image
        let imageURL = URL(string : player.imageURL)
        var image : UIImage?
        
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
