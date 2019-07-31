//
//  BeginRunVC.swift
//  Treads
//
//  Created by juger rash on 23.07.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import UIKit
import MapKit

class BeginRunVC: LocationVC {

    //Outlets -:
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        mapView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        manager?.delegate = self
        manager?.startUpdatingLocation()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        manager?.stopUpdatingLocation()
    }

    // Actions -:
    @IBAction func centerUserLocationBtnPressed(_ sender: Any) {
    }
    
}

extension BeginRunVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow // this to follow the user location without addin a radius or region .....
        }
    }
}

