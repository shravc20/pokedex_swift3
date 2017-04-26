//
//  PokeCell.swift
//  Pokedex
//
//  Created by Shravan Chopra on 25/04/17.
//  Copyright © 2017 Shravan Chopra. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    var pokemon: Pokemon!
    
    required init? (coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = CGFloat(0.5)
    }
    

    
    
    // create the pokemon from data
    func configureCell(pokemon: Pokemon) {
        self.pokemon = pokemon
        
        // update cell UI
        nameLabel.text = self.pokemon.name.capitalized
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexID)")
    }

}
