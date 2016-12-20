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
    private var _playerNumber : String!
    private var _imageURL : String!
    private var _playerKey : String!
    private var _gameKey : String!
    private var _points : Int!
    private var _playerRef : FIRDatabaseReference!
    private var _currentGameRef : FIRDatabaseReference!
    
    var playerName : String {
        return _playerName
    }
    
    var imageURL : String {
        return _imageURL
    }
    
    var playerNumber : String {
        return _playerNumber
    }
    
    var gameKey : String {
        return _gameKey
    }
    
    var currentGame : FIRDatabaseReference {
        return _currentGameRef
    }
    
    var points : Int {
        return _points
    }
    
    var playerKey : String {
        return _playerKey
    }

    
    init(playerName : String, imageUrl : String, playerNumber : String, points : Int) {
        self._playerName = playerName
        self._imageURL = imageUrl
        self._playerNumber = playerNumber
        self._points = points
    }
    
    init(playerKey : String, playerData : Dictionary<String, AnyObject>) {
        self._playerKey = playerKey
        
        if let name = playerData["name"] as? String {
            self._playerName = name
        }
        
        if let imageUrl = playerData["url"] as? String {
            self._imageURL = imageUrl
        }    
    }
    
    
    init(playerKey : String, gameKey : String, playerData : Dictionary<String, AnyObject>) {
        self._playerKey = playerKey
        self._gameKey = gameKey
        
        if let name = playerData["name"] as? String {
            self._playerName = name
        }
        
        if let number = playerData["number"] as? String {
            self._playerNumber = number
        }
        
  
        _playerRef = DataService.ds.REF_USERS.child(playerKey)
        _currentGameRef = _playerRef.child("games").child(_gameKey)
        
        _playerRef.child("games").observe(.value, with: { (snapshot) in
            
            guard snapshot.exists() else {
                print("No Data Here")
                return
            }
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                print(snapshot.children.allObjects.count)
                for snap in snapshots {
                    
                    print("SNAP: \(snap)")
                    print(snap.key)
                    if snap.key == gameKey {
                        print("GAME MATCH")
                        if let currentGameDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            // Save unique key value for Team
                            
                            if let points = currentGameDict["playerPoints"] as? Int {
                                print("POINTS : \(points)")
                                self._points = points
                                
                            }
                        }

                    }
                    
                    
                }
            }
            
        })
    }
    
    func adjustPoints(addPoint : Bool) {
        if addPoint {
            _points = _points + 1
        }else {
            _points = _points - 1
        }
        _currentGameRef.child("playerPoints").setValue(_points)
    }



}
