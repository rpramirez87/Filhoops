//
//  SignUpVC.swift
//  Filhoops
//
//  Created by Ron Ramirez on 12/3/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var teamPickerView: UIPickerView!
    
    
    var teams = [String]()
    var teamKeys = [String]()
    var teamName : String?
    var teamKey : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamPickerView.delegate = self
        teamPickerView.dataSource = self
        
        DataService.ds.REF_TEAMS.observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                //Clear all posts
                self.teams = [""]
                self.teamKeys = [""]
                
                for snap in snapshots {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        if let teamName = postDict["name"] as? String {
                            self.teams.append(teamName)
                            self.teamKeys.append(snap.key)
                        }
                    }
                }
                self.teamPickerView.reloadAllComponents()
            }
            
        })

        
        // Do any additional setup after loading the view.
    }
    
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
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        guard let teamName = self.teamName, let teamKey = self.teamKey else {
            print("WARNING: Please Select A Team")
            return
        }
        
        // Add team to user
        
        var teamReference : FIRDatabaseReference!
        teamReference = DataService.ds.REF_USER_CURRENT
        let userData = ["team" : teamName]
        teamReference.updateChildValues(userData)
        
        // Add user to team
        
        
       
    
        performSegue(withIdentifier: "signUpToTabVC", sender: nil)
    }

}
