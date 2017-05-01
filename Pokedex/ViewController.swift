//
//  ViewController.swift
//  Pokedex
//
//  Created by Shravan Chopra on 24/04/17.
//  Copyright © 2017 Shravan Chopra. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    // create a music player
    var musicPlayer: AVAudioPlayer!
    
    // arrays to store pokemon data
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        // change the button from 'search' to 'done'
        searchBar.returnKeyType = .done
        
        parsePokemonCSV()
        initAudio()
    }
    
    
    func initAudio() {
        
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1          // loops continuously
            musicPlayer.play()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    
    }
    
    
    func parsePokemonCSV() {
    
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows         // rows are returned as an array of dictionaries
            
            for row in rows {
                
                // here, force-unwrapping is okay because we have all the data (we know it's there!)
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokedexID: pokeId)
                pokemon.append(poke)
            }
            
        } catch let err as NSError {
            print(err)
        }
    }
    
    
    // create the cells here
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            // create the pokemon with the image
            var poke:Pokemon!
            
            if (inSearchMode) {
                poke = filteredPokemon[indexPath.row]
            } else {
                poke = pokemon[indexPath.row]
            }
            
            cell.configureCell(poke)
            return cell
            
        } else {
            
            return UICollectionViewCell()
        }
    }

    // what you do when an item is selected/tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // we're going to pass this along to the next VC
        var poke:Pokemon!
        
        if(inSearchMode) {
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
    }
    
    // how many items there are in the collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredPokemon.count
        }
        
        return pokemon.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
    }
    
    // make the keyboard disappear
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    
    // search bar function, called whenever we make a keystroke
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collection.reloadData()
            
            // make the keyboard disappear
            view.endEditing(true)
        } else {
        
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
            // think of $0 as a placeholder for each object in the pokemon array
            
            collection.reloadData()
        }
        
    }

    // pass along pokemon object to PokemonDetailsVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if segue.identifier == "PokemonDetailVC" {
            
            if let detailsVC = segue.destination as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }
        
    }
    
    // to play/pause music
    @IBAction func musicButtonPressed(_ sender: UIButton) {

        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1
        }
    }
    
}

