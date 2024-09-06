//
//  Pokemon.swift
//  PokeSwift
//
//  Created by Steven Lattenhauer 2nd on 7/4/18.
//  Copyright © 2018 Steven Lattenhauer 2nd. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    var evolution: Evolution!
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _type: String!
    private var _height: String!
    private var _weight: String!
    private var _baseAttack: String!
    private var _baseDefense: String!
    private var _pokedexEntry: String!
    private var _pokemonURL: String!
    private var _evolutionURL: String!

    
    
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
    
    
    var pokemonURL: String {

        return _pokemonURL
    }
    
    var evolutionURL: String {
        return _evolutionURL
    }
    
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(pokedexId)/"
//        self.evolution = Evolution (name: name, pokedexId: pokedexId)
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete){
        AF.request(self.pokemonURL).responseJSON { (response) in
                        
            if let dict = response.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? Int {
                    
                    let weightDouble = Double(weight)/10
                    let goodUnit = UnitMass.kilograms
                    let goodWeight:Measurement = Measurement(value: weightDouble, unit: goodUnit)
                    let kgToLbs = goodWeight.converted(to: .pounds)
                    let convertedWeight = String(format: "%.2f", kgToLbs.value)
                    self._weight = "\(convertedWeight)\(" lb")"
                }
                
                if let height = dict["height"] as? Int {
                    
                    let heightDouble = Double(height)/10
                    let goodUnit = UnitLength.meters
                    let goodWeight:Measurement = Measurement(value: heightDouble, unit: goodUnit)
                    let metersToFeet = goodWeight.converted(to: UnitLength.feet)
                    let convertedHeight = String(format: "%.2f", metersToFeet.value)
                    self._height = "\(convertedHeight)\("'")"
                }
                
                if let statsDict = dict["stats"] as? [Dictionary <String, AnyObject>] , statsDict.count > 0  {
                    
                    if let statName = statsDict[0]["stat"]?["name"]! {
                        self._baseAttack = ("\(statName)")
                    }
                    
                    for x in 0..<statsDict.count {
                        if let statName = statsDict[x]["stat"]?["name"]! {
                            if "\(statName)" == "defense" {
                                if let defenseInt = statsDict[x]["base_stat"] {
                                    self._baseDefense  = "\(defenseInt)"
                                }
                            }
                            if "\(statName)" == "attack" {
                                if let attackInt = statsDict[x]["base_stat"] {
                                    self._baseAttack  = "\(attackInt)"
                                    
                                }
                            }
                        }
                    }
                }
                
                if let typesDict = dict["types"] as? [Dictionary <String, AnyObject>] , typesDict.count > 0  {
                    
                    if let typeName = typesDict[0]["type"]!["name"]! {
                        
                        self._type = ("\(typeName)")
                        
                    }
                    
                    for x in 1..<typesDict.count {
                        
                        if let typeName = typesDict[x]["type"]!["name"]! {
                            
                            self._type! += "/\(typeName)"
                            
                        }
                    }
                    self._type = self._type.capitalized
                    
                }
                if let speciesURL = dict["species"]!["url"] {
                    let url = speciesURL as! String
//                    print("Species URL", url)
                    
                    AF.request(url).responseJSON { (response) in
                    
                        if let speciesDict = response.value as? Dictionary<String, AnyObject> {
//                            print(speciesDict)
                            if let pokedexEntryDict = speciesDict["flavor_text_entries"] as? [Dictionary<String, AnyObject>] , speciesDict.count > 0 {
                                
                                var i : Int = 0
                                
                                while i < pokedexEntryDict.count {
                                    
                                    if let getLanguage = pokedexEntryDict[i]["language"]!["name"] {
                                        
                                        let language = getLanguage as! String
                                        
                                        if language == "en" {
                                            
//                                            print("Found English Text")
                                            
                                            if let description = pokedexEntryDict[i]["flavor_text"] {
                                                
                                                i = pokedexEntryDict.count
                                                
//                                                print(description)
                                                
                                                self._pokedexEntry = description as? String
                                                
                                                let trimmed = self._pokedexEntry.replacingOccurrences(of: "\n", with: " ", options: .regularExpression)
                                                
                                                self._pokedexEntry = self._pokedexEntry.replacingOccurrences(of: "POKMON", with: "Pokémon", options: .regularExpression)
                                                
                                                self._pokedexEntry = self._pokedexEntry.replacingOccurrences(of: ".", with: ". ", options: .regularExpression)
                                                
                                                self._pokedexEntry = self._pokedexEntry.replacingOccurrences(of: ",", with: ", ", options: .regularExpression)
                                                
                                                self._pokedexEntry = trimmed
                                            }
                                        } else {
                                            i = i + 1
                                        }
                                    }
                                }
                            }
                            if let getUrlFromSpeciesDict = speciesDict["evolution_chain"]!["url"]! {
                                
                                self._evolutionURL = getUrlFromSpeciesDict as? String
                                
                                print(self._evolutionURL)
                                
//                                self.evolution.downloadEvolutionDataFrom(url:evolutionURL)
                                
//                                self.evolution = Evolution (evolutionURL: evolutionURL)
//                                self.evolution.downloadEvolutionData {
//
//                                    print("download complete")
//
//                                    print(self.evolution.stage1Evolution)
//                                    print(self.evolution.stage2Evolution)
//
//                                }
                            }
                        }
                        completed()
                    }
                }
            }
            completed()
        }
    }

}
