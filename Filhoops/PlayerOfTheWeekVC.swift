//
//  PlayerOfTheWeekVC.swift
//  Filhoops
//
//  Created by Ron Ramirez on 12/11/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class PlayerOfTheWeekVC: UIViewController {
    var returningUser = false
    @IBOutlet weak var bgImageView: UIImageView!
    override func viewDidLoad() {
        //Shade Background
        self.bgImageView.alpha = 0.6
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        print("Hello from viewDidAppear")
        super.viewDidAppear(animated)
        sleep(3)
        
        // Check if there's a user in the keychain
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            doesCurrentUserHaveTeam()
        }else {
            self.performSegue(withIdentifier: "goToLoginVC", sender: nil)
        }
        
      
    }
    
    func doesCurrentUserHaveTeam() {
        print("Does user have current team?")
        DataService.ds.REF_USER_CURRENT.child("team").observeSingleEvent(of: .value , with: { snapshot in
            
            // Current User does not have a team
            guard let team = snapshot.value as? String else {
                self.returningUser = false
                self.performSegue(withIdentifier: "goToSignUpVC", sender: nil)
                print("Team doesn't exist")
                return
            }
            
            // Current User does have a team
            print("Team \(snapshot.value) exists")
            print("Current user is on \(team)")
            self.performSegue(withIdentifier: "loadingScreenToMainVC", sender: nil)
        })
    }


}
