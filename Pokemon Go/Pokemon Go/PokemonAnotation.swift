//
//  PokemonAnotation.swift
//  Pokemon Go
//
//  Created by César  Ferreira on 08/01/20.
//  Copyright © 2020 César  Ferreira. All rights reserved.
//

import UIKit
import MapKit

class PokemonAnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemon
    
    init(coordinates: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordinates
        self.pokemon = pokemon
    }
}
