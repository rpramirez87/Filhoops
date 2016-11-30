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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        facebookButton.delegate = self
//        facebookButton.readPermissions = ["email" , "public_profile"]
        
        
        //Shade Background
        self.bgImageView.alpha = 0.6
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Check if there's a user in the keychain
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "showTabBarVC", sender: nil)
        }
        
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

    @IBAction func facebookButtonTapped(_ sender: Any) {
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
    @IBAction func signInButtonTapped(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                
                if error == nil {
                    print("Email user is authenticated")
                    if let currentUser = user {
                        let currentUserData = ["provider" : currentUser.providerID]
                        self.keychainSignIn(id : currentUser.uid, userData: currentUserData)
                        
                    }
                }else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        
                        if error != nil {
                            print("Unable to authenticate with Firebase using email")
                        } else {
                            print("Sucessfully authenticated with Firebase")
                            if let currentUser = user {
                                let currentUserData = ["provider" : currentUser.providerID]
                                self.keychainSignIn(id : currentUser.uid, userData: currentUserData)
                            }
                        }
                    })
                }
            })
            
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
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let saveSuccessful: Bool = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Data saved to keychain \(saveSuccessful)")
        performSegue(withIdentifier: "showTabBarVC", sender: nil)
    }

    


}

