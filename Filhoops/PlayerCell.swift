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
