//
//  AUTHPlayerCell.swift
//  Filhoops
//
//  Created by Ron Ramirez on 12/18/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit
import Firebase

class AUTHPlayerCell: UITableViewCell {
    
    @IBOutlet weak var playerPointsStepper: UIStepper!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerNumberLabel: UILabel!
    @IBOutlet weak var playerPointsLabel: UITextField!
    
    var player : Player!
    var pointsReference : FIRDatabaseReference!
    var oldValue : Int = 0
    
    func configureCell(player : Player) {
        self.player = player
        pointsReference = player.currentGame.child("playerPoints")
        playerNameLabel.text = player.playerName
        playerNumberLabel.text = player.playerNumber
        
        pointsReference.observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            if snapshot.exists() {
                self.playerPointsLabel.text = "\(snapshot.value as! Int)"
                self.oldValue = snapshot.value as! Int
                self.playerPointsStepper.value = Double(self.oldValue)
            }
        })
        

        
       //playerPointsLabel.text = "\(player.points)"
        
    }

    @IBAction func stepperValueDidChange(_ sender: Any) {
        if Int(playerPointsStepper.value) > oldValue {
            oldValue += 1
            playerPointsLabel.text = "\(Int(playerPointsStepper.value))"
            player.adjustPoints(addPoint: true)
        }else if Int(playerPointsStepper.value) < oldValue {
            oldValue -= 1
            playerPointsLabel.text = "\(Int(playerPointsStepper.value))"
            player.adjustPoints(addPoint: false)
        }

        
    }
}
