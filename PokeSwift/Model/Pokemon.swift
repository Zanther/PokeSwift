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
//    private var _stage1Evolution: String!
//    private var _stage2Evolution: String!
//    private var _megaEvolution: String!
//    private var _stage1EvolutionID: String!
//    private var _stage2EvolutionID: String!
//    private var _megaEvolutionID: String!
//    private var _stage1Trigger: String!
//    private var _stage2Trigger: String!
//    private var _stage1MinLevel: String!
//    private var _stage2MinLevel: String!
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
    
//    var stage1Evolution: String {
//        if _stage1Evolution == nil {
//            _stage1Evolution = ""
//
//
//        }
//        return _stage1Evolution
//    }
//
//    var stage2Evolution: String {
//        if _stage2Evolution == nil {
//            _stage2Evolution = ""
//        }
//        return _stage2Evolution
//    }
//
//    var megaEvolution: String {
//        if _megaEvolution == nil {
//            _megaEvolution = ""
//        }
//        return _megaEvolution
//    }
//
//    var megaEvolutionID: String {
//        if _megaEvolutionID == nil {
//            _megaEvolutionID = ""
//        }
//        return _megaEvolutionID
//    }
//
//    var stage1EvolutionID: String {
//        if _stage1EvolutionID == nil {
//            _stage1EvolutionID = ""
//        }
//        return _stage1EvolutionID
//    }
//
//    var stage2EvolutionID: String {
//        if _stage2EvolutionID == nil {
//            _stage2EvolutionID = ""
//        }
//        return _stage2EvolutionID
//    }
    
    
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
        
        Alamofire.request(self.pokemonURL).responseJSON { (response) in
            
//                                    print(response)
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
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
                    
                    Alamofire.request(url).responseJSON { (response) in
                    
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
                                                
                                                self._pokedexEntry = description as! String
                                                
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
                                
                                self._evolutionURL = getUrlFromSpeciesDict as! String
                                
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
    
    
//
//    func downloadPokemonDetailv2(completed: @escaping DownloadComplete) {
//
//        print(pokemonURL)
//
//        Alamofire.request(pokemonURL).responseJSON { (response) in
//
//            if let dict = response.result.value as? Dictionary<String, AnyObject> {
//
//                if let weight = dict["weight"] as? Int {
//
//                    self._weight = "\(weight)"
//
//                }
//
//                if let height = dict["height"] as? Int {
//
//                    self._height = "\(height)"
//
//                }
//
//                //Download Attack and Defense - for v2 API
//
//                if let statsDict = dict["stats"] as? [Dictionary <String, AnyObject>] , statsDict.count > 0  {
//
//                    if let statDes = statsDict[0]["stat"]?["name"]! {
//
//                        self._baseAttack = ("\(statDes)")
//
//                    }
//
//                    for x in 0..<statsDict.count {
//
//                        if let statDes = statsDict[x]["stat"]?["name"]! {
//
//                            if "\(statDes)" == "defense" {
//
//                                if let defenseInt = statsDict[x]["base_stat"] {
//
//                                    self._baseDefense  = "\(defenseInt)"
//
//                                }
//
//                            }
//
//                            if "\(statDes)" == "attack" {
//
//                                if let attackInt = statsDict[x]["base_stat"] {
//
//                                    self._baseAttack  = "\(attackInt)"
//
//                                }
//                            }
//                        }
//                    }
//                }
//
//                //Download Type - for v2 API
//
//                if let typesDict = dict["types"] as? [Dictionary <String, AnyObject>] , typesDict.count > 0  {
//
//                    if let typeDes = typesDict[0]["type"]!["name"]! {
//
//                        self._type = ("\(typeDes)")
//
//                    }
//
//                    for x in 1..<typesDict.count {
//
//                        if let typeDes = typesDict[x]["type"]!["name"]! {
//
//                            self._type! += "/\(typeDes)"
//
//                        }
//                    }
//                }
//
//                self._type = self._type.capitalized
//
//
//                //Download Description for v2 API
//
//                let speciesURL = URL_BASE + "\(self.pokedexId)"
//                Alamofire.request(speciesURL).responseJSON { (response) in
//
//                    if let descDict = response.result.value as? Dictionary<String, AnyObject> {
//
//                        if let flavourDict = descDict["flavor_text_entries"] as? [Dictionary <String, AnyObject>] , descDict.count > 0 {
//
//                            //Find the english language description - the array isn't consistent between pokemon - eg Bulbasaur and Pikach
//
//                            var x : Int = 0
//
//                            while x < flavourDict.count {
//
//                                if let language = flavourDict[x]["language"]!["name"]! {
//
//                                    //if we find an english match, then do the following:
//
//                                    if "\(language)" == "en" {
//
//                                        if let detailDescription = flavourDict[x]["flavor_text"] {
//
//                                            self._pokedexEntry = "\(detailDescription)"
//
//                                            //minor text editing to imrpove readability
//
//                                            let trimmed = self._pokedexEntry.replacingOccurrences(of: "\n", with: " ", options: .regularExpression)
//
//                                            self._pokedexEntry = self._pokedexEntry.replacingOccurrences(of: "POKMON", with: "Pokémon", options: .regularExpression)
//
//                                            self._pokedexEntry = self._pokedexEntry.replacingOccurrences(of: ".", with: ". ", options: .regularExpression)
//
//                                            self._pokedexEntry = self._pokedexEntry.replacingOccurrences(of: ",", with: ", ", options: .regularExpression)
//
//                                            self._pokedexEntry = trimmed
//
//                                            //increment the counter beyond the max number of languages in the response to break out of the loop as we have a match
//
//                                            x = x + 100
//                                        }
//                                    }
//                                }
//                                x = x + 1
//                            }
//                        }
//                    }
//
//                    //Now get the evolution URL from the current URL
//
//                    if let evoURLDict = response.result.value as? Dictionary<String, AnyObject> {
//
//                        if let evoURLRaw = evoURLDict["evolution_chain"]!["url"]! {
//
//                            let evoURL = "\(evoURLRaw)"
//
//                            //Now request the relative evolution URL
//
//                            Alamofire.request(evoURL).responseJSON { (response) in
//
//                                //pass into dictionary
//
//                                if let evoInfoDict = response.result.value as? Dictionary<String, AnyObject> {
//
//                                    //As the evolves to item is an array, we need to cast it as an array of dictionaries - note square brackets below
//
//                                    if let evoInfoEvolvesBranchDict = evoInfoDict["chain"]!["evolves_to"] as? [Dictionary <String, AnyObject>] , evoInfoDict.count > 0 {
//
//                                        var y : Int = 0
//
//                                        var z : Int = 0
//
//                                        while y < evoInfoEvolvesBranchDict.count {
//
//                                            if let evolution2 = evoInfoEvolvesBranchDict[y]["species"]!["name"]! {
//
//                                                self._stage1Evolution = "\(evolution2)"
//
//                                                self._stage1Evolution = self._stage1Evolution.capitalized
//
//                                                self._stage1Evolution = "Evolution: " + self._stage1Evolution.capitalized
//
//                                                //Now get the pokedexID we need for the image
//
//                                                if let pokedexIdURL = evoInfoEvolvesBranchDict[y]["species"]!["url"]! {
//
//                                                    let evoString2 = (pokedexIdURL as AnyObject).replacingOccurrences(of: "https://pokeapi.co/api/v2/pokemon-species/", with: "")
//
//                                                    self._stage1EvolutionID = (evoString2 as AnyObject).replacingOccurrences(of: "/", with: "")
//
//                                                    z = y
//
//                                                    y = y + 100
//
//                                                }
//                                            }
//
//                                            //For second evolution, also need to access it as an array
//
//                                            if let evolution2 = evoInfoEvolvesBranchDict[z]["evolves_to"]! as? [Dictionary <String, AnyObject>] , evoInfoEvolvesBranchDict.count > 0 {
//
//                                                if evolution2.count > 0 {
//
//                                                    if let evolution3 = evolution2[z]["species"]!["name"]! {
//
//                                                        self._stage2Evolution = "\(evolution3)"
//
//                                                        self._stage2Evolution = self._stage2Evolution.capitalized
//
//                                                        self._stage2Evolution = " / " + self._stage2Evolution
//
//                                                        if let pokedexIdURL = evolution2[z]["species"]!["url"]! {
//
//                                                            var evoString3 = (pokedexIdURL as AnyObject).replacingOccurrences(of: "https://pokeapi.co/api/v2/pokemon-species/", with: "")
//
//                                                            evoString3 = (evoString3 as AnyObject).replacingOccurrences(of: "/", with: "")
//
//                                                            self._stage2EvolutionID = (evoString3 as AnyObject).replacingOccurrences(of: "/", with: "")
//
//                                                        }
//                                                    }
//                                                }
//                                            }
//
//                                            else {
//
//                                                self._stage2Evolution = ""
//
//                                                self._stage2EvolutionID = nil
//
//                                            }
//                                            y = y + 1
//                                        }
//
//                                    }  else  {
//                                        self._stage1Evolution = "No further evolutions"
//
//                                        self._stage1EvolutionID = nil
//                                    }
//                                }
//                                completed()
//                            } // close alamofire
//                        }
//                    }
//                } // close alamofire
//                completed()
//            }
//            completed()
//        } //end func download poke malarky
//    } // this is the end!

    
}
