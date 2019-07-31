//
//  CurrentRunVC.swift
//  Treads
//
//  Created by juger rash on 26.07.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import UIKit

class CurrentRunVC: LocationVC , UIGestureRecognizerDelegate {

    // Outlets -:
    @IBOutlet weak var swipeBGImageView: UIImageView!
    @IBOutlet weak var sliderImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(endRunSwipe(_:)))
        sliderImageView.addGestureRecognizer(swipeGesture)
        sliderImageView.isUserInteractionEnabled = true
        swipeGesture.delegate = self
        
    }
    
    // Functions -:
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
