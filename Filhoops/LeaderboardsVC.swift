//
//  LeaderboardsVC.swift
//  Filhoops
//
//  Created by Ron Ramirez on 1/10/17.
//  Copyright © 2017 Mochi Apps. All rights reserved.
//

import UIKit
import Firebase


class LeaderboardsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var playersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playersTableView.delegate = self
        playersTableView.dataSource = self
    }
    
    //MARK : UITableView Delegate Functions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playersTableView.dequeueReusableCell(withIdentifier: "LeaderboardPlayerCell", for: indexPath) as? LeaderboardPlayerCell
        cell?.playerNameLabel.text = "Patrick Ramirez"
        cell?.numberLabel.text = "\(indexPath.row + 1)."

        
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    // MARK : Helper Functions
    func numberLabelColorBasedOn(position : Int) -> UIColor {
        
        switch(position) {
        case 0:
            return UIColor.yellow
        case 1:
            return UIColor.gray
        case 2:
            return UIColor.brown
            
        default:
            return UIColor.clear
        }
    }
}
