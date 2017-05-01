//
//  Pokemon.swift
//  Pokedex
//
//  Created by Shravan Chopra on 24/04/17.
//  Copyright © 2017 Shravan Chopra. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {

    private var _name: String!
    private var _pokedexID: Int!
    
    // adding new properties
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolution: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    
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
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(pokedexID)/"
    }
    
    var nextEvolution: String {
        if _nextEvolution == nil {
            _nextEvolution = ""
        }
        
        return _nextEvolution
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }

        return _attack
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        
        return _defense
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        
        return _weight
    }

    var height: String {
        if _height == nil {
            _height = ""
        }
        
        return _height
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        
        return _type
    }

    var description: String {
        if _description == nil {
            _description = ""
        }
        
        return _description
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        
        return _nextEvolutionName
    }

    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        
        return _nextEvolutionId
    }
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        
        return _nextEvolutionLevel
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        
        Alamofire.request(self._pokemonURL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
            
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                // the comma is used to add an extra condition (like a 'where' clause)
                if let types = dict["types"] as? [Dictionary<String, String>], types.count > 0 {
                    
                    // store at least one type
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    
                    // list all the different types separated by a '/'
                    if types.count > 1 {
                        for x in 1..<types.count {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }

                    print("Testing types")
                    print(self._type)
                    
                } else {
                    self._type = ""
                }
                
                if let descArray = dict["descriptions"] as? [Dictionary<String, String>], descArray.count > 0 {
                    
                    if let url = descArray[0]["resource_uri"] {
                        
                        // making a second API call
                        let descriptionURL = "\(URL_BASE)\(url)"
                        
                        Alamofire.request(descriptionURL).responseJSON { (response) in

                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                
                                if let description = descDict["description"] as? String {
                                    
                                    // cleaning it up a little
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = newDescription
                                }
                            }
                        
                            completed()
                        }
                    }
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolutions.count > 0 {
                    
                    if let nextEvolution = evolutions[0]["to"] as? String {
                        
                        // we're going to exclude some possibilities and drop some data
                        if nextEvolution.range(of: "mega") == nil {
                            self._nextEvolutionName = nextEvolution
                            
                            // next ID is already stored inside the uri
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                let newString = uri.replacingOccurrences(of: "api/v1/pokemon", with: "")
                                let nextEvoId = newString.replacingOccurrences(of: "/", with: "")
                            
                                self._nextEvolutionId = nextEvoId
                                
                                
                                // not all pokemon level up
                                if let levelExist = evolutions[0]["level"] as? Int{
                                    self._nextEvolutionLevel = "\(levelExist)"
                                    
                                } else {
                                    self._nextEvolutionLevel = ""
                                }
                            }
                        }
                    }
                }
             }
            
            print("Checking response data: ")
            print(self._weight)
            print(self._height)
            print(self._attack)
            print(self._defense)
            print(self._nextEvolutionName)
            print(self._nextEvolutionLevel)
            print(self._nextEvolutionId)
    
            completed()     // This is the key!! Place it just before the end of the Alamofire request
        }

    }
}
