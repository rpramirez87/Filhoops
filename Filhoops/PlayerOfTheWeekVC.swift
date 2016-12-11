//
//  PlayerOfTheWeekVC.swift
//  Filhoops
//
//  Created by Ron Ramirez on 12/11/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit

class PlayerOfTheWeekVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Hello from viewDidAppear")
        super.viewDidAppear(animated)
        sleep(3)
        performSegue(withIdentifier: "goToLoginVC", sender: nil)
    }


}
