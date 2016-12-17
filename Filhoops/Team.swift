//
//  Team.swift
//  Filhoops
//
//  Created by Ron Ramirez on 12/3/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import Foundation
import Firebase

class Team {
    private var _teamName : String!
    private var _teamKey : String!

    var teamName : String {
        return _teamName
    }
    
    var teamKey : String {
        return _teamKey
    }
    
    init(teamKey : String, teamData : Dictionary<String, AnyObject>) {
        self._teamKey = teamKey
        
        if let name = teamData["name"] as? String {
            self._teamName = name
        }
    }
}
