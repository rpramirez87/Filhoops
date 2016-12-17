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
    
    
    var team1Key : String?
    var team2Key : String?
    
    var team1Name : String = ""
    var team2Name : String = ""

    @IBOutlet weak var firstTeamTableVC: UITableView!
    @IBOutlet weak var secondTeamTableVC: UITableView!
    
    var team1Players = [String]()
    var team2Players = [String]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        firstTeamTableVC.delegate = self
        firstTeamTableVC.dataSource = self
        secondTeamTableVC.dataSource = self
        secondTeamTableVC.delegate = self
        
        // Temporary
        team1Key = "34567sadjl"
        team2Key = "-KYkXRqA71Mfb0K8H2v5"
        
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
                                
                                if let playerName = userDict["name"] as? String {
                                    self.team1Players.append(playerName)
                                }
                            }
                            
                            if playerTeamKey == self.team2Key {
                                
                                if let playerName = userDict["name"] as? String {
                                    self.team2Players.append(playerName)
                                }
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlainCell")
            cell?.textLabel?.text = player
            return cell!
        }else {
            let player = team2Players[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlainCell")
            cell?.textLabel?.text = player
            return cell!
        }
    }
}
