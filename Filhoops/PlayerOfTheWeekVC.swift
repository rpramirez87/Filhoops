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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        print("Hello from viewDidAppear")
        super.viewDidAppear(animated)
        sleep(3)
        
        // Check if there's a user in the keychain
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "loadingScreenToMainVC", sender: nil)
        }else {
            performSegue(withIdentifier: "goToLoginVC", sender: nil)
        }
        
      
    }


}
