//
//  Player.swift
//  Filhoops
//
//  Created by Ron Ramirez on 12/3/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import Foundation
import Firebase

class Player {
    private var _playerName : String!
    private var _imageURL : String!
    private var _playerKey : String!
    private var _playerRef : FIRDatabaseReference!
    
    
    var playerName : String {
        return _playerName
    }
    
    var imageURL : String {
        return _imageURL
    }
    
    init(playerName : String, imageUrl : String) {
        self._playerName = playerName
        self._imageURL = imageUrl
    }
    
    init(playerKey : String, playerData : Dictionary<String, AnyObject>) {
        self._playerKey = playerKey
        
        if let name = playerData["name"] as? String {
            self._playerName = name
        }
        
        if let imageUrl = playerData["url"] as? String {
            self._imageURL = imageUrl
        }
        
        _playerRef = DataService.ds.REF_USERS.child(playerKey)
    
    }


}
