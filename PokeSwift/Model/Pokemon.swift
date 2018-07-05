//
//  Pokemon.swift
//  PokeSwift
//
//  Created by Steven Lattenhauer 2nd on 7/4/18.
//  Copyright © 2018 Steven Lattenhauer 2nd. All rights reserved.
//

import Foundation

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _type: String!
    private var _height: String!
    private var _weight: String!
    private var _baseAttack: String!
    private var _baseDefense: String!
    private var _pokedexEntry: String!
    private var _evolution: String!
    
    var name : String {
        
        if _name == nil {
            _name = ""
        }
        return _name
    }
    
    var pokedexId: Int {
        
        if _pokedexId == nil {
            _pokedexId = 0
        }
        return _pokedexId
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var baseAttack: String {
        if _baseAttack == nil {
            _baseAttack = ""
        }
        return _baseAttack
    }
    
    var baseDefense: String {
        if _baseDefense == nil {
            _baseDefense = ""
        }
        return _baseDefense
    }
    
    var pokedexEntry: String {
        if _pokedexEntry == nil {
            _pokedexEntry = ""
        }
        return _pokedexEntry
    }
    
    var evolution: String {
        if _evolution == nil {
            _evolution = ""
        }
        return _evolution
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
    }
}
