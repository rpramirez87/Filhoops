//
//  AUTHGameVC.swift
//  Filhoops
//
//  Created by Ron Ramirez on 12/12/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit
import Firebase

class AUTHGameVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var currentGame : Game?
    @IBOutlet weak var team1Label: UILabel!
    @IBOutlet weak var team1ScoreTextField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var team2Label: UILabel!
    @IBOutlet weak var team2ScoreTextField: UITextField!
    @IBOutlet weak var gymLabel: UILabel!
    
    var team1Key : String?
    var team2Key : String?
    var team1Name : String = ""
    var team2Name : String = ""
    var gameKey : String = ""

    @IBOutlet weak var firstTeamTableVC: UITableView!
    @IBOutlet weak var secondTeamTableVC: UITableView!
    
    var team1Players = [Player]()
    var team2Players = [Player]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let game = currentGame {
            //self.titleLabel.text = game.gameTitle
            
            //Set up Labels
            team1Label.text = game.team1
            team2Label.text = game.team2
            timeLabel.text = game.gameTime
            dateLabel.text = game.gameDate
            gymLabel.text = game.gym
            
            
            
            team1Key = game.team1Key
            team2Key = game.team2Key
            team1Name = game.team1
            team2Name = game.team2
            gameKey = game.gameKey
            
        }

        firstTeamTableVC.delegate = self
        firstTeamTableVC.dataSource = self
        secondTeamTableVC.dataSource = self
        secondTeamTableVC.delegate = self
        
  
        
        //Load players from users database
        DataService.ds.REF_USERS.observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                //Clear all posts
                self.team1Players = []
                self.team2Players = []
                
                
                for snap in snapshots {
                    print("SNAP: \(snap)")
                    if let userDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        if let playerTeamKey = userDict["teamKey"] as? String {
                            if playerTeamKey == self.team1Key {
                                
                                let key = snap.key
                                let user = Player(playerKey: key, gameKey: self.gameKey, playerData: userDict)
                                self.team1Players.append(user)
                                
                            }
                            
                            if playerTeamKey == self.team2Key {
                                
                                let key = snap.key
                                let user = Player(playerKey: key, gameKey: self.gameKey, playerData: userDict)
                                self.team2Players.append(user)
                            }
                            
                        }
                    }
                }
                self.firstTeamTableVC.reloadData()
                self.secondTeamTableVC.reloadData()
            }
            
        })
        
        guard let team1FIRKey = team1Key, let team2FIRKey = team2Key else {
            print("WARNING : Team Keys are not set")
            return
            
        }
        
        //Load team names from teams database
        DataService.ds.REF_TEAMS.child(team1FIRKey).observeSingleEvent(of: .value, with: { (snapshot) in
            if let teamDict = snapshot.value as? Dictionary<String, AnyObject> {
                if let teamName = teamDict["name"] as? String {
                    print(teamName)
                    self.team1Name = teamName
                }
            }
        })
        
        DataService.ds.REF_TEAMS.child(team2FIRKey).observeSingleEvent(of: .value, with: { (snapshot) in
            if let teamDict = snapshot.value as? Dictionary<String, AnyObject> {
                if let teamName = teamDict["name"] as? String {
                    print(teamName)
                    self.team2Name = teamName
                }
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == secondTeamTableVC {
            return team2Name
        }else {
            return team1Name
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == firstTeamTableVC {
            return team1Players.count
        }else {
            return team2Players.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == firstTeamTableVC {
            let player = team1Players[indexPath.row]
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AUTHPlayerCell", for: indexPath) as? AUTHPlayerCell {
                cell.configureCell(player: player)
                return cell
            }else {
                return UITableViewCell()
            }
        }else {
            let player = team2Players[indexPath.row]
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AUTHPlayerCell", for: indexPath) as? AUTHPlayerCell {
                cell.configureCell(player: player)
                return cell
            }else {
                return UITableViewCell()
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
