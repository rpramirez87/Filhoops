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
    var teamGames = [Game]()
    
    var currentUsersTeam : String!
    var currentUsersTeamKey : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameCollectionView.dataSource = self
        gameCollectionView.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self

        DataService.ds.REF_USER_CURRENT_TEAM.observeSingleEvent(of: .value, with: { (snapshot) in
            if let currentTeam = snapshot.value as? String {
                
                self.currentUsersTeam = currentTeam
                self.teamNameLabel.text = currentTeam
            }
        })
        DataService.ds.REF_USER_CURRENT_TEAM_KEY.observeSingleEvent(of: .value, with: { (snapshot) in
            if let currentTeamKey = snapshot.value as? String {
                self.currentUsersTeamKey = currentTeamKey
                print("Current Team Key : \(self.currentUsersTeamKey!)")
                self.uploadGames(currentGameKey: currentTeamKey)
            }
        })
    
        //Load players from users database
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
        
        if collectionView == self.collectionView {
            return teamPlayers.count
        }else {
            return teamGames.count
        }
 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            let teamPlayer = teamPlayers[indexPath.row]
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerCell", for: indexPath) as? PlayerCell {
                cell.configureCell(player : teamPlayer)
                return cell
            }else {
                return UICollectionViewCell()
            }
        }else {
            let teamGame = teamGames[indexPath.row]
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamGameDataCell", for: indexPath) as? TeamGameDataCell {
                cell.configureCell(game: teamGame)
                return cell
            }else {
                return UICollectionViewCell()
            }
        }
    }
    

    
    //MARK: Helper Functions
    
    func uploadGames(currentGameKey : String) {
        
        //Load team games from database based on key "team1Key"
        DataService.ds.REF_GAMES.queryOrdered(byChild: "team1Key").queryEqual(toValue: currentGameKey).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                guard snapshot.exists() else {
                    print("No Team Games Here")
                    return
                }
                
                for snap in snapshots {
                    print("SNAP: \(snap)")
                    if let gameDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        // Save unique key value for Team
                        let key = snap.key
                        let game = Game(gameKey: key, gameData: gameDict)
                        self.teamGames.append(game)
                        
                        if let gameTitle = gameDict["name"] as? String {
                            print(gameTitle)
                            
                        }
                    }
                }
                self.gameCollectionView.reloadData()
                
            }
        })
        
        //Load team games from database based on key "team2Key"
        DataService.ds.REF_GAMES.queryOrdered(byChild: "team2Key").queryEqual(toValue: currentGameKey).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                guard snapshot.exists() else {
                    print("No Team Games Here")
                    return
                }
                
                for snap in snapshots {
                    print("SNAP: \(snap)")
                    if let gameDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        // Save unique key value for Team
                        let key = snap.key
                        let game = Game(gameKey: key, gameData: gameDict)
                        self.teamGames.append(game)
                        
                        if let gameTitle = gameDict["name"] as? String {
                            print(gameTitle)
                            
                        }
                    }
                }
                self.gameCollectionView.reloadData()
                
            }
        })

    }
}
