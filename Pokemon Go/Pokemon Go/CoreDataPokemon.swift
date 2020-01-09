//
//  CoreDataPokemon.swift
//  Pokemon Go
//
//  Created by César  Ferreira on 08/01/20.
//  Copyright © 2020 César  Ferreira. All rights reserved.
//

import UIKit
import CoreData

class CoreDataPokemon {
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        return context!
    }
    
    func createPokemon( name: String, nameImage: String, gotcha: Bool ) {
        
        let pokemon = Pokemon(context: self.getContext())
        pokemon.name = name
        pokemon.nameImage = nameImage
        pokemon.gotcha = gotcha
        
    }
    
    func addAllPokemons() {
        
        self.createPokemon(name: "Mew", nameImage: "mew", gotcha: false)
        self.createPokemon(name: "Meowth", nameImage: "meowth", gotcha: false)
        self.createPokemon(name: "Pikachu", nameImage: "pikachu-2", gotcha: true)
        self.createPokemon(name: "Squirtle", nameImage: "squirtle", gotcha: false)
        self.createPokemon(name: "Charmander", nameImage: "charmander", gotcha: false)
        self.createPokemon(name: "Caterpie", nameImage: "caterpie", gotcha: false)
        self.createPokemon(name: "Bullbasaur", nameImage: "bullbasaur", gotcha: false)
        self.createPokemon(name: "Bellsprout", nameImage: "bellsprout", gotcha: false)
        self.createPokemon(name: "Psyduck", nameImage: "psyduck", gotcha: false)
        self.createPokemon(name: "Rattata", nameImage: "rattata", gotcha: false)
        self.createPokemon(name: "Snorlax", nameImage: "snorlax", gotcha: false)
        self.createPokemon(name: "Zubat", nameImage: "zubat", gotcha: false)
        
        do {
            try self.getContext().save()
        } catch  {
            
        }
        
    }
    
    func getAllPokemons() -> [Pokemon] {
        
        do {
            let pokemons = try self.getContext().fetch( Pokemon.fetchRequest() ) as! [Pokemon]
            
            if ( pokemons.count == 0 ) {
                self.addAllPokemons()
                return self.getAllPokemons()
            }
            
            return pokemons
            
        } catch let error {
            print("Erro ao recuperar pokemons")
        }
        
        return []
        
    }
    
    func savePokemon(pokemon: Pokemon) {
        
        pokemon.gotcha = true
        
        do {
            try self.getContext().save()
        } catch  {
            
        }
        
    }
    
    func getPokemonsGotcha(gotcha: Bool) -> [Pokemon] {
        
        do {

            let request: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
            request.predicate = NSPredicate(format: "gotcha = %d", gotcha)
            
            let pokemons = try self.getContext().fetch(request) as [Pokemon]
            return pokemons
            
        } catch  {
            
        }
        
        return []
    }
    
}
