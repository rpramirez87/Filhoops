//
//  AddTeamVC.swift
//  Filhoops
//
//  Created by Ron Ramirez on 12/11/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//
//
import UIKit
import Firebase

class AUTHAddTeamVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var teamTableVC: UITableView!
    @IBOutlet weak var teamTextField: UITextField!
    private var teams = [String]()
    
    //MARK: ViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up Tableview
        teamTableVC.delegate = self
        teamTableVC.dataSource = self
        
        loadTeamsFromFirebase()
    }
    
    //MARK: IBActions
    @IBAction func addTeamButtonPressed(_ sender: Any) {
        
        //Check for null
        guard let teamName = teamTextField.text, teamName != "" else {
            print("Must enter a valid Team name")
            return
        }
        
        //Check for duplicates
        if teams.contains(teamName) {
            print("\(teamName) is already a team")
            return
        }
        
        let firebaseTeamPost = DataService.ds.REF_TEAMS.childByAutoId()
        let teamPost : Dictionary<String, AnyObject> = [
            "name" : teamName as AnyObject
            
        ]
        firebaseTeamPost.setValue(teamPost)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: TableView Delegate Functions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let team = teams[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for : indexPath)
        cell.textLabel?.text = team
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    //MARK: Helper Functions
    
    private func loadTeamsFromFirebase() {
        
        //Reloads table view everytime a team is added
        DataService.ds.REF_TEAMS.observe(.value, with: { (snapshot) in
            //Check Values
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                //Clear all teams
                self.teams = [""]
                for snap in snapshots {
                    print("AddTeamVC - TEAM: \(snap)")
                    if let teamDict = snap.value as? Dictionary<String, AnyObject> {
                        if let teamName = teamDict["name"] as? String {
                            self.teams.append(teamName)
                        }
                    }
                }
                self.teamTableVC.reloadData()
            }
        })
    }
}
