//
//  AUTHGameVC.swift
//  Filhoops
//
//  Created by Ron Ramirez on 12/12/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit
import Firebase

class AUTHGameVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var firstTeamTableVC: UITableView!
    @IBOutlet weak var secondTeamTableVC: UITableView!
    @IBOutlet weak var team1Label: UILabel!
    @IBOutlet weak var team1ScoreTextField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var team2Label: UILabel!
    @IBOutlet weak var team2ScoreTextField: UITextField!
    @IBOutlet weak var gymLabel: UILabel!
    
    var currentGame : Game!
    var team1Players = [Player]()
    var team2Players = [Player]()
    
    //MARK: View Controller Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup Delegates
        firstTeamTableVC.delegate = self
        firstTeamTableVC.dataSource = self
        secondTeamTableVC.dataSource = self
        secondTeamTableVC.delegate = self
        team1ScoreTextField.delegate = self
        team2ScoreTextField.delegate = self
    
        //Set up Labels
        team1Label.text = currentGame.team1
        team2Label.text = currentGame.team2
        timeLabel.text = currentGame.gameTime
        dateLabel.text = currentGame.gameDate
        gymLabel.text = currentGame.gym
        team1ScoreTextField.text = currentGame.team1Score
        team2ScoreTextField.text = currentGame.team2Score
        
        //Load players from firebase to both teams
        loadPlayersFromFirebase()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        team1ScoreTextField.resignFirstResponder()
        team2ScoreTextField.resignFirstResponder()
    }
    
    //MARK: IBActions
    @IBAction func updateButtonPressed(_ sender: UIButton) {
        team1ScoreTextField.resignFirstResponder()
        team2ScoreTextField.resignFirstResponder()
        var currentGameReference : FIRDatabaseReference!
        currentGameReference = DataService.ds.REF_GAMES.child(currentGame.gameKey).child("team1Score")
        currentGameReference.setValue(team1ScoreTextField.text)
        currentGameReference = DataService.ds.REF_GAMES.child(currentGame.gameKey).child("team2Score")
        currentGameReference.setValue(team2ScoreTextField.text)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Tableview Delegate Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == firstTeamTableVC {
            return currentGame.team1
        }else {
            return currentGame.team2
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
    
    //MARK: Helper Functions
    
    private func loadPlayersFromFirebase() {
    
        //Load players from users database
        DataService.ds.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    print("AUTHGameVC : Team \(snap)")
                    if let userDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        if let playerTeamKey = userDict["teamKey"] as? String {
                            if playerTeamKey == self.currentGame.team1Key {
                                
                                let key = snap.key
                                let user = Player(playerKey: key, gameKey: self.currentGame.gameKey, playerData: userDict)
                                self.team1Players.append(user)
                            }
                            
                            if playerTeamKey == self.currentGame.team2Key {
                                
                                let key = snap.key
                                let user = Player(playerKey: key, gameKey: self.currentGame.gameKey, playerData: userDict)
                                self.team2Players.append(user)
                            }
                        }
                    }
                }
                self.firstTeamTableVC.reloadData()
                self.secondTeamTableVC.reloadData()
            }
        })
    }
}
