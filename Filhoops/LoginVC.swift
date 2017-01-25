//
//  ViewController.swift
//  Filhoops
//
//  Created by Ron Ramirez on 11/13/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class LoginVC : UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    var returningUser = false

    //MARK: View Controller Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        //Shade Background
        self.bgImageView.alpha = 0.6
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Check if there's a user in the keychain
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            doesCurrentUserHaveTeam()
        }
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
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Something went wrong with our FB user: ", error ?? "")
                return
            }
            
            print("Successfully logged in with our user: ", user ?? "")
        })
        
        //Set up Graph Request
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "id, name, email, cover, picture"]).start {
            (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request: \(err)")
                return
            }
            
            print(result ?? "")
            
        }
    }

    @IBAction func facebookButtonTapped(_ sender: CustomButton) {
        print("Facebook Button Tapped")
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result,error) in
            
            if error != nil {
                print("ERROR : \(error)")
            }else if result?.isCancelled == true {
                print("User cancelled Facebook Authentication")
            }else {
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }

    
    //MARK: Helper Functions
    
    func firebaseAuth(_ credential : FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion : { (user, error) in
            
            if error != nil {
                print("ERROR: \(error)")
            } else {
                print("Successfully authenticated with Firebase")
                if let currentUser = user {
                    let currentUserData = ["provider" : credential.provider]
                    self.keychainSignIn(id : currentUser.uid, userData: currentUserData)
                }
                
            }
        })
    }
    
    func keychainSignIn(id : String, userData : Dictionary<String, String>) {
        //Create user in Firebase
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        //Save uid in Keychain for returning users
        let saveSuccessful: Bool = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Data saved to keychain \(saveSuccessful)")
        
        //Check if user have a team to go to the right path
        doesCurrentUserHaveTeam()
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
            self.performSegue(withIdentifier: "showTabBarVC", sender: nil)
        })
    }
}


