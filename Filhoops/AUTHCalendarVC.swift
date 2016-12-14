//
//  AUTHCalendarVC.swift
//  Filhoops
//
//  Created by Ron Ramirez on 12/13/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit
import Firebase

class AUTHCalendarVC: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    var games = [String]()
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gamesTableVC: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamesTableVC.delegate = self
        gamesTableVC.dataSource = self

        //Load team games from database
        DataService.ds.REF_GAMES.observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                self.games = []
                
                for snap in snapshots {
                    print("SNAP: \(snap)")
                    if let teamDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        
                        if let gameTitle = teamDict["name"] as? String {
                            self.games.append(gameTitle)
                            
                        }
                    }
                }
                self.gamesTableVC.reloadData()
                
            }
        })
        
        // Current Date
        let currentDate = Date()
        self.dateLabel.text = currentDate.longDateFormatter()
        print(currentDate.longDateFormatter())
        self.dayLabel.text = currentDate.weekdayDateFormatter()
        
    }

    
    @IBAction func addGameButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showAUTHAddGameVC", sender: nil)
  
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showAUTHAddGameVC" {
            let AddGameVC = segue.destination as! AUTHAddGameVC
            AddGameVC.view.backgroundColor = UIColor.clear
            AddGameVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        }
    }
    
    //MARK: Table View Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = games[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for : indexPath)
        cell.textLabel?.text = game
        return cell
    }

}
