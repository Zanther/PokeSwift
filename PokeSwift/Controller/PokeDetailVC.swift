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
    
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokeNameLbl.text = pokemon.name.capitalized
        pokedexNumberLbl.text = String(format: "%03d", pokemon.pokedexId)
        
        pokeImageView.image = UIImage(named: "\(pokemon.pokedexId)")
        pokeImageViewBG.image = UIImage(named: "\(pokemon.pokedexId)")
        pokeImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        
        evolutionImageLeft.image = UIImage(named: "\(pokemon.pokedexId)")
        evolutionImageRight.image = UIImage(named: "\(pokemon.pokedexId+1)")

        self.updateUI()
//        pokemon.downloadPokemonDetail {
//
//            print("Start Download Pokemon Information")
//            // This will only be called after the network call is complete
//
//            self.updateUI()
//        }

    }

    func updateUI() {
        
        pokeTypeLbl.text = pokemon.type
        pokeHeightLbl.text = pokemon.height
        pokeWeightLbl.text = pokemon.weight
        pokeBaseAtkLbl.text = pokemon.baseAttack
        pokeBaseDefLbl.text = pokemon.baseDefense
        pokedexEntryLbl.text = pokemon.pokedexEntry
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    
}
