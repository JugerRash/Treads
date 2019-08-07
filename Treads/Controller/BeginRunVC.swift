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
    @IBOutlet weak var lastRunBGView: UIView!
    @IBOutlet weak var lastRunStackView: UIStackView!
    @IBOutlet weak var lastRunPaceLbl: UILabel!
    @IBOutlet weak var lastRunDistanceLbl: UILabel!
    @IBOutlet weak var lastRunDurationLbl: UILabel!
    @IBOutlet weak var lastRunCloseBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        manager?.delegate = self
        mapView.delegate = self
        manager?.startUpdatingLocation()
        getLastRun()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpMapView()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        manager?.stopUpdatingLocation()
    }

    // Actions -:
    @IBAction func centerUserLocationBtnPressed(_ sender: Any) {
    }
    @IBAction func closeLastRunViewpressed(_ sender: Any) {
        lastRunBGView.isHidden = true
        lastRunStackView.isHidden = true
        lastRunCloseBtn.isHidden = true
    }
    
    //Functions -:
    func setUpMapView(){
        if let overlay = addLastRunToMap() {
            if mapView.overlays.count > 0 {
                mapView.removeOverlays(mapView.overlays)
            }
            mapView.addOverlay(overlay)
            lastRunBGView.isHidden = false
            lastRunStackView.isHidden = false
            lastRunCloseBtn.isHidden = false
        } else {
            lastRunBGView.isHidden = true
            lastRunStackView.isHidden = true
            lastRunCloseBtn.isHidden = true
        }
    }
    func addLastRunToMap() -> MKPolyline? {
        guard let lastRun = Run.getAllRuns()?.first else {
            return nil
        }
        lastRunPaceLbl.text = lastRun.pace.formatingTimeSecondsToHours()
        lastRunDistanceLbl.text = "\(lastRun.distance.metersToMiles(places: 2)) mi"
        lastRunDurationLbl.text = lastRun.duration.formatingTimeSecondsToHours()
        
        var coordinate = [CLLocationCoordinate2D]()
        for location in lastRun.locations {
            coordinate.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        }
        return MKPolyline(coordinates: coordinate, count: lastRun.locations.count)
    }
    func getLastRun(){
        guard let lastRun = Run.getAllRuns()?.first else {
            lastRunBGView.isHidden = true
            lastRunStackView.isHidden = true
            lastRunCloseBtn.isHidden = true
            return
        }
        lastRunBGView.isHidden = false
        lastRunStackView.isHidden = false
        lastRunCloseBtn.isHidden = false
        
        lastRunPaceLbl.text = lastRun.pace.formatingTimeSecondsToHours()
        lastRunDistanceLbl.text = "\(lastRun.distance.metersToMiles(places: 2)) mi"
        lastRunDurationLbl.text = lastRun.duration.formatingTimeSecondsToHours()
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        renderer.lineWidth = 4
        return renderer
    }
}

