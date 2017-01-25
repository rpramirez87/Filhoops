//
//  TeamVC.swift
//  Filhoops
//
//  Created by Ron Ramirez on 12/2/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class TeamVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var gameCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var teamPlayers = [Player]()
    var teamGames = [Game]()
    var playerSelected : Player!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameCollectionView.dataSource = self
        gameCollectionView.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        DataService.ds.REF_USER_CURRENT.observeSingleEvent(of: .value, with: { (snapshot) in
            if let userDict = snapshot.value as? Dictionary<String, AnyObject> {
                //Retrieve Team
                if let playerTeam = userDict["team"] as? String {
                    print("Player Team \(playerTeam)")
                    self.teamNameLabel.text = playerTeam
                    self.uploadPlayersFromFirebaseBasedOn(team: playerTeam)
                }
                
                //Retrieve Team Key
                if let playerTeamKey = userDict["teamKey"] as? String {
                    print("Player Team Key \(playerTeamKey)")
                    self.uploadGames(teamKey: playerTeamKey, gameKey: "team1Key")
                    self.uploadGames(teamKey: playerTeamKey, gameKey: "team2Key")  
                }
            }
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToPlayer" {
            let playerVC = segue.destination as! PlayerVC
            playerVC.currentPlayer = playerSelected
        }
    }
    
    
    //MARK: Collection View Delegate Functions
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.collectionView {
            playerSelected = teamPlayers[indexPath.row]
            performSegue(withIdentifier: "goToPlayer", sender: nil)
            
        }else {
            // Setup Team Game
            let teamGame = teamGames[indexPath.row]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.collectionView {
            let padding =  CGFloat(10)
            let collectionViewSize = collectionView.frame.size.height - padding
            return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
        }else {
            return CGSize(width: 250, height: 100)
        }
    }
    
    //MARK: Helper Functions
    
    func uploadGames(teamKey : String, gameKey : String) {
        
        //Load team games from database based on key
        DataService.ds.REF_GAMES.queryOrdered(byChild: gameKey).queryEqual(toValue: teamKey).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                guard snapshot.exists() else {
                    print("No Team Games Here")
                    return
                }
                
                for snap in snapshots {
                    print("TeamVC - GAME: \(snap)")
                    if let gameDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        // Save unique key value for Team
                        let key = snap.key
                        let game = Game(gameKey: key, gameData: gameDict)
                        self.teamGames.append(game)
                    }
                }
                self.gameCollectionView.reloadData()
            }
        })
    }
    
    func uploadPlayersFromFirebaseBasedOn(team : String) {
        
        //Load players from users database
        DataService.ds.REF_USERS.queryOrdered(byChild: "team").queryEqual(toValue: team).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                //Clear all posts
                self.teamPlayers = []
                for snap in snapshots {
                    print("TeamVC - USER: \(snap)")
                    if let userDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let user = Player(playerKey: key, playerData: userDict)
                        self.teamPlayers.append(user)
                    }
                }
                self.collectionView.reloadData()
            }
        })
    }
}
