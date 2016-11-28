//
//  PlayerVC.swift
//  Filhoops
//
//  Created by Ron Ramirez on 11/19/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit
import FBSDKLoginKit


class PlayerVC: UIViewController {
    
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerImageView.layer.cornerRadius = 100
        playerImageView.clipsToBounds = true
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
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
                    self.playerNameLabel.text = "\(playerName)"
                }
                
                
            }
        }

        
    }
}
