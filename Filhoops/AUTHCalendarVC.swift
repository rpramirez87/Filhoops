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
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gamesTableVC: UITableView! {
        didSet {
            gamesTableVC.delegate = self
            gamesTableVC.dataSource = self
        }
    }
    
    var games = [Game]()
    var currentDate = Date()
    var gameSelected : Game?
    
    //MARK: Constants 
    
    private struct Storyboard {
        //UITableViewCell subclass
        static let GameCell = "AUTHGameCell"
        
        //Segues
        static let ShowAddGameVCSegue = "showAUTHAddGameVC"
        static let ShowGameVCSegue = "showGameVC"
    }
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Set up labels based on date
        self.dateLabel.text = currentDate.longDateFormatter()
        self.dayLabel.text = currentDate.weekdayDateFormatter()
        
        updateGamesBasedOnCurrentDate()
    }
    
    //MARK: IBACTIONS
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addGameButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: Storyboard.ShowAddGameVCSegue, sender: nil)
        
    }
    
    @IBAction func nextDayButtonPressed(_ sender: Any) {
        processDay(step: 1)
        updateGamesBasedOnCurrentDate()
    }
    
    @IBAction func previousDayButtonPressed(_ sender: Any) {
        processDay(step: -1)
        updateGamesBasedOnCurrentDate()
        
    }
    
    //MARK : STORYBOARD SEGUE ACTIONS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Storyboard.ShowAddGameVCSegue {
            let AddGameVC = segue.destination as! AUTHAddGameVC
            AddGameVC.view.backgroundColor = UIColor.clear
            AddGameVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            AddGameVC.dateToAddGame = currentDate
        }
        
        if segue.identifier == Storyboard.ShowGameVCSegue {
            let AUTHGameVC = segue.destination as! AUTHGameVC
            AUTHGameVC.currentGame = gameSelected
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
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.GameCell, for: indexPath) as? AUTHGameCell {
            cell.configureCell(game : game)
            return cell
        }else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gameSelected = games[indexPath.row]
        performSegue(withIdentifier: Storyboard.ShowGameVCSegue, sender: nil)
    }
    
    //MARK: Helper Functions
    
    func processDay(step : Int) {
        let direction = (step < 1 ? "Back" : "Next")
        print("\(direction) Button Pressed")
        currentDate = (Calendar.current as NSCalendar).date(byAdding: .day, value: step, to: currentDate, options: [])!
        self.dateLabel.text = currentDate.longDateFormatter()
        self.dayLabel.text = currentDate.weekdayDateFormatter()
        
    }
    
    func updateGamesBasedOnCurrentDate() {
        //Convert to string value Firebase can read
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
                    print("AUTHCalendarVC - GAME: \(snap)")
                    if let gameDict = snap.value as? Dictionary<String, AnyObject> {
                        // Save unique key value for Team
                        let key = snap.key
                        let game = Game(gameKey: key, gameData: gameDict)
                        self.games.append(game)
                    }
                }
                self.gamesTableVC.reloadData()
            }
        })
    }
}
