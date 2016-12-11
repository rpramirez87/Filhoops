//
//  Game.swift
//  Filhoops
//
//  Created by Ron Ramirez on 12/11/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import Foundation
import Firebase

class Game {
    
    private var _gameTitle : String!
    private var _gameDate : String!
    private var _gameKey : String!
    private var _gameRef : FIRDatabaseReference!
    
    
    var gameTitle : String {
        return _gameTitle
    }
    
    var gameDate : String {
        return _gameDate
    }
    
    init(gameTitle : String, gameDate : String) {
        self._gameTitle = gameTitle
        self._gameDate = gameDate
    }

    
    
    init(gameKey : String, gameData : Dictionary<String, AnyObject>) {
        self._gameKey = gameKey
        
        if let name = gameData["name"] as? String {
            self._gameTitle = name
        }
        
        if let date = gameData["date"] as? String {
            self._gameDate = date
        }
        
        _gameRef = DataService.ds.REF_GAMES.child(gameKey)
        
    }

    
}
