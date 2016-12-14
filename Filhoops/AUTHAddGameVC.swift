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
    
    @IBOutlet weak var team1Label: UILabel!
    @IBOutlet weak var team2Label: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var teams = [String]()
    var filteredTeams = [String]()
    var teamSelected = ""
    var inSearchMode = false
    
    @IBOutlet weak var timePickerView: UIPickerView!
    var availableTimes = ["7:30 PM","8:30 PM", "9:30 PM", "10:30 PM", "11:30 PM"]


  
    @IBOutlet weak var teamTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timePickerView.delegate = self
        timePickerView.dataSource = self
        
        teamTableView.delegate = self
        teamTableView.dataSource = self
        
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        
        
        // Load up Firebase data for teams
        DataService.ds.REF_TEAMS.observeSingleEvent(of: .value, with: { (snapshot) in
            //Check Values
            print("Data Service")
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                //Clear all posts
                self.teams = [""]
                
                for snap in snapshots {
                    print("SNAP: \(snap)")
                    if let teamDict = snap.value as? Dictionary<String, AnyObject> {
                        if let teamName = teamDict["name"] as? String {
                            self.teams.append(teamName)
                        }
                    }
                }
                self.teamTableView.reloadData()
            }
            
        })


        // Do any additional setup after loading the view.
    }

    // MARK : IBActions
    
    @IBAction func team1ButtonPressed(_ sender: Any) {
        guard teamSelected != "" else {
            print("WARNING SELECT A TEAM")
            return
        }
        
        guard team2Label.text != teamSelected else {
            print("TEAM IS ALREADY SELECTED")
            return
        }
        
        team1Label.text = teamSelected
    }

    @IBAction func team2ButtonPressed(_ sender: Any) {
        guard teamSelected != "" else {
            print("WARNING SELECT A TEAM")
            return
        }
        
        guard team1Label.text != teamSelected else {
            print("TEAM IS ALREADY SELECTED")
            return
        }
        
        team2Label.text = teamSelected

        
    }
    
    @IBAction func addGameButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
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
    
    //MARK: Table View Delegate Functions
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var team : String!
        if inSearchMode{
            team = filteredTeams[indexPath.row]
        }else{
            team = teams[indexPath.row]
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for : indexPath)
        cell.textLabel?.text = team
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredTeams.count
        }else {
            return teams.count
        }
     
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Exit Search bar
        searchBar.resignFirstResponder()
        
        
        if inSearchMode {
            teamSelected = filteredTeams[indexPath.row]
        }else {
            teamSelected = teams[indexPath.row]

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
            filteredTeams = teams.filter({$0.lowercased().range(of :lower) != nil})
            teamTableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Hide the keyboard
        view.endEditing(true)
    }
}
