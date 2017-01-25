//
//  LeaderboardsVC.swift
//  Filhoops
//
//  Created by Ron Ramirez on 1/10/17.
//  Copyright © 2017 Mochi Apps. All rights reserved.
//

import UIKit
import Firebase


class LeaderboardsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var players = [Player]()
    var playerSelected : Player!
    
    @IBOutlet weak var playersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playersTableView.delegate = self
        playersTableView.dataSource = self
        
        loadTopPlayersFromFirebase()
        
    }
    
    //MARK : UITableView Delegate Functions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let player = players[indexPath.row]
        if let cell = playersTableView.dequeueReusableCell(withIdentifier: "LeaderboardPlayerCell", for: indexPath) as? LeaderboardPlayerCell {
            cell.configureCell(player: player, cellNumber : indexPath.row)
            return cell
        }else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playerSelected = players[indexPath.row]
        performSegue(withIdentifier: "checkOutPlayer", sender: nil)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "checkOutPlayer" {
            let playerVC = segue.destination as! PlayerVC
            playerVC.currentPlayer = playerSelected
        }
    }
    
    private func loadTopPlayersFromFirebase() {
        //Load players from users database
        DataService.ds.REF_USERS.queryOrdered(byChild: "playerAverage").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                //Clear all players
                self.players = []
                
                for snap in snapshots {
                    print("LeaderbordsVC - USER : \(snap)")
                    if let userDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let user = Player(playerKey: key, playerData: userDict)
                        self.players.append(user)
                    }
                }
            }
            self.players.reverse()
            self.playersTableView.reloadData()
        })
    }
}
