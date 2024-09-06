//
//  Evolution.swift
//  PokeSwift
//
//  Created by Steven Lattenhauer 2nd on 7/10/18.
//  Copyright © 2018 Steven Lattenhauer 2nd. All rights reserved.
//

import Foundation
import Alamofire

class Evolution: Pokemon {
    
    private var _url: String!
    private var _stage1Evolution: String!
    private var _stage2Evolution: String!
    private var _megaEvolution: String!
    private var _stage1EvolutionID: String!
    private var _stage2EvolutionID: String!
    private var _megaEvolutionID: String!
    private var _stage1Trigger: String!
    private var _stage2Trigger: String!
    private var _stage1MinLevel: String!
    private var _stage2MinLevel: String!
    private var _heldItem: String!
    private var _minHappiness: String!

    
    var url: String {
        if _url == nil {
            _url = ""
        }
        return _url
    }
    
    var stage1Evolution: String {
        if _stage1Evolution == nil {
            _stage1Evolution = ""
            
        }
        return _stage1Evolution
    }
    
    var stage2Evolution: String {
        if _stage2Evolution == nil {
            _stage2Evolution = ""
        }
        return _stage2Evolution
    }
    
    var megaEvolution: String {
        if _megaEvolution == nil {
            _megaEvolution = ""
        }
        return _megaEvolution
    }
    
    
    var stage1EvolutionID: String {
        if _stage1EvolutionID == nil {
            _stage1EvolutionID = ""
        }
        return _stage1EvolutionID
    }
    
    var stage2EvolutionID: String {
        if _stage2EvolutionID == nil {
            _stage2EvolutionID = ""
        }
        return _stage2EvolutionID
    }
    
    var megaEvolutionID: String {
        if _megaEvolutionID == nil {
            _megaEvolutionID = ""
        }
        return _megaEvolutionID
    }
    
    var stage1Trigger: String {
        if _stage1Trigger == nil {
            _stage1Trigger = ""
        }
        return _stage1Trigger
    }
    
    var stage2Trigger: String {
        if _stage2Trigger == nil {
            _stage2Trigger = ""
        }
        return _stage2Trigger
    }
    
    var stage1MinLevel: String {
        if _stage1MinLevel == nil {
            _stage1MinLevel = ""
        }
        return _stage1MinLevel
    }
    
    var stage2MinLevel: String {
        if _stage2MinLevel == nil {
            _stage2MinLevel = ""
        }
        return _stage2MinLevel
    }
    
    var heldItem: String {
        if _heldItem == nil {
            _heldItem = ""
        }
        return _heldItem
    }
    
    var minHappiness: String {
        if _minHappiness == nil {
            _minHappiness = ""
        }
        return _minHappiness
    }
    
    init(evolutionURL: String) {
        super.init(name: "", pokedexId: 0)
        self._url = evolutionURL
    }
    
    
    func downloadEvolutionData(completed: @escaping DownloadComplete) {
        
        print("Evolution URL", url)
        
        AF.request(url).responseJSON { (response) in
            
            //print("Evolution Response", response)
            
            if let evoInfoDict = response.value as? Dictionary<String, AnyObject> {
                
                //As the evolves to item is an array, we need to cast it as an array of dictionaries - note square brackets below
                
                if let evoInfoEvolvesBranchDict = evoInfoDict["chain"]!["evolves_to"] as? [Dictionary <String, AnyObject>] , evoInfoDict.count > 0 {
                    
                    var y : Int = 0
                    
                    var z : Int = 0
                    
                    
                    if evoInfoEvolvesBranchDict.count > 0 {
                        
                                                print("Evo Info", evoInfoEvolvesBranchDict)
                        //                        print(evoInfoEvolvesBranchDict.count)
                        
                        let stage1EvolutionDetails = evoInfoEvolvesBranchDict[y]["evolution_details"] as! [Dictionary <String, AnyObject>]
                        
                        print("Stage 1 Details", [stage1EvolutionDetails[0]])
                        
                        let evoArr = stage1EvolutionDetails[0]
                        
                        self._stage1MinLevel = (String(format: "%@", evoArr["min_level"] as! CVarArg))
                        
                        self._minHappiness = (String(format: "%@", evoArr["min_happiness"] as! CVarArg))
                        
                        let evoTriggerDict = evoArr["trigger"] as? Dictionary<String, AnyObject>
                        
                        //                        print("Trigger Array", evoTriggerDict!)
                        
                        let evoTrigger = evoTriggerDict!["name"] as! String
                        
                        print("Trigger:", evoTrigger)
                        
                        self._stage1Trigger = evoTrigger
                                                
                        if let evoItemDict = evoArr["item"] as? Dictionary<String, AnyObject> {
                            print("Evolution Item", evoItemDict as Any)
                            
                            if evoTrigger == "use-item" {
                                
//                                print("Use Item ", evoItemDict["name"]!)
                                
                                self._stage1MinLevel = evoItemDict["name"] as? String
                                
                            }
                            
                        }
                        
                        if let evoTradeItemDict = evoArr["held_item"] as? Dictionary<String, AnyObject> {
                            print("Trade Evolution!", evoTradeItemDict as Any)

                            if evoTrigger == "trade" {
                                if let tradeItem = evoTradeItemDict["name"] as? String {
                                    if tradeItem != "" {
                                        self._heldItem = tradeItem.replacingOccurrences(of: "-", with: " ")
                                    }
                                }
                            }
                        } else {
                            self._heldItem = "No Trade Item"
                        }

                        while y < evoInfoEvolvesBranchDict.count {

                            if let evolution2 = evoInfoEvolvesBranchDict[y]["species"]!["name"]! {
                                
                                
                                self._stage1Evolution = "\(evolution2)"
                                
                                self._stage1Evolution = self._stage1Evolution.capitalized
                                
                                //Now get the pokedexID we need for the image
                                
                                if let pokedexIdURL = evoInfoEvolvesBranchDict[y]["species"]!["url"]! {
                                    
                                    let evoString2 = (pokedexIdURL as AnyObject).replacingOccurrences(of: "https://pokeapi.co/api/v2/pokemon-species/", with: "")
                                    
                                    self._stage1EvolutionID = (evoString2 as AnyObject).replacingOccurrences(of: "/", with: "")
                                    
                                    z = y
                                    
                                    y = y + 100
                                    
                                }
                            }
                            
                            //For second evolution, also need to access it as an array
                            
                            if let evolution2 = evoInfoEvolvesBranchDict[z]["evolves_to"]! as? [Dictionary <String, AnyObject>] , evoInfoEvolvesBranchDict.count > 0 {
                                
                                if evolution2.count > 0 {
                                    
                                    let stage2EvolutionDetails = evolution2[z]["evolution_details"] as! [Dictionary <String, AnyObject>]
                                    
                                    //                            print("Evolution 2", evolution2)
                                    
                                    print("Stage 2 Evo Details", stage2EvolutionDetails)
                                    
                                    let evoArr = stage2EvolutionDetails[0]
                                    
                                    self._stage2MinLevel = (String(format: "%@", evoArr["min_level"] as! CVarArg))
                                    
                                    let evoTriggerDict = evoArr["trigger"] as? Dictionary<String, AnyObject>
                                    
                                    let evoTrigger = evoTriggerDict!["name"] as? String

//                                    print("Trigger Stage 2:", evoTrigger! as Any)
                                    
                                    self._stage2Trigger = evoTrigger
                                    
                                    let evoItemDict = evoArr["item"] as? Dictionary<String, AnyObject>
                                    print("Evolution Item", evoItemDict as Any)
                                    
                                    if evoTrigger == "use-item" {
                                        
                                        print("Use Item ", evoItemDict!["name"]!)
                                        
                                        self._stage2MinLevel = evoItemDict!["name"] as? String
                                        
                                    }
                                    
                                    
//                                    print("Stage 2 Evolution Trigger:", self._stage2Trigger)
//
//                                    print("Stage 2 Minimum Level", self._stage2MinLevel!)
                                    
                                    if evolution2.count > 0 {
                                        
                                        if let evolution3 = evolution2[z]["species"]!["name"]! {
                                            
                                            self._stage2Evolution = "\(evolution3)"
                                            
                                            self._stage2Evolution = self._stage2Evolution.capitalized
                                            
                                            //                                                            self._stage2Evolution = " / " + self._stage2Evolution
                                            
                                            //                                    print("Stage 2", evolution3)
                                            
                                            if let pokedexIdURL = evolution2[z]["species"]!["url"]! {
                                                
                                                var evoString3 = (pokedexIdURL as AnyObject).replacingOccurrences(of: "https://pokeapi.co/api/v2/pokemon-species/", with: "")
                                                
                                                evoString3 = (evoString3 as AnyObject).replacingOccurrences(of: "/", with: "")
                                                
                                                self._stage2EvolutionID = (evoString3 as AnyObject).replacingOccurrences(of: "/", with: "")
                                                
                                            }
                                        }
                                    }
                                }
                            }
                                
                            else {
                                
                                self._stage2Evolution = ""
                                
                                self._stage2EvolutionID = nil
                                
                            }
                            y = y + 1
                        }
                        
                    }  else  {
                        self._stage1Evolution = "No further evolutions"
                        
                        self._stage1EvolutionID = nil
                    }
                    completed()
                }
            }
        }
    }
}
