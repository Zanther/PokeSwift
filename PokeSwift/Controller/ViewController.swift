//
//  ViewController.swift
//  PokeSwift
//
//  Created by Steven Lattenhauer 2nd on 7/3/18.
//  Copyright © 2018 Steven Lattenhauer 2nd. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var searchBar: PokeSearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
   
        parsePokemonCSV()
        
        initAudio()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            searching = false
            collectionView.reloadData()
            view.endEditing(true)
            
        } else {
            searching = true
             let lower = searchBar.text!.lowercased()
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
            collectionView.reloadData()
        }
        
        print(String.self)
        
    }
    
    func initAudio(){
        
        let path = Bundle.main.path(forResource: "music", ofType: ".mp3")!
        
        do {
            
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1 // will loop infinite
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    func parsePokemonCSV() {
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")
        
        do {
            
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
            
            for row in rows {
                
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let pocketMonster = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(pocketMonster)
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell{

            let pocketMonster: Pokemon!
            
            if searching {
                pocketMonster = self.filteredPokemon[indexPath.row]
            } else {
                pocketMonster = self.pokemon[indexPath.row]
            }
            
            cell.configureCell(pokemon: pocketMonster)
            
            return cell
            
        } else {
            
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searching {
            return filteredPokemon.count
        } else {
            return pokemon.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let pocketMonster: Pokemon!
        
        if searching {
            pocketMonster = self.filteredPokemon[indexPath.row]
            
            
        } else {
            pocketMonster = self.pokemon[indexPath.row]
        }
        
        performSegue(withIdentifier: "pokeSegue", sender: pocketMonster)
        
        print(pocketMonster.name)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 110, height: 110)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pokeSegue" {
            if let detailsVC = segue.destination as? PokeDetailVC {
                if let pocketMonster = sender as? Pokemon {
                    detailsVC.pokemon = pocketMonster
                }
            }
        }
    }
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying {
        musicPlayer.pause()
            sender.alpha = 0.2
        } else {
        musicPlayer.play()
            sender.alpha = 0.9
        }
    }
    
}

