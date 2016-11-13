//
//  ViewController.swift
//  Filhoops
//
//  Created by Ron Ramirez on 11/13/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {


    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        facebookButton.delegate = self
        facebookButton.readPermissions = ["email" , "public_profile"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Facebook Delegate Functions
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Successfuly Logged out")
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        print("Successfully Logged in")
        
        self.showFacebookEmail()
        
        
        
    }
    
    
    func showFacebookEmail() {
        
        //Set up Firebase user for Facebook user
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
//        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
//        
//        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
//            if error != nil {
//                print("Something went wrong with our FB user: ", error ?? "")
//                return
//            }
//            
//            print("Successfully logged in with our user: ", user ?? "")
//        })
        
        //Set up Graph Request
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "id, name, email, cover, picture"]).start {
            (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request: \(err)")
                return
            }
            
            print(result)
            
        }
    }
}

