//
//  BeginRunVC.swift
//  Treads
//
//  Created by juger rash on 23.07.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

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
        centerMapOnUserLocation()
    }
    @IBAction func closeLastRunViewpressed(_ sender: Any) {
        lastRunBGView.isHidden = true
        lastRunStackView.isHidden = true
        lastRunCloseBtn.isHidden = true
        centerMapOnUserLocation()
    }
    
    //Functions -:
    func centerMapOnPreRoute(locations : List<Location>) -> MKCoordinateRegion {
        guard let initialCoordinate = locations.first else { return MKCoordinateRegion()}
        var minLat = initialCoordinate.latitude
        var minLng = initialCoordinate.longitude
        var maxLat = initialCoordinate.latitude
        var maxLng = initialCoordinate.longitude
        
        for location in locations {
            minLat = min(minLat , location.latitude)
            minLng = min(minLng , location.longitude)
            maxLat = max(maxLat , location.latitude)
            maxLng = max(maxLng , location.longitude)
        }
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLng + maxLng) / 2 ), span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.4, longitudeDelta: (maxLng - minLng) * 1.4))
    }
    func centerMapOnUserLocation() {
        mapView.userTrackingMode = .follow
        let coordinateRegion = MKCoordinateRegion.init(center: mapView.userLocation.coordinate, latitudinalMeters: RADIUS, longitudinalMeters: RADIUS)
        mapView.setRegion(coordinateRegion, animated: true)
    }
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
            centerMapOnUserLocation()
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
        
        mapView.userTrackingMode = .none
        mapView.setRegion(centerMapOnPreRoute(locations: lastRun.locations), animated: true)
        
        //the following code is for just fetching and object of type Run by id
//        guard let locations = Run.getRun(byId: lastRun.id)?.locations else { return MKPolyline()}
//        mapView.setRegion(centerMapOnPreRoute(locations: locations), animated: true)
       // return MKPolyline(coordinates: coordinate, count: locations )
        
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
            // mapView.userTrackingMode = .follow // this to follow the user location without addin a radius or region .....
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

