//
//  DataService.swift
//  Filhoops
//
//  Created by Ron Ramirez on 11/28/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

//Access Firebase Database url that contains the database - GoogleService-Info.plist
let DB_BASE = FIRDatabase.database().reference()

//Access Firebse Storage
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService  {
    
    static let ds = DataService()
    
    //Database References
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_TEAMS = DB_BASE.child("teams")
    private var _REF_GAMES = DB_BASE.child("games")
    
    //Storage references
    private var _REF_PROFILE_IMAGES = STORAGE_BASE.child("profile-pics")
    
    
    var REF_BASE : FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS :FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_TEAMS :FIRDatabaseReference {
        return _REF_TEAMS
    }
    
    var REF_GAMES :FIRDatabaseReference {
        return _REF_GAMES
    }
    
    var REF_USER_CURRENT : FIRDatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    
    var REF_USER_CURRENT_TEAM : FIRDatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        let team = user.child("team")
        return team
    }
    
    var REF_USER_CURRENT_TEAM_KEY : FIRDatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        let teamKey = user.child("teamKey")
        return teamKey
    }
    
    
    var REF_PROFILE_IMAGES : FIRStorageReference {
        return _REF_PROFILE_IMAGES
    }
    
    func createFirebaseDBUser(uid : String, userData : Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
}
