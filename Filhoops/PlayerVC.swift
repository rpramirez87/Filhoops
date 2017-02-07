//
//  PlayerVC.swift
//  Filhoops
//
//  Created by Ron Ramirez on 11/19/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class PlayerVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var careerHighLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    // Current Player - if nil/ set to current user ?? if set, set to other users
    var currentPlayer : Player?
    var playerGamePoints = [Int]()
    
    private struct Storyboard {
        static let GameCell = "GameDataCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if let player = currentPlayer {
            print("Other User \(player.playerName)")
    
            backButton.isUserInteractionEnabled = true
            backButton.isHidden = false
            
            //Set up other users UI and Games
            updateUIBasedOnPlayer(player: player)
            updateGamesBasedOnPlayer(player: player)
        }else {
            
            // Current User
            backButton.isHidden = true
            backButton.isUserInteractionEnabled = false
            
            DataService.ds.REF_USER_CURRENT.observeSingleEvent(of: .value, with: { (snapshot) in
                let currentUserKey = snapshot.key
                let currentUserData = snapshot.value as? Dictionary<String, AnyObject>
                let currentPlayer = Player(playerKey: currentUserKey, playerData: currentUserData!)
                self.updateUIBasedOnPlayer(player: currentPlayer)
                self.updateGamesBasedOnPlayer(player: currentPlayer)
            })
        }
    }
    
    //MARK: Table View Delegate Functions
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.GameCell) as? GameDataCell {
            cell.configureCell(gameNumber: indexPath.row, points: playerGamePoints[indexPath.row])
            return cell
        }else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerGamePoints.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    
    //MARK: IBActions
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Helper Functions
    
    func updateUIBasedOnPlayer(player : Player) {
        
        //Setup Labels
        numberLabel.text = player.playerNumber
        teamNameLabel.text = player.team
        careerHighLabel.text = "\(player.max)"
        averageLabel.text = "\(player.average)"
        
        //Set up first name and last name
        let names = player.playerName.components(separatedBy: [" "])
        print(names[0])
        print(names[1])
        self.firstNameLabel.text = "\(names.first!)"
        self.lastNameLabel.text = "\(names.last!)"

        //Set up image
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
                        self.playerImageView.image = image
                    } else {
                        image = nil
                    }
                }
            }
        }
    }
    
    func updateGamesBasedOnPlayer(player : Player) {
        //Setup Games
        DataService.ds.REF_USERS.child(player.playerKey).child("games").observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.playerGamePoints = []
                for snap in snapshots {
                    print("PlayerVC - GAMES: \(snap)")
                    if let gameDict = snap.value as? Dictionary<String, AnyObject> {
                        if let points = gameDict["playerPoints"] as? Int {
                            print("POINTS \(points)")
                            self.playerGamePoints.append(points)
                        }
                    }
                }
                self.tableView.reloadData()
            }
        })
    }
}
