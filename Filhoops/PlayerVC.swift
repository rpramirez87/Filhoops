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
    
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var careerHighLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    
    var playerPoints = [12, 14, 15, 0, 15, 14, 0, 14, 19]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PlayerVC")
        playerImageView.layer.cornerRadius = 100
        playerImageView.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        averageLabel.text = "\(playerPoints.average)"
        careerHighLabel.text = "\(playerPoints.max()!)"
        
        //Set up Graph Request
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "id, name, email, cover, picture"]).start {
            (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request: \(err)")
                
            }
            
            print("Result \(result)")
            
            if let dict = result as? Dictionary<String, AnyObject> {
                //if let URL = dict["cover"]?["source"] as? String {
                
                // Handle ID to get facebook picture
                if let id = dict["id"] as? String {
                    print("ID \(id)")
                    let facebookProfileUrl = "http://graph.facebook.com/\(id)/picture?type=large"
                    print(facebookProfileUrl)
                    let url = NSURL(string : facebookProfileUrl)
                    
                    //If data can be converted
                    if let data = NSData(contentsOf: url as! URL){
                        //Use the Image
                        let img = UIImage(data : data as Data)
                        self.playerImageView.image = img
                    }
                }
                
                // Handle name
                
                if let playerName = dict["name"] as? String {
                    print(playerName)
                    let names = playerName.components(separatedBy: [" "])
                    print(names[0])
                    print(names[1])
                    
                    //self.playerNameLabel.text = "\(playerName)"
                    self.firstNameLabel.text = "\(names.first)"
                    self.lastNameLabel.text = "\(names.last)"
                }
            }
        }
        
        
        
        // Get Player Keys
        
        DataService.ds.REF_USER_CURRENT.observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                print(snapshot.children.allObjects.count)
                for snap in snapshots {
                    print("SNAP: \(snap)")
                    if snap.key == "number" {
                        self.numberLabel.text = snap.value as! String?
                    }
                    
                    if snap.key == "team" {
                        self.teamNameLabel.text = snap.value as! String?
                    }
                }
            }
            
        })                                                                                                                                                                              
    }
    
    
    //MARK: Table View Delegate Functions
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
         if let cell = tableView.dequeueReusableCell(withIdentifier: "GameDataCell") as? GameDataCell {
            cell.configureCell(gameNumber: indexPath.row, points: playerPoints[indexPath.row])
            return cell
         }else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Always return 9 because there's only 9 games in a season
        return 9
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    
}
