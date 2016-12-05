//
//  TeamVC.swift
//  Filhoops
//
//  Created by Ron Ramirez on 12/2/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit
import Firebase

class TeamVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var gameCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var teamPlayers = [Player]()
    
    var currentUsersTeam : String!
    var currentUsersTeamKey : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameCollectionView.dataSource = self
        gameCollectionView.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        DataService.ds.REF_USER_CURRENT_TEAM.observe(.value, with: { (snapshot) in
            if let currentTeam = snapshot.value as? String {
                
                self.currentUsersTeam = currentTeam
                self.teamNameLabel.text = currentTeam
            }
        })
        
        DataService.ds.REF_USER_CURRENT_TEAM_KEY.observe(.value, with: { (snapshot) in
            if let currentTeamKey = snapshot.value as? String {
                self.currentUsersTeamKey = currentTeamKey
                print("Current Team Key : \(self.currentUsersTeamKey!)")
            }
        })
    
        //Load players from users database\
        DataService.ds.REF_USERS.observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                //Clear all posts
                self.teamPlayers = []
                
                for snap in snapshots {
                    print("SNAP: \(snap)")
                    if let userDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        if let playerTeamKey = userDict["teamKey"] as? String {
                            if playerTeamKey == self.currentUsersTeamKey {
                                let key = snap.key
                                let user = Player(playerKey: key, playerData: userDict)
                                self.teamPlayers.append(user)
                            }
                        }
                    }
                }
                self.collectionView.reloadData()
            }
            
        })

        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamPlayers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let teamPlayer = teamPlayers[indexPath.row]
        
        if collectionView == self.collectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerCell", for: indexPath) as? PlayerCell {
                cell.configureCell(player : teamPlayer)
                return cell
            }else {
                return UICollectionViewCell()
            }
        }else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamGameDataCell", for: indexPath) as? TeamGameDataCell {
                return cell
            }else {
                return UICollectionViewCell()
            }
        }
    }
}
