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
    
    //Attributes
    private var _gameTitle : String!
    private var _gameDate : String!
    private var _gameTime : String!
    private var _team1 : String!
    private var _team2 : String!
    private var _team1Key : String!
    private var _team2Key : String!
    private var _gym : String!
    private var _team1Score : String!
    private var _team2Score : String!
    
    //Firebase
    private var _gameKey : String!
    private var _gameRef : FIRDatabaseReference!
    
    
    var gameTitle : String {
        return _gameTitle
    }
    
    var gameDate : String {
        return _gameDate
    }
    
    var gameTime : String {
        return _gameTime
    }
    
    var team1 : String {
        return _team1
    }
    
    var team2 : String {
        return _team2
    }
    
    var team1Key : String {
        return _team1Key
    }
    
    var team2Key : String {
        return _team2Key
    }
    
    var gym : String {
        return _gym
    }
    
    var team1Score : String {
        if _team1Score != nil {
            return _team1Score
        }else {
            return "0"
        }
    }
    
    var team2Score : String {
        if _team2Score != nil {
            return _team2Score
        }else {
            return "0"
        }
    }
    
    var gameKey : String {
        return _gameKey
    }
    
    // TeamVC Initializer
    init(gameTitle : String, gameDate : String, gameTime : String) {
        self._gameTitle = gameTitle
        self._gameDate = gameDate
        self._gameTime = gameTime
    }
    
    
    // AddGameVC/GameVC Initializer
    init(gameKey : String, gameData : Dictionary<String, AnyObject>) {
        self._gameKey = gameKey
        
        if let name = gameData["name"] as? String {
            self._gameTitle = name
        }
        
        if let date = gameData["date"] as? String {
            self._gameDate = date
        }
        
        if let time = gameData["time"] as? String {
            self._gameTime = time
        }
        
        if let team1 = gameData["team1"] as? String {
            self._team1 = team1
        }
        
        if let team2 = gameData["team2"] as? String {
            self._team2 = team2
        }
        
        if let gym = gameData["gym"] as? String {
            self._gym = gym
        }
        
        if let firstTeamKey = gameData["team1Key"] as? String {
            self._team1Key = firstTeamKey
        }
        
        if let secondTeamKey = gameData["team2Key"] as? String {
            self._team2Key = secondTeamKey
        }
        
        if let teamOneScore = gameData["team1Score"] as? String {
            self._team1Score = teamOneScore
        }
        
        if let teamTwoScore = gameData["team2Score"] as? String {
            self._team2Score = teamTwoScore
        }
        _gameRef = DataService.ds.REF_GAMES.child(gameKey)
        
    }
    
    
}
