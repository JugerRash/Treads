//
//  LocationVC.swift
//  Treads
//
//  Created by juger rash on 31.07.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import UIKit
import MapKit


class LocationVC: UIViewController  , MKMapViewDelegate{

    // Variables -:
    var manager : CLLocationManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CLLocationManager()
        // to make out map to be in the best accuracy we need to do the next two line because we need to track humen running not trackig a car or .......
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.activityType = .fitness
    }
    
    // Functions -:
    func checkLocationAuthStatus(){
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            manager?.requestWhenInUseAuthorization()
        }
    }


}
