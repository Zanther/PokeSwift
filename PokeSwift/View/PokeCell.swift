//
//  PokeCell.swift
//  PokeSwift
//
//  Created by Steven Lattenhauer 2nd on 7/5/18.
//  Copyright © 2018 Steven Lattenhauer 2nd. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon : Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 10.0
       
    }
    
    func configureCell(pokemon: Pokemon){
        
        self.pokemon = pokemon
        nameLbl.text = self.pokemon.name.capitalized
        nameLbl.layer.cornerRadius = 10.0
        cellImage.image = UIImage(named: "\(self.pokemon.pokedexId)")
    
    }
    
    
    
}
