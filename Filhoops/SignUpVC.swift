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
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageView: CircleImageView!
    @IBOutlet weak var teamTextField: UITextField! {
        didSet {
            teamTextField.attributedPlaceholder = NSAttributedString(string: "Team",
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.white])
            
            let arrow = UIImageView(image: UIImage(named: "down"))
            
            if let size = arrow.image?.size {
                arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 20.0, height: size.height)
            }
            arrow.contentMode = .scaleAspectFit
            
            //Single Tap Gesture Recognizer
            let teamGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.selectTeam))
            arrow.isUserInteractionEnabled = true
            teamGestureRecognizer.numberOfTapsRequired = 1
            arrow.addGestureRecognizer(teamGestureRecognizer)
            teamTextField.rightView = arrow
            teamTextField.rightViewMode = .always
            
            
        }
    }
    @IBOutlet weak var numberTextField: UITextField! {
        didSet {
            numberTextField.attributedPlaceholder = NSAttributedString(string: "Number",
                                                                       attributes: [NSForegroundColorAttributeName: UIColor.white])
            
            let arrow2 = UIImageView(image: UIImage(named: "down"))
            
            if let size = arrow2.image?.size {
                arrow2.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 20.0, height: size.height)
            }
            arrow2.contentMode = .scaleAspectFit
            
            //Single Tap Gesture Recognizer
            let numberGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.selectNumber))
            arrow2.isUserInteractionEnabled = true
            numberGestureRecognizer.numberOfTapsRequired = 1
            
            arrow2.addGestureRecognizer(numberGestureRecognizer)
            
            numberTextField.rightView = arrow2
            numberTextField.rightViewMode = .always
            
        }
    }

    var teams = [String]()
    var teamKeys = [String]()
    var numbers = [String]()
    var teamName : String?
    var teamKey : String?
    var playerName : String?
    var profileImageURL : String?
    var playerNumber : String?
    let teamPicker = UIPickerView()
    let numberPicker =  UIPickerView()
    
    //MARK: View Controller Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        //teamPickerView.delegate = self
        //teamPickerView.dataSource = self
        
        facebookGraphRequest()
        loadTeamsFromFirebase()
        
        for number in 1...99 {
            numbers.append(String(number))
        }
    }
    
    //MARK: Picker View Delegate Functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == teamPicker {
            return teams.count
        }else {
            return numbers.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if pickerView == teamPicker {
            return teams[row]
        }else {
            return numbers[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == teamPicker {
            teamName = teams[row]
            teamKey = teamKeys[row]
        }else {
            playerNumber = numbers[row]
        }
    }
    
    //MARK: IBActions
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        guard let teamName = self.teamName, let teamKey = self.teamKey else {
            print("WARNING: Please Select A Team")
            return
        }
        
        guard let playerImageURL = self.profileImageURL,  let playerName = self.playerName else {
            print("WARNING: Facebook Error getting User's Profile Picture and Name")
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
    
    //MARK: Helper Functions
    
    func facebookGraphRequest() {
        
        //Set up Graph Request
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "id, name"]).start {
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
                    
                    //Set up image
                    let imageURL = URL(string: facebookProfileUrl)
                    var image: UIImage?
                    if let url = imageURL {
                        //All network operations has to run on different thread(not on main thread).
                        DispatchQueue.global(qos: .userInitiated).async {
                            let imageData = NSData(contentsOf: url)
                            //All UI operations has to run on main thread.
                            DispatchQueue.main.async {
                                if imageData != nil {
                                    image = UIImage(data: imageData as! Data)
                                    self.imageView.image = image
                                } else {
                                    image = nil
                                }
                            }
                        }
                    }

                    self.profileImageURL = facebookProfileUrl
                }
                
                // Handle name
                if let playerName = dict["name"] as? String {
                    print(playerName)
                    self.playerName = playerName
                    self.nameTextField.text = playerName
                }
            }
        }
    }
    
    
    func loadTeamsFromFirebase() {
        DataService.ds.REF_TEAMS.observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                //Clear all posts
                self.teams = [""]
                self.teamKeys = [""]
                
                for snap in snapshots {
                    print("SignupVC - TEAM: \(snap)")
                    if let teamDict = snap.value as? Dictionary<String, AnyObject> {
                        if let teamName = teamDict["name"] as? String {
                            self.teams.append(teamName)
                            self.teamKeys.append(snap.key)
                        }
                    }
                }
                self.teamPicker.reloadAllComponents()
            }
        })
    }
    
    func selectTeam() {
        print("Single Tap")
        print("Select Team")
        let message = "\n\n\n\n\n\n\n\n"
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.isModalInPopover = true
        
        let attributedString = NSAttributedString(string: "Select a Team", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 20), //your font here,
            NSForegroundColorAttributeName : UIColor(red:0.29, green:0.45, blue:0.74, alpha:1.0) ])
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        //Create a frame (placeholder/wrapper) for the picker and then create the picker
        // CGRectMake(left, top, width, height) - left and top are like margins
        let pickerFrame = CGRect(x: 35, y: 52, width: 200, height: 140)
        teamPicker.frame = pickerFrame
        teamPicker.backgroundColor = UIColor.clear
        
        //set the pickers datasource and delegate
        teamPicker.delegate = self
        teamPicker.dataSource = self
        
        //Add the picker to the alert controller
        alert.view.addSubview(teamPicker)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "Start", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in self.setTeamSelected()
        })
        alert.addAction(okAction)
        
        self.present(alert, animated: false, completion: nil)
        
    }
    
    func selectNumber() {
        let message = "\n\n\n\n\n\n\n\n"
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.isModalInPopover = true
        
        let attributedString = NSAttributedString(string: "Select Jersey Number", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 20), //your font here,
            NSForegroundColorAttributeName : UIColor(red:0.29, green:0.45, blue:0.74, alpha:1.0) ])
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        //Create a frame (placeholder/wrapper) for the picker and then create the picker
        // CGRectMake(left, top, width, height) - left and top are like margins
        let pickerFrame = CGRect(x: 35, y: 52, width: 200, height: 140)
        numberPicker.frame = pickerFrame
        numberPicker.backgroundColor = UIColor.clear
        
        //set the pickers datasource and delegate
        numberPicker.delegate = self
        numberPicker.dataSource = self
        
        //Add the picker to the alert controller
        alert.view.addSubview(numberPicker)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "Start", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in self.setNumberSelected()
        })
        alert.addAction(okAction)
        
        self.present(alert, animated: false, completion: nil)
        
    }
    
    func setTeamSelected() {
        if let team = teamName {
            teamTextField.text = team
        }
    }
    
    func setNumberSelected() {
        if let number = playerNumber {
            numberTextField.text = number
        }
        
    }
    
}
