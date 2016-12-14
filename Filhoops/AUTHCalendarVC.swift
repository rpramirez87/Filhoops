//
//  AUTHCalendarVC.swift
//  Filhoops
//
//  Created by Ron Ramirez on 12/13/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit

class AUTHCalendarVC: UIViewController {
    
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gamesTableVC: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}
