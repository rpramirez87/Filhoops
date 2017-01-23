//
//  SignUpVC.swift
//  Filhoops
//
//  Created by Ron Ramirez on 12/3/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class SignUpVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var teamPickerView: UIPickerView!
    @IBOutlet weak var jerseyLabel: UILabel!
    @IBOutlet weak var numberSlider: UISlider!
    
    var teams = [String]()
    var teamKeys = [String]()
    var teamName : String?
    var teamKey : String?
    var playerName : String?
    var profileImageURL : String?
    var playerNumber : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamPickerView.delegate = self
        teamPickerView.dataSource = self
        facebookGraphRequest()
        
        DataService.ds.REF_TEAMS.observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                //Clear all posts
                self.teams = [""]
                self.teamKeys = [""]
                
                for snap in snapshots {
                    print("SNAP: \(snap)")
                    if let teamDict = snap.value as? Dictionary<String, AnyObject> {
                        if let teamName = teamDict["name"] as? String {
                            self.teams.append(teamName)
                            self.teamKeys.append(snap.key)
                        }
                    }
                }
                self.teamPickerView.reloadAllComponents()
            }
        })
    }
    
    //MARK: Picker View Delegate Functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teams.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return teams[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        teamName = teams[row]
        teamKey = teamKeys[row]
    }
    
    //MARK: IBActions 
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        guard let teamName = self.teamName, let teamKey = self.teamKey else {
            print("WARNING: Please Select A Team")
            return
        }
        
        guard let playerImageURL = self.profileImageURL,  let playerName = self.playerName else {
            print("WARNING: Facebook Error getting User's Profile Picture and Name")
            self.profileImageURL = "http://www.sawyoo.com/postpic/2011/04/facebook-no-profile-picture-icon_698868.jpg"
            self.playerName = "User"
            return
        }
        
        guard let number = self.playerNumber else {
            print("WARNING: Please select a Jersey Number")
            return
        }

        
        // Add team to user
        var currentUserReference : FIRDatabaseReference!
        currentUserReference = DataService.ds.REF_USER_CURRENT
        let userData = ["teamKey" : teamKey, "team" : teamName, "name" : playerName, "url" : playerImageURL, "number" : number]
        currentUserReference.updateChildValues(userData)
        
        // Add user to team
        var currentTeamReference : FIRDatabaseReference!
        currentTeamReference = DataService.ds.REF_TEAMS.child(teamKey).child("players").child(DataService.ds.REF_USER_CURRENT.key)
        currentTeamReference.setValue(true)
        
        performSegue(withIdentifier: "signUpToTabVC", sender: nil)
    }
    
    @IBAction func sliderValueChange(_ sender: Any) {
        let currentValue = Int(numberSlider.value)
        jerseyLabel.text = "\(currentValue)"
        playerNumber = "\(currentValue)"
    }
    
    //MARK: Helper Functions
    
    func facebookGraphRequest() {
        
        //Set up Graph Request
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "id, name, email, cover, picture"]).start {
            (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request: \(err)")
                
            }
            
            print("Result \(result)")
            
            if let dict = result as? Dictionary<String, AnyObject> {
                
                
                // Handle ID to get facebook picture
                if let id = dict["id"] as? String {
                    print("ID \(id)")
                    let facebookProfileUrl = "http://graph.facebook.com/\(id)/picture?type=large"
                    self.profileImageURL = facebookProfileUrl
                }
                
                // Handle name
                
                if let playerName = dict["name"] as? String {
                    print(playerName)
                    self.playerName = playerName
                }
            }
        }
    }

}
