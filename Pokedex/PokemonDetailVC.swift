//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Shravan Chopra on 29/04/17.
//  Copyright © 2017 Shravan Chopra. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    
    @IBOutlet weak var currentEvoImg: UIImageView!
    
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    
    var pokemon:Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // updating UI with info we already have
        let currentPokeImg = UIImage(named: "\(pokemon.pokedexID)")

        
        nameLabel.text = pokemon.name.capitalized
        pokedexLbl.text = "\(pokemon.pokedexID)"
        mainImg.image = currentPokeImg
        currentEvoImg.image = currentPokeImg
        
        pokemon.downloadPokemonDetails {
            
            // whatever we do here happens only after the network call is complete
            
            print("Did arrive here!")
            
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        attackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.description
        
        if pokemon.nextEvolutionId == "" {
            evoLbl.text = "No evolutions"
            nextEvoImg.isHidden = true          // automatically recentered by stackview
        } else {
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            evoLbl.text = "Next Evolution: \(pokemon.nextEvolutionName) - LVL \(pokemon.nextEvolutionLevel)"
        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }

}
