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
    var currentDate = Date()
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gamesTableVC: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamesTableVC.delegate = self
        gamesTableVC.dataSource = self

       updateGames()
        
        // Current Date
        self.dateLabel.text = currentDate.longDateFormatter()
        print(currentDate.longDateFormatter())
        self.dayLabel.text = currentDate.weekdayDateFormatter()
        
    }
    
    //MARK : IBACTIONS

    
    @IBAction func addGameButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showAUTHAddGameVC", sender: nil)
  
    }

    
    @IBAction func nextDayButtonPressed(_ sender: Any) {
        processDay(step: 1)
        updateGames()
    }
    
    @IBAction func previousDayButtonPressed(_ sender: Any) {
        processDay(step: -1)
        updateGames()
        
    }
    //MARK : STORYBOARD SEGUE ACTIONS
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showAUTHAddGameVC" {
            let AddGameVC = segue.destination as! AUTHAddGameVC
            AddGameVC.view.backgroundColor = UIColor.clear
            AddGameVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            AddGameVC.dateToAddGame = currentDate
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
    
    //MARK: Helper Functions
    
    func processDay(step : Int) {
        let direction = (step < 1 ? "Back" : "Next")
        print("\(direction) Button Pressed")
        currentDate = (Calendar.current as NSCalendar).date(byAdding: .day, value: step, to: currentDate, options: [])!
        self.dateLabel.text = currentDate.longDateFormatter()
        self.dayLabel.text = currentDate.weekdayDateFormatter()

    }
    
    func updateGames() {
        let dateString = currentDate.shortDateFormatter()
        print(dateString)
        
        DataService.ds.REF_GAMES.queryOrdered(byChild: "date").queryEqual(toValue: dateString).observe(.value, with :  { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                guard snapshot.exists() else {
                    print("No Data Here - Clear Table")
                    self.games = []
                    self.gamesTableVC.reloadData()
                    return
                }
                
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
    }
}
