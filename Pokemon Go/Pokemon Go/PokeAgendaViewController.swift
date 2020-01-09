//
//  PokeAgendaViewController.swift
//  Pokemon Go
//
//  Created by César  Ferreira on 08/01/20.
//  Copyright © 2020 César  Ferreira. All rights reserved.
//

import UIKit

class PokeAgendaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var pokemonsGotcha: [Pokemon] = []
    var pokemonsNotGotcha: [Pokemon] = []
    let coreDataPokemon = CoreDataPokemon()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPokemons()
    }
    
    private func getPokemons() {
        
        self.pokemonsGotcha = coreDataPokemon.getPokemonsGotcha(gotcha: true)
        self.pokemonsNotGotcha = coreDataPokemon.getPokemonsGotcha(gotcha: false)

    }
    
    @IBAction func backMap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Capturados"
            
        } else {
            return "Não Capturados"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return self.pokemonsGotcha.count
            
        } else {
            return self.pokemonsNotGotcha.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let pokemon: Pokemon
        
        if (indexPath.section == 0) {
            pokemon = self.pokemonsGotcha[ indexPath.row ]
        } else {
            pokemon = self.pokemonsNotGotcha[ indexPath.row ]
        }
    
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "item")
        
        cell.textLabel?.text = pokemon.name
        cell.imageView?.image = UIImage(named: pokemon.nameImage!)
        
        return cell
        
    }
    
    
    
    
    
    
}
