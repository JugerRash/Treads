//
//  CurrentRunVC.swift
//  Treads
//
//  Created by juger rash on 26.07.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import UIKit
import MapKit

class CurrentRunVC: LocationVC , UIGestureRecognizerDelegate {

    // Outlets -:
    @IBOutlet weak var swipeBGImageView: UIImageView!
    @IBOutlet weak var sliderImageView: UIImageView!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var paceLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var pauseBtn: UIButton!
    
    //Variables -:
    var firstLocation : CLLocation!
    var lastLocation : CLLocation!
    var timer = Timer()
    var runDistance  = 0.0
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(endRunSwipe(_:)))
        sliderImageView.addGestureRecognizer(swipeGesture)
        sliderImageView.isUserInteractionEnabled = true
        swipeGesture.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLocationAuthStatus()
        manager?.delegate = self
        manager?.distanceFilter = 10 // every 10 meters will update the map or location
        startRun()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        endRun()
    }
    
    
    // Functions -:
    func startRun(){
        manager?.startUpdatingLocation()
        startTimer()
    }
    func endRun(){
       manager?.stopUpdatingLocation()
    }
    func startTimer(){
        durationLbl.text = counter.formatingTimeSecondsToHours()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeCounter), userInfo: nil, repeats: true)
    }
    @objc func timeCounter(){
        counter += 1
        durationLbl.text = counter.formatingTimeSecondsToHours()
    }
    @IBAction func pauseBtnPressed(_ sender: Any) {
    }
    @objc func endRunSwipe(_ sender : UIPanGestureRecognizer){
        // wee need two points for the beginning and the endding of the swipe
        let minAdjust : CGFloat = 80
        let maxAdjust : CGFloat = 130
        if let sliderView = sender.view {
            if sender.state == UIGestureRecognizer.State.began || sender.state == UIGestureRecognizer.State.changed {
                let translation = sender.translation(in: self.view)
                if 	sliderView.center.x >= (swipeBGImageView.center.x - minAdjust) && sliderView.center.x <= (swipeBGImageView.center.x + maxAdjust){
                    sliderView.center.x = sliderView.center.x + translation.x
                }else if sliderView.center.x >= (swipeBGImageView.center.x + maxAdjust) {
                    sliderView.center.x = swipeBGImageView.center.x + maxAdjust
                    // end run code goes here
                    dismiss(animated: true, completion: nil)
                }else {
                    	sliderView.center.x = swipeBGImageView.center.x - minAdjust
                }
                
                sender.setTranslation(CGPoint.zero, in: self.view)
            } else if sender.state == UIGestureRecognizer.State.ended {
                UIView.animate(withDuration: 0.1) {
                    sliderView.center.x = self.swipeBGImageView.center.x - minAdjust
                }
            }
        }
    }
    
}

extension CurrentRunVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if firstLocation == nil {
            firstLocation = locations.first
        }else if let location = locations.last {
            runDistance += lastLocation.distance(from: location)
            distanceLbl.text = "\(runDistance.metersToMiles(places: 2))"
        }
        lastLocation = locations.last
    }
}
