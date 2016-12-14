//
//  AddTeamVC.swift
//  Filhoops
//
//  Created by Ron Ramirez on 12/11/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit
import Firebase

class AddTeamVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var teamTableVC: UITableView!
    @IBOutlet weak var teamTextField: UITextField!
    var teams = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AddTeamVC")
        
        teamTableVC.delegate = self
        teamTableVC.dataSource = self
        
        DataService.ds.REF_TEAMS.observe(.value, with: { (snapshot) in
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
                self.teamTableVC.reloadData()
            }
            
        })

    }
    
  
    
    @IBAction func addTeamButtonPressed(_ sender: Any) {
        guard let teamName = teamTextField.text, teamName != "" else {
            print("Must enter a valid Team name")
            return
        }
        
        let firebaseTeamPost = DataService.ds.REF_TEAMS.childByAutoId()
        let teamPost : Dictionary<String, AnyObject> = [
            "name" : teamName as AnyObject
        
        ]
        firebaseTeamPost.setValue(teamPost)
    
        
    }
    
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
}
