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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        managerLocation.delegate = self
        
        managerLocation.requestWhenInUseAuthorization()
        managerLocation.startUpdatingLocation()
    }


}

