//
//  ViewController.swift
//  Pokemon Go
//
//  Created by César  Ferreira on 07/01/20.
//  Copyright © 2020 César  Ferreira. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    var managerLocation = CLLocationManager()
    var count = 0
    var coreDataPokemon: CoreDataPokemon!
    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        managerLocation.delegate = self
        
        managerLocation.requestWhenInUseAuthorization()
        managerLocation.startUpdatingLocation()
        
        self.coreDataPokemon = CoreDataPokemon()
        self.pokemons = self.coreDataPokemon.getAllPokemons()
        
        showPokemon()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let anotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
                
        if (annotation is MKUserLocation) {
            anotationView.image = UIImage(named: "player")
        } else {
            let pokemon = (annotation as! PokemonAnotation).pokemon
            anotationView.image = UIImage(named: pokemon.nameImage!)
        }
        
        var frame = anotationView.frame
        frame.size.height = 40
        frame.size.width = 40
        anotationView.frame = frame
        
        return anotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let annotation = view.annotation
        let pokemon = (view.annotation as! PokemonAnotation).pokemon
        
        mapView.deselectAnnotation(annotation, animated: true)
        
        if ( annotation is MKUserLocation ) {
            return
        }
        
        if let coordAnnotation = annotation?.coordinate {
            let region = MKCoordinateRegion(center: coordAnnotation, latitudinalMeters: 200, longitudinalMeters: 200)
            
            map.setRegion(region, animated: true)
        }
        
        self.coreDataPokemon.savePokemon(pokemon: pokemon)
        self.map.removeAnnotation(annotation!)
        
        let alertController = UIAlertController(title: "Parabéns!!!", message: "Você capturou o pokemon " + pokemon.name!, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(actionOk)
        
        self.present(alertController, animated: true, completion: nil)
        /*
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if let coord = self.managerLocation.location?.coordinate {
                

                if MKMapRect.init().contains( MKMapPoint.init(coord) ) {
                    print("Capturado")
                    self.coreDataPokemon.savePokemon(pokemon: pokemon)

                } else {
                    print("Não Capturado")
                    self.coreDataPokemon.savePokemon(pokemon: pokemon)

                }
              

            }
        }
        */
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        if (count < 5) {
            centralizePlayer()
            
            count += 1
        } else {
            managerLocation.stopUpdatingLocation()
        }

    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if ( status != .authorizedWhenInUse && status != .notDetermined ) {
            
            let alertController = UIAlertController(
                title: "Permissão de localização",
                message: "Para que você possa caçar pokemons, precisamos da sua localização!! por favor habilite",
                preferredStyle: .alert)
            
            let actionConfig = UIAlertAction(title: "Abrir configurações", style: .default) { (UIAlertAction) in
                
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
                
            }
            let actionCancel = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alertController.addAction(actionConfig)
            alertController.addAction(actionCancel)
            
            present( alertController, animated: true, completion: nil )
            
        }
        
    }
    
    private func showPokemon() {
        Timer.scheduledTimer(withTimeInterval: 8, repeats: true) { (timer) in
             
            if let coordenate = self.managerLocation.location?.coordinate {
                
                let anotation = PokemonAnotation(
                    coordinates: coordenate,
                    pokemon: self.generateRandomPokemons())

                let randomLat = ( Double( arc4random_uniform(400) ) - 200 ) / 100000.0
                let randomLon = ( Double( arc4random_uniform(400) ) - 200 ) / 100000.0

                anotation.coordinate = coordenate
                anotation.coordinate.latitude += randomLat
                anotation.coordinate.longitude += randomLon
                
                self.map.addAnnotation( anotation )
 
            }
        }
    }
    
    private func generateRandomPokemons() -> Pokemon {
        
        let indexRandom = arc4random_uniform( UInt32( self.pokemons.count ) )
        let pokemon = self.pokemons[ Int(indexRandom) ]
        
        return pokemon
    }
    
    private func centralizePlayer() {
        if let coordenate = managerLocation.location?.coordinate {
            let region = MKCoordinateRegion(center: coordenate, latitudinalMeters: 200, longitudinalMeters: 200)
            
            map.setRegion(region, animated: true)
        }
    }

    @IBAction func centralize(_ sender: Any) {
        centralizePlayer()
    }
    
    @IBAction func openPokedex(_ sender: Any) {
        
    }
    
}

