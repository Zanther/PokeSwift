//
//  PokeDetailVC.swift
//  PokeSwift
//
//  Created by Steven Lattenhauer 2nd on 7/5/18.
//  Copyright © 2018 Steven Lattenhauer 2nd. All rights reserved.
//

import UIKit

class PokeDetailVC: UIViewController {

    @IBOutlet weak var pokeImageViewBG: UIImageView!
    @IBOutlet weak var pokeNameLbl: UILabel!
    @IBOutlet weak var pokeImageView: UIImageView!
    @IBOutlet weak var pokedexNumberLbl: UILabel!
    @IBOutlet weak var pokeTypeLbl: UILabel!
    @IBOutlet weak var pokeHeightLbl: UILabel!
    @IBOutlet weak var pokeWeightLbl: UILabel!
    @IBOutlet weak var pokeBaseAtkLbl: UILabel!
    @IBOutlet weak var pokeBaseDefLbl: UILabel!
    @IBOutlet weak var pokedexEntryLbl: UILabel!
    @IBOutlet weak var evolutionLbl: UILabel!
    @IBOutlet weak var evolutionImageLeft: UIImageView!
    @IBOutlet weak var evolutionImageRight: UIImageView!
    @IBOutlet weak var evolutionRightLbl: UILabel!
    @IBOutlet weak var evolutionLeftLbl: UILabel!
    @IBOutlet weak var evolveArrow: UIImageView!
    
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokeNameLbl.text = pokemon.name.capitalized
        pokedexNumberLbl.text = String(format: "%03d", pokemon.pokedexId)
        
        pokeImageView.image = UIImage(named: "\(pokemon.pokedexId)")
        pokeImageViewBG.image = UIImage(named: "\(pokemon.pokedexId)")
        pokeImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
            
        self.updateUI()
    }

    func updateUI() {
        
        pokeTypeLbl.text = pokemon.type
        pokeHeightLbl.text = pokemon.height
        pokeWeightLbl.text = pokemon.weight
        pokeBaseAtkLbl.text = pokemon.baseAttack
        pokeBaseDefLbl.text = pokemon.baseDefense
        pokedexEntryLbl.text = pokemon.pokedexEntry
        
        evolutionLbl.text = "\(pokemon.evolution.stage1Trigger.capitalized)\(" at ")\(pokemon.evolution.stage1MinLevel)"

        evolutionImageLeft.image = UIImage(named: "\(pokemon.pokedexId)")
        evolutionImageRight.image = UIImage(named: "\(pokemon.evolution.stage1EvolutionID)")
        evolutionRightLbl.text = pokemon.name.capitalized
        evolutionLeftLbl.text = pokemon.evolution.stage1Evolution

        evolveArrow.isHidden = false
        evolutionImageLeft.isHidden = false
        evolutionImageRight.isHidden = false
//
        if pokemon.evolution.stage1EvolutionID == "" {

            print("No Evolutions")
            evolutionLbl.text = "\(pokemon.name.capitalized)\(" does not evolve")"
            evolutionImageLeft.isHidden = true
            evolutionImageRight.isHidden = true
            evolutionRightLbl.text = ""
            evolutionLeftLbl.text = ""
            evolveArrow.isHidden = true

        }
        else if pokemon.evolution.stage2EvolutionID == "" {

            evolutionLbl.text = "\(pokemon.name.capitalized)\(" does not evolve")"
            evolutionImageLeft.isHidden = true
            evolutionImageRight.isHidden = true
            evolutionRightLbl.text = ""
            evolutionLeftLbl.text = ""
            evolveArrow.isHidden = true
            print("No Further Evolutions")
        }

        // print("Pokemon ID", "\(pokemon.pokedexId)", pokemon.evolution.stage1EvolutionID, pokemon.evolution.stage2EvolutionID)

            if "\(pokemon.pokedexId)" == pokemon.evolution.stage1EvolutionID && pokemon.evolution.stage2EvolutionID != "" {

                if  pokemon.evolution.stage2Trigger == "use-item" {
                    let evolutionItem = pokemon.evolution.stage2MinLevel.replacingOccurrences(of: "-", with: " ").capitalized
                    evolutionLbl.text = "\("Use item: ")\(evolutionItem)"
                } else if pokemon.evolution.stage2Trigger == "trade" {
                    let trade = pokemon.evolution.stage2Trigger.capitalized
//                    evolutionLbl.text = "\(trade)\(" with ")\(pokemon.evolution.stage2MinLevel.capitalized)\(" attached")"
                    
                    if pokemon.evolution.heldItem != "No Trade Item" {
                        evolutionLbl.text = "\(trade)\(" with ")\(pokemon.evolution.heldItem.capitalized)\(" attached")"
                    } else {
                        evolutionLbl.text = "\(trade)\(" with a friend")"
                    }
                    
                } else {
                    let levelUp = pokemon.evolution.stage2MinLevel.replacingOccurrences(of: "-", with: " ").capitalized
                        evolutionLbl.text = "\(levelUp)\(" at ")\(pokemon.evolution.stage2MinLevel)"
                }
                
                evolutionImageLeft.image = UIImage(named: "\(pokemon.evolution.stage1EvolutionID)")
                evolutionImageRight.image = UIImage(named: "\(pokemon.evolution.stage2EvolutionID)")
                evolutionRightLbl.text = pokemon.name.capitalized
                evolutionLeftLbl.text = pokemon.evolution.stage2Evolution.capitalized

            } else if "\(pokemon.pokedexId)" == pokemon.evolution.stage2EvolutionID {

                evolutionLbl.text = "\(pokemon.name.capitalized)\(" does not evolve")"
                evolutionImageLeft.isHidden = true
                evolutionImageRight.isHidden = true
                evolutionRightLbl.text = ""
                evolutionLeftLbl.text = ""
                evolveArrow.isHidden = true
                print("No Further Evolutions")
            } else if "\(pokemon.pokedexId)" != pokemon.evolution.stage1EvolutionID && pokemon.evolution.stage1EvolutionID != "" && pokemon.evolution.stage2EvolutionID == "" {

//                evolutionLbl.text = "\(pokemon.name.capitalized)\(" evolves at level 20")"
                
                if pokemon.evolution.stage1Trigger == "use-item" {
                    let item = pokemon.evolution.stage1Trigger.replacingOccurrences(of: "-", with: " ").capitalized
                    evolutionLbl.text = "\(item)\(": ")\(pokemon.evolution.stage1MinLevel)"
                } else if pokemon.evolution.stage1Trigger == "trade" {
                    let trade = pokemon.evolution.stage1Trigger.capitalized
                    print("trade?", pokemon.evolution.heldItem)
                    if pokemon.evolution.heldItem != "No Trade Item" {
                        evolutionLbl.text = "\(trade)\(" with ")\(pokemon.evolution.heldItem.capitalized)\(" attached")"
                    } else {
                        evolutionLbl.text = "\(trade)\(pokemon.evolution.heldItem)"
                    }
                } else {
                    let levelUp = pokemon.evolution.stage1Trigger.replacingOccurrences(of: "-", with: " ").capitalized
                    print(pokemon.evolution.minHappiness)
                        evolutionLbl.text = "\(levelUp)\(" at ")\(pokemon.evolution.stage1MinLevel)"
                }
                
                evolutionImageLeft.image = UIImage(named: "\(pokemon.pokedexId)")
                evolutionImageRight.image = UIImage(named: "\(pokemon.evolution.stage1EvolutionID)")
                evolutionRightLbl.text = pokemon.name.capitalized
                evolutionLeftLbl.text = pokemon.evolution.stage1Evolution
                evolveArrow.isHidden = false
                evolutionImageLeft.isHidden = false
                evolutionImageRight.isHidden = false
            } else if pokemon.evolution.minHappiness != "" && pokemon.evolution.stage1MinLevel == ""{
                let levelUp = pokemon.evolution.stage1Trigger.replacingOccurrences(of: "-", with: " ").capitalized
                print("Happiness", pokemon.evolution.minHappiness)
                evolutionLbl.text = "\(levelUp)\(" with happiness at ")\(pokemon.evolution.minHappiness)"
            } else {
                print("Default Level Up UI")
                self.updateUI()
        }
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    
}
