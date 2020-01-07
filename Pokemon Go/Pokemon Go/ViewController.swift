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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        managerLocation.delegate = self
        
        managerLocation.requestWhenInUseAuthorization()
        managerLocation.startUpdatingLocation()
        
        showPokemon()
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
                let anotation = MKPointAnnotation()
                
                let randomLat = ( Double( arc4random_uniform(400) ) - 200 ) / 100000.0
                let randomLon = ( Double( arc4random_uniform(400) ) - 200 ) / 100000.0

                anotation.coordinate = coordenate
                anotation.coordinate.latitude += randomLat
                anotation.coordinate.longitude += randomLon
                
                self.map.addAnnotation( anotation )
            }
        }
    }
    
    private func centralizePlayer() {
        if let coordenate = managerLocation.location?.coordinate {
            let region = MKCoordinateRegion(center: coordenate, latitudinalMeters: 200, longitudinalMeters: 200)
            
            map.setRegion(region, animated: true)
            
            /*
            let userLocation: CLLocation = locations.last!
            
            let latitude: CLLocationDegrees = (userLocation.coordinate.latitude)
            let longitude: CLLocationDegrees = (userLocation.coordinate.longitude)
            
            let deltaLat: CLLocationDegrees = 0.01
            let deltaLog: CLLocationDegrees = 0.01
            
            let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let area: MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: deltaLat, longitudeDelta: deltaLog)
            let region: MKCoordinateRegion = MKCoordinateRegion.init(center: location, span: area)
            map.setRegion(region, animated: true)
            */
        }
    }

    @IBAction func centralize(_ sender: Any) {
        centralizePlayer()
    }
    
    @IBAction func openPokedex(_ sender: Any) {
        
    }
    
}

