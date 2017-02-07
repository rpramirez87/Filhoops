//
//  AUTHAddGameVC.swift
//  Filhoops
//
//  Created by Ron Ramirez on 12/13/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit
import Firebase

class AUTHAddGameVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    
    @IBOutlet weak var teamTableView: UITableView!
    @IBOutlet weak var team1Label: UILabel!
    @IBOutlet weak var team2Label: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var gymSegmentControl: UISegmentedControl!
    @IBOutlet weak var timePickerView: UIPickerView!
    
    var currentTeams = [Team]()
    var currentFilteredTeams = [Team]()
    var team1 : Team?, team2 : Team?
    var teamSelected : Team?
    var teamKeySelected = ""
    var timeSelected = ""
    var inSearchMode = false
    var dateToAddGame : Date?
    var gym = "Gym 1"
    var availableTimes = ["7:30 PM","8:30 PM", "9:30 PM", "10:30 PM", "11:30 PM"]

    //MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timePickerView.delegate = self
        timePickerView.dataSource = self
        
        teamTableView.delegate = self
        teamTableView.dataSource = self
        
        searchBar.delegate = self
        searchBar.returnKeyType = .done
    
        loadTeamsFromFirebase()
    }

    // MARK: IBActions
    
    @IBAction func team1ButtonPressed(_ sender: Any) {
        guard let team = teamSelected else {
            print("WARNING SELECT A TEAM")
            return
        }
        team1 = team
        
        guard team2Label.text != team.teamName else {
            print("TEAM IS ALREADY SELECTED")
            return
        }
        
        team1Label.text = team.teamName
    }

    @IBAction func team2ButtonPressed(_ sender: Any) {
        guard let team = teamSelected else {
            print("WARNING SELECT A TEAM")
            return
        }
        
        guard team1Label.text != team.teamName else {
            print("TEAM IS ALREADY SELECTED")
            return
        }
        
        team2Label.text = team.teamName
        team2 = team

        
    }
    
    @IBAction func addGameButtonPressed(_ sender: Any) {
    
        
        guard let firstTeam = team1, let secondTeam = team2 else {
            print("Select Teams")
            return
        }
        
        guard timeSelected != "" else {
            print("Select a time")
            return
        }
        
        guard let gameDate = dateToAddGame else {
            print("Current Date is empty!")
            return
        }
        
        
        let gameName = "\(firstTeam.teamName) Vs \(secondTeam.teamName)"

        // Add game to games
        let firebaseGamePost = DataService.ds.REF_GAMES.childByAutoId()
        let teamPost : Dictionary<String, AnyObject> = [
            "name" : gameName as AnyObject,
            "date" : gameDate.shortDateFormatter() as AnyObject,
            "time" : timeSelected as AnyObject,
            "team1" : firstTeam.teamName as AnyObject,
            "team2" : secondTeam.teamName as AnyObject,
            "team1Key" : firstTeam.teamKey as AnyObject,
            "team2Key" : secondTeam.teamKey as AnyObject,
            "gym" : gym as AnyObject
            
        ]
        
        firebaseGamePost.setValue(teamPost)
        addGameToPlayersBasedOn(gameKey: firebaseGamePost.key, forTeam: firstTeam.teamKey, andTeam: secondTeam.teamKey)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func gymValueChanged(_ sender: Any) {
        if gymSegmentControl.selectedSegmentIndex == 0 {
            gym = "Gym 1"
        }else {
            gym = "Gym 2"
        }
    }
    
    //MARK: Picker View Delegate Functions
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return availableTimes.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return availableTimes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timeSelected = availableTimes[row]
    }
    
    //MARK: Table View Delegate Functions
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var team : String!
        
        var team : Team!
        
        if inSearchMode{
            team = currentFilteredTeams[indexPath.row]
        }else{
            team = currentTeams[indexPath.row]
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for : indexPath)
        cell.textLabel?.text = team.teamName
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode {
            return currentFilteredTeams.count
        }else {
            return currentTeams.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Exit Search bar
        searchBar.resignFirstResponder()
        
        if inSearchMode {
            teamSelected = currentFilteredTeams[indexPath.row]
 
        }else {
            teamSelected = currentTeams[indexPath.row]
        }
        
    }
    
    //MARK: Search Bar Delegate Functions
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            teamTableView.reloadData()
            
            
        }else {
            inSearchMode = true
            let lower = searchBar.text!.lowercased()
            currentFilteredTeams = currentTeams.filter({$0.teamName.lowercased().range(of :lower) != nil})
            teamTableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //Hide the keyboard
        view.endEditing(true)
    }
    
    // MARK: Firebase Functions
    
    func addGameToPlayersBasedOn(gameKey : String, forTeam team1Key : String, andTeam team2Key : String) {
        print(gameKey)
        print(team1Key)
        print(team2Key)
        
        DataService.ds.REF_USERS.observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    print("PLAYERS: \(snap)")
                    if let userDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        if let playerTeamKey = userDict["teamKey"] as? String {
                            if playerTeamKey == team1Key || playerTeamKey == team2Key {
                                
                                //Add Games to players Reference
                                let playerGamePost = DataService.ds.REF_USERS.child(snap.key).child("games").child(gameKey)
                                let gamePost : Dictionary<String, AnyObject> = [
                                    "playerPoints" : 0 as AnyObject
                                ]
                                playerGamePost.setValue(gamePost)
                            }
                        }
                    }
                }
            }
        })
    }
    
    private func loadTeamsFromFirebase() {
        DataService.ds.REF_TEAMS.observeSingleEvent(of: .value, with: { (snapshot) in
            //Check Values
            print("Data Service")
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                //Clear all posts
                self.currentTeams = []
                
                for snap in snapshots {
                    print("SNAP: \(snap)")
                    if let teamDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let team = Team(teamKey : key, teamData : teamDict)
                        self.currentTeams.append(team)
                    }
                }
                self.teamTableView.reloadData()
            }
        })
    }
}
