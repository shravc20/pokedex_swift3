//
//  Pokemon.swift
//  Pokedex
//
//  Created by Shravan Chopra on 24/04/17.
//  Copyright © 2017 Shravan Chopra. All rights reserved.
//

import Foundation

class Pokemon {

    private var _name: String!
    private var _pokedexID: Int!
    
    // creating getters
    var name: String {
        return _name
    }
    
    var pokedexID: Int {
        return _pokedexID
    }
    
    init (name: String, pokedexID: Int) {
        self._name = name
        self._pokedexID = pokedexID
    }
}
